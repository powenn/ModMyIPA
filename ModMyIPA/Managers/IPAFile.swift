//
//  IPAFile.swift
//  ModMyIPA
//
//  Created by 蕭博文 on 2022/10/24.
//

import Foundation
import ZipArchive

class IPAFile:ObservableObject {
    private init() {}
    static let shared = IPAFile()
    
    @Published var fileURL:URL = URL(fileURLWithPath: "")
    @Published var fileName:String = ""
    @Published var contentDirURL:URL = URL(fileURLWithPath: "")
    @Published var fileImported:Bool = false
    @Published var payloadURL:URL = URL(fileURLWithPath: "")
    @Published var payloadExist:Bool = false
    @Published var appContentExist:Bool = false
    @Published var infoPlistExist:Bool = false
    @Published var app_executableExist:Bool = false
    @Published var appNameInPayload:String = ""
    @Published var infoPlistPath:URL = URL(fileURLWithPath: "")
    
    var config: [String: Any]?
    @Published var app_executable:String = ""
    @Published var app_name:String = ""
    @Published var app_bundle:String = ""
    @Published var app_min_ios:String = ""
    
    @Published var processing:Bool = false
    
    func getPayloadURL()  {
        self.payloadURL = contentDirURL.appendingPathComponent("Payload")
        if FileManager.default.fileExists(atPath: payloadURL.path) {
            payloadExist=true
        } else {
            payloadExist = false
        }
    }
    
    func getAppNameInPayload() {
        let Content = try? FileManager.default.contentsOfDirectory(atPath: self.payloadURL.path)
        for content in Content! {
            if content.hasSuffix(".app") {
                appNameInPayload = content
                appContentExist = true
                break
            }
            appContentExist = false
        }
    }
    
    func getInfoPlistPath()  {
        if self.appContentExist {
            infoPlistPath = self.payloadURL.appendingPathComponent("\(self.appNameInPayload)/Info.plist")
        }
        if FileManager.default.fileExists(atPath: infoPlistPath.path){
            infoPlistExist = true
        } else {
            infoPlistExist = false
        }
    }
    
    func getInfoPlistValue() {
        do {
            // get Info in plist file
            let infoPlistData = try Data(contentsOf: infoPlistPath)
            if let dict = try PropertyListSerialization.propertyList(from: infoPlistData, options: [], format: nil) as? [String: Any] {
                config = dict
                // check is this Info.plist valid
                if ((config?["CFBundleExecutable"]) != nil) {
                    app_executable = (config?["CFBundleExecutable"] as! String)
                    app_name = config?["CFBundleName"] as! String
                    app_bundle = config?["CFBundleIdentifier"] as! String
                    app_min_ios = config?["MinimumOSVersion"] as! String? ?? "14.0"
                    app_executableExist = true
                } else {
                    app_executableExist = false
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateInfoPlistValue() {
        let plistDict = NSMutableDictionary(contentsOfFile: infoPlistPath.path)
        plistDict!.setObject(app_name, forKey: "CFBundleDisplayName" as NSCopying)
        plistDict!.write(toFile: infoPlistPath.path, atomically: false)
        plistDict!.setObject(app_bundle, forKey: "CFBundleIdentifier" as NSCopying)
        plistDict!.write(toFile: infoPlistPath.path, atomically: false)
    }
    
    func moveModdedPackage() {
        do {
            if appNameInPayload != "\(app_executable).app" {
                try FileManager.default.moveItem(at: payloadURL.appendingPathComponent(appNameInPayload), to: payloadURL.appendingPathComponent("\(app_executable).app"))
            }
            if FileManager.default.fileExists(atPath: tmpDirectory.appendingPathComponent(app_executable).path){
                try FileManager.default.removeItem(at: tmpDirectory.appendingPathComponent(app_executable))
            }
            try FileManager.default.moveItem(at: contentDirURL, to: tmpDirectory.appendingPathComponent(app_executable))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func zipToIPA() {
        SSZipArchive.createZipFile(atPath: outputDirectory.appendingPathComponent("\(app_executable).ipa").path,withContentsOfDirectory: tmpDirectory.appendingPathComponent(app_executable).path)
    }
            
    func resultIPAExist() -> Bool {
        return FileManager.default.fileExists(atPath: outputDirectory.appendingPathComponent("\(app_executable).ipa").path)
    }
    
}

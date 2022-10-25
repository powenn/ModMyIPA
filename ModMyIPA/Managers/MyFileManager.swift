//
//  FileManager.swift
//  ModMyIPA
//
//  Created by 蕭博文 on 2022/10/24.
//

import Foundation
import ZipArchive

class MyFileManager {
    private init() {}
    static let shared = MyFileManager()
    
    func setUpPath() {
        if !FileManager.default.fileExists(atPath: tmpDirectory.path) {
            try? FileManager.default.createDirectory(
                at: tmpDirectory,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
        if !FileManager.default.fileExists(atPath: outputDirectory.path) {
            try? FileManager.default.createDirectory(
                at: outputDirectory,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
    }
    
    func resetTmp() {
        try? FileManager.default.removeItem(at: tmpDirectory)
        try? FileManager.default.createDirectory(
            at: tmpDirectory,
            withIntermediateDirectories: true,
            attributes: nil
        )
    }
    
    func resetOutput() {
        try? FileManager.default.removeItem(at: outputDirectory)
        try? FileManager.default.createDirectory(
            at: outputDirectory,
            withIntermediateDirectories: true,
            attributes: nil
        )
    }
    
    func extractIpa() {
        var destination:URL
        guard IPAFile.shared.fileURL.startAccessingSecurityScopedResource() else {
            return
        }
        do {
            destination  = tmpDirectory.appendingPathComponent(IPAFile.shared.fileName.replacingOccurrences(of: ".ipa", with: ".zip"))
            IPAFile.shared.contentDirURL = tmpDirectory.appendingPathComponent(IPAFile.shared.fileName.replacingOccurrences(of: ".ipa", with: ""))
            if FileManager.default.fileExists(atPath: destination.path) {
                try FileManager.default.removeItem(atPath: destination.path)
            }
            try FileManager.default.copyItem(at: IPAFile.shared.fileURL, to: destination)
            print("Copied file from \(IPAFile.shared.fileURL.path) to \(destination.path)")
            try SSZipArchive.unzipFile(atPath: destination.path, toDestination: IPAFile.shared.contentDirURL.path, overwrite: true, password: nil)
            print("Unzipped file from \(destination.path)to\(IPAFile.shared.contentDirURL.path)")
            IPAFile.shared.fileImported = true
            
        } catch {
            print(error.localizedDescription)
        }
        IPAFile.shared.fileURL.stopAccessingSecurityScopedResource()
    }
}

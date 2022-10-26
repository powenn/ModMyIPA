//
//  MainView.swift
//  ModMyIPA
//
//  Created by 蕭博文 on 2022/10/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct MainView: View {
    @StateObject var myuserdefaults:MyUserDefaults = .shared
    @StateObject var ipafile:IPAFile = .shared
    
    @State var isImporting: Bool = false
    @State var showInvalidAlert:Bool = false
    @State var alertTitle:String = ""
    @State var alertMeaasge:String = ""
    
    @State var showEditInfo:Bool = false
    @State var showSuccessedAlert:Bool = false
    
    func invalidFileAlert(title:String, message:String) {
        ipafile.fileName = ""
        alertTitle = title
        alertMeaasge = message
        showInvalidAlert.toggle()
        ipafile.fileImported = false
    }
    
    var body: some View {
        VStack{
            Text(ipafile.fileName != "" ? ipafile.fileName: "No .ipa file selected").padding()
            Button("Select IPA File", action: {
                print("Select file button pressed")
                isImporting.toggle()
            }).disabled(ipafile.processing || isImporting)
                .padding()
                .alert(isPresented: $showInvalidAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMeaasge), dismissButton: .default(Text("OK")))
                }
                .fileImporter(
                    isPresented: $isImporting,
                    allowedContentTypes: [UTType(filenameExtension: "ipa")!],
                    allowsMultipleSelection: false
                ) { result in
                    do {
                        ipafile.fileURL = try result.get().first!
                        ipafile.fileName = ipafile.fileURL.lastPathComponent
                        print(ipafile.fileURL.path,ipafile.fileName)
                        MyFileManager.shared.extractIpa()
                        ipafile.getPayloadURL()
                        if !ipafile.payloadExist {
                            invalidFileAlert(title: "Invalid IPA File", message: "There is no payload content found")
                            return
                        }
                        ipafile.getAppNameInPayload()
                        if !ipafile.appContentExist {
                            invalidFileAlert(title: "Invalid IPA File", message: "There is no app content inside payload")
                            return
                        }
                        ipafile.getInfoPlistPath()
                        if !ipafile.infoPlistExist {
                            invalidFileAlert(title: "Invalid IPA File", message: "There is no info.plist inside app content")
                            return
                        }
                        ipafile.getInfoPlistValue()
                        if !ipafile.app_executableExist {
                            invalidFileAlert(title: "Invalid IPA File", message: "There is no executable binary inside app content")
                            return
                        }
                        print(ipafile.appNameInPayload)
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            Button("Edit IPA Info", action: {
                print("Edit IPA_INFO button pressed")
                showEditInfo.toggle()
            }).sheet(isPresented: $showEditInfo, content: {
                EditAppInfoView()
            })
            .disabled(!ipafile.fileImported||ipafile.processing)
            .padding()
            Button("Mod it", action: {
                print("Mod button pressed")
                print("APPNAME:\(ipafile.app_name)\nPACKAGENAME:\(ipafile.app_executable)\nAPPBUNDLE:\(ipafile.app_bundle)")
                ipafile.processing = true
                DispatchQueue.global(qos: .userInitiated).async {
                    ipafile.updateInfoPlistValue()
                    ipafile.moveModdedPackage()
                    ipafile.zipToIPA()
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        ipafile.fileName = ""
                        ipafile.fileImported = false
                        ipafile.processing = false
                        if ipafile.resultIPAExist() {
                            showSuccessedAlert.toggle()
                        }
                    }
                }
            })
            .alert(isPresented: $showSuccessedAlert) {
                Alert(title: Text("Done"), message: Text("Success modded"), dismissButton: .default(Text("OK")))
            }
            .disabled(!ipafile.fileImported||ipafile.processing)
            .padding()
            if ipafile.processing {
                ProgressView(label: {
                    Text("Processing")
                })
            }
            
            if isImporting {
                ProgressView(label: {
                    Text("Importing IPA File")
                })
            }
        }.padding()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

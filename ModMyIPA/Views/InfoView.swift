//
//  InfoView.swift
//  ModMyIPA
//
//  Created by 蕭博文 on 2022/10/24.
//

import SwiftUI

struct InfoView: View {
    @StateObject var myuserdefaults:MyUserDefaults = .shared
    @State var showPackagesList:Bool = false
    
    var body: some View {
        Form {
            Section(header: Text("version")){
                Text("\(appVersion!).\(buildVersion!)")
            }
            Section(header: Text("View files"), content: {
                Button("View the output package list", action: {
                    print("View package list button pressed")
                    showPackagesList.toggle()
                }).sheet(isPresented: $showPackagesList, content: {
                    NavigationView {
                        PackageListView()
                            .navigationBarTitle("PackageList", displayMode: .inline)
                    }
                })
            })
            
            Section(header: Text("Clean up"), content: {
                Button("Clean up tmp directory", action: {
                    MyFileManager.shared.resetTmp()
                })
                Button("Clean up output directory", action: {
                    MyFileManager.shared.resetOutput()
                })
            })
            Section(header: Text("source code")){
                Link(destination: URL(string: "https://github.com/powenn/ModMyIPA")!, label: {
                    HStack{
                        Text("View on Github")
                    }
                })
            }
            
            Section(footer: Text("Made by @powenn"), content: {})
            Section(footer: Text("Output files path : \(outputDirectory.path)"), content: {})
            Section(footer: Text("A nice sentence inspired me\nfrom a nice guy named yammy in Discord\n\"If it's what you want to do,\ndon't let anybody stop you\""), content: {})
            
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}

//
//  ModifyView.swift
//  ModMyIPA
//
//  Created by 蕭博文 on 2022/10/24.
//

import SwiftUI

struct EditAppInfoView: View {
    @StateObject var ipafile:IPAFile = .shared
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            VStack(alignment: .leading) {
                Text("Customize App Name")
                TextField("App Name", text: $ipafile.app_name)
                    .textFieldStyle(.roundedBorder)
                Text("Customize App Package Name\n(The name of .app directory)")
                TextField("App Package Name", text: $ipafile.app_executable)
                    .textFieldStyle(.roundedBorder)
                Text("Customize App Bundle")
                TextField("App Bundle", text: $ipafile.app_bundle)
                    .textFieldStyle(.roundedBorder)
            }.padding()
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Done")
            }).padding()
        }
        .padding()
        .onTapGesture {
            hideKeyboard()
        }
    }
}

struct EditAppInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EditAppInfoView()
    }
}

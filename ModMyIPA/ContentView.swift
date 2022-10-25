//
//  ContentView.swift
//  ModMyIPA
//
//  Created by 蕭博文 on 2022/10/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            MainView()
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarTitle("ModMyIPA")
                .toolbar(content: {
                    NavigationLink(destination: {
                        InfoView()
                    }, label: {
                        Image(systemName: "info.circle")
                    })
                })
        }.onAppear(perform: {
            MyFileManager.shared.resetTmp()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

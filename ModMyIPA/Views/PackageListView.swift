//
//  PackageLIstView.swift
//  ModMyIPA
//
//  Created by 蕭博文 on 2022/10/25.
//

import SwiftUI

struct PackageListView: View {
    @State var packageList = try! FileManager.default.contentsOfDirectory(atPath: outputDirectory.path)
    @State var showShareSheet:Bool = false
    @State var selectedPackage:String = ""
    
    var body: some View {
        List {
            ForEach(packageList, id: \.self) { package in
                HStack{
                    Text(package)
                        .font(.title3)
                    Spacer()
                    Button("", action: {
                        print("\(package) share tapped!")
                        showShareSheet.toggle()
                    }).sheet(isPresented: $showShareSheet, content: {
                        ShareSheet(activityItems: [outputDirectory.appendingPathComponent(package)])
                    })
                }
                .contentShape(Rectangle())
                .padding()
            }
            .onDelete(perform: deleteItem)
        }
        .listStyle(.automatic)
    }
    
    func deleteItem(at indexSet: IndexSet) {
        let tmpList = packageList
        packageList.remove(atOffsets: indexSet)
        let deleted:String = Set(tmpList).symmetricDifference(Set(packageList)).first!
        try! FileManager.default.removeItem(atPath: outputDirectory.appendingPathComponent(deleted).path)
        print("Deleted:\(deleted)")
        print("Left:\(packageList)")
    }
}

struct PackageListView_Previews: PreviewProvider {
    static var previews: some View {
        PackageListView()
    }
}

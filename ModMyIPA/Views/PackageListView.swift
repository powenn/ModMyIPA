//
//  PackageLIstView.swift
//  ModMyIPA
//
//  Created by 蕭博文 on 2022/10/25.
//

import SwiftUI

struct PackageListView: View {
    @State var packageList = try! FileManager.default.contentsOfDirectory(atPath: outputDirectory.path)
    
    var body: some View {
        List {
            ForEach(packageList, id: \.self) { package in
                Text(package)
                    .font(.title3)
            }
            .onDelete(perform: deleteItem)
        }
        .listStyle(.automatic)
    }
    
    func deleteItem(at indexSet: IndexSet) {
        packageList.remove(atOffsets: indexSet)
        print(indexSet.first!)
        // NEED TEST
        try! FileManager.default.removeItem(atPath: outputDirectory.appendingPathComponent(packageList[indexSet.first!]).path)
    }
}

struct PackageListView_Previews: PreviewProvider {
    static var previews: some View {
        PackageListView()
    }
}

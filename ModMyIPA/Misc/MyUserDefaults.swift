//
//  UserDefaults.swift
//  ModMyIPA
//
//  Created by 蕭博文 on 2022/10/24.
//

import Foundation
import SwiftUI

class MyUserDefaults:ObservableObject {
    private init() {}
    static let shared = MyUserDefaults()
    @AppStorage("modmyipa.preference.debugging") var debugging = true
}

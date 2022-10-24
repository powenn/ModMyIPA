//
//  Version.swift
//  ModMyIPA
//
//  Created by 蕭博文 on 2022/10/24.
//

import Foundation

let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String

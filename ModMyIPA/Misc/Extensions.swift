//
//  Extensions.swift
//  ModMyIPA
//
//  Created by 蕭博文 on 2022/10/24.
//

import Foundation
import SwiftUI

// Press anywhere to hide keyboard
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

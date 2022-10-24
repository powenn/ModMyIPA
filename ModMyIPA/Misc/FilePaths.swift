//
//  FilePaths.swift
//  ModMyIPA
//
//  Created by 蕭博文 on 2022/10/24.
//

import Foundation

let docPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
let tmpDirectory = docPath.appendingPathComponent("tmp")
let outputDirectory = docPath.appendingPathComponent("output")

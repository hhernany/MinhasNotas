//
//  Configuration.swift
//  MinhasPautasUITests
//
//  Created by Hugo Hernany on 08/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation

// Default values. Add or change during tests when necessary
final class ConfigurationUITests {
    var dictionary: [String: String] = [
        ConfigurationKeys.isFirstTimeUser: String(false),
        ConfigurationKeys.isUITest: String(true),
        "FakeData_email_usuario": "test@gmail.com",
        "FakeData_nome_usuario": "User Test"
    ]
}

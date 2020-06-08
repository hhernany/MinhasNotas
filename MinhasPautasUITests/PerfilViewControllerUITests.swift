//
//  PerfilViewControllerUITests.swift
//  MinhasPautasUITests
//
//  Created by Hugo Hernany on 11/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest

class PerfilViewControllerUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = start(using: Configuration())
    }

    func testPerfilTabContentAndLogout() {
        app.tabBars.buttons["Perfil"].tap() // Change tab
        
        XCTAssert(app.tables["perfilTableViewOptions"].exists, "perfilTableViewOptions dont exists")
        XCTAssert(app.staticTexts["User Test"].exists, "Name is incorret or dont exist")
        XCTAssert(app.staticTexts["test@gmail.com"].exists, "Email is incorret or dont exist")

        app.tables.staticTexts["Sair"].tap() // Logout
    }
    
    override func tearDown() {
        super.tearDown()
        app = nil
    }
}

// Default values. Add or change during tests when necessary
final class Configuration {
    var dictionary: [String: String] = [
        ConfigurationKeys.isFirstTimeUser: String(false),
        ConfigurationKeys.isUITest: String(true),
        "FakeData_email_usuario": "test@gmail.com",
        "FakeData_nome_usuario": "User Test"
    ]
}

// Posso criar extensões para permitir encadeamento. (Configuration().isFirsTimeUser().isUITest()
// Não é obrigatório, é mais questão de estética ou facilidades.
//extension Configuration {
//    func isFirstTimeUser() -> Self { // 1
//        dictionary[ConfigurationKeys.isFirstTimeUser] = String(true)
//        return self
//    }
//}



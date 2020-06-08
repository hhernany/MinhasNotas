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
    
    override func setUpWithError() throws {
        super.setUp()
        app = start(using: ConfigurationUITests())
    }

    override func tearDownWithError() throws {
        super.tearDown()
        app = nil
    }
    
    func testPerfilTabContentAndLogout() throws{
        app.tabBars.buttons["Perfil"].tap() // Change tab
        
        XCTAssert(app.tables["perfilTableViewOptions"].exists, "perfilTableViewOptions dont exists")
        XCTAssert(app.staticTexts["User Test"].exists, "Name is incorret or dont exist")
        XCTAssert(app.staticTexts["test@gmail.com"].exists, "Email is incorret or dont exist")

        app.tables.staticTexts["Sair"].tap() // Logout
    }
}


// Posso criar extensões para permitir encadeamento. (Configuration().isFirsTimeUser().isUITest()
// Não é obrigatório, é mais questão de estética ou facilidades.
//extension Configuration {
//    func isFirstTimeUser() -> Self { // 1
//        dictionary[ConfigurationKeys.isFirstTimeUser] = String(true)
//        return self
//    }
//}



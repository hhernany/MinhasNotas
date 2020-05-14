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
        continueAfterFailure = false
        app = start(using: Configuration())
    }

    func testPerfilTabContentAndLogout() {
        app.tabBars.buttons["Perfil"].tap() // Change tab
        XCTAssertTrue(app.staticTexts["User Test"].exists)
        XCTAssertTrue(app.staticTexts["test@gmail.com"].exists)
        app.tables.staticTexts["Sair"].tap() // Logout
    }
    
    override func tearDown() {
        super.tearDown()
        app = nil
    }
}

// Primeito teste. Uma classe de configuração para iniciar o teste.
extension XCTestCase {
    func start(using configuration: Configuration) -> XCUIApplication {
        continueAfterFailure = false // Stop execution after a failure occurs
        let app = XCUIApplication() // Create instance
        let configuration = Configuration()
        app.launchEnvironment.merge((configuration.dictionary), uniquingKeysWith: { (_, new) in new }) // Add launch parameters
        app.launchArguments += ["UI-Testing"]
        app.launch() // Launch app
        return app // Return instance
    }
}

// Separar em outro arquivo caso der certo.
final class Configuration {
    var dictionary: [String: String] = [
        ConfigurationKeys.isFirstTimeUser: String(true),
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

// Existe o caso aonde eu vou entrar direto no app, ou seja, preciso de um token ou testar de outra forma quando for em teste (util para o problema do firebase Auth)
// Existe o caso aonde eu vou ter que ficar na tela de login, e não entrar diretamente no app.

// 1 - Quando eu entrar no app, no caso do Perfil, tem variáveis que eu quero salvar localmente para testar (uma função genérica que controla isso?)


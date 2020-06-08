//
//  LoginViewControllerUITests
//  MinhasPautasUITests
//
//  Created by Hugo Hernany on 08/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest

class LoginViewControllerUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        super.setUp()
        let configuration = ConfigurationUITests()
        configuration.dictionary[ConfigurationKeys.isFirstTimeUser] = "true"
        app = start(using: configuration)
    }

    override func tearDownWithError() throws {
        super.tearDown()
        app = nil
    }
    
    func testEmptyEmailAndPassword() throws {
        // Check fields and buttons
        let emailTextField = try XCTUnwrap(app.textFields["emailTextField"], "emailTextField dont exist.")
        let _ = try XCTUnwrap(app.secureTextFields["passwordTextField"], "passwordTextField dont exist.")
        let connectButton = try XCTUnwrap(app.buttons["connectButton"], "connectButton dont exist.")

        // Empty email
        connectButton.tap()
        XCTAssert(waitForElementToAppear(app.alerts.element.staticTexts["Informe o e-mail de acesso."]), "Alert did not appear.")
        intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")
        
        // Valid email and empty password
        emailTextField.tap()
        emailTextField.typeText("hugo@gmail.com")
        connectButton.tap()
        XCTAssert(waitForElementToAppear(app.alerts.element.staticTexts["Informe a senha de acesso."]), "Alert did not appear.")
        intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")
    }
    
    // This test need internet connection to check password in Firebase
    func testInvalidEmailAndPassword() throws {
        // Check fields and buttons
        let emailTextField = try XCTUnwrap(app.textFields["emailTextField"], "emailTextField dont exist.")
        let connectButton = try XCTUnwrap(app.buttons["connectButton"], "connectButton dont exist.")
        
        // Invalid E-mail
        emailTextField.tap()
        emailTextField.typeText("invalidemail")
        connectButton.tap()
        XCTAssert(waitForElementToAppear(app.alerts.element.staticTexts["E-mail inválido."]), "Alert did not appear.")
        intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")
    }
    
    func testInvalidPassword() throws {
        // Check fields and buttons
        let emailTextField = try XCTUnwrap(app.textFields["emailTextField"], "emailTextField dont exist.")
        let passwordTextField = try XCTUnwrap(app.secureTextFields["passwordTextField"], "passwordTextField dont exist.")
        let connectButton = try XCTUnwrap(app.buttons["connectButton"], "connectButton dont exist.")
        
        // Valid e-mail and invalid password
        emailTextField.tap()
        emailTextField.typeText("hugo@gmail.com")

        passwordTextField.tap()
        passwordTextField.typeText("123123123")
        connectButton.tap()
        XCTAssert(waitForElementToAppear(app.alerts.element.staticTexts["A senha informada está incorreta."]), "Alert did not appear.")
        intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")
    }
}

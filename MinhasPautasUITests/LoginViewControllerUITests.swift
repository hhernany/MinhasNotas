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

    override func setUp() {
        super.setUp()
        let configuration = Configuration()
        configuration.dictionary[ConfigurationKeys.isFirstTimeUser] = "true"
        app = start(using: configuration)
    }

    func testEmptyEmailAndPassword() {
        // Check fields and buttons
        XCTAssert(app.textFields["emailTextField"].exists, "emailTextField dont exist.")
        XCTAssert(app.secureTextFields["passwordTextField"].exists, "passwordTextField dont exist.")
        XCTAssert(app.buttons["connectButton"].exists, "connectButton dont exist.")

        // Empty email
        tapButton(app: app, identifier: "connectButton")
        XCTAssert(waitForElementToAppear(app.alerts.element.staticTexts["Informe o e-mail de acesso."]), "Alert did not appear.")
        intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")
        
        // Valid email and empty password
        let textField = app.textFields["emailTextField"]
        textField.tap()
        textField.typeText("hugo@gmail.com")
        tapButton(app: app, identifier: "connectButton")
        XCTAssert(waitForElementToAppear(app.alerts.element.staticTexts["Informe a senha de acesso."]), "Alert did not appear.")
        intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")
    }
    
    // This test need internet connection to check password in Firebase
    func testInvalidEmailAndPassword() {
        // Check fields and buttons
        XCTAssert(app.textFields["emailTextField"].exists, "emailTextField dont exist.")
        XCTAssert(app.secureTextFields["passwordTextField"].exists, "passwordTextField dont exist.")
        XCTAssert(app.buttons["connectButton"].exists, "connectButton dont exist.")
        
        // Text fields
        let emailTextField = app.textFields["emailTextField"]
        let passwordTextField = app.secureTextFields["passwordTextField"]

        // Invalid E-mail
        emailTextField.tap()
        emailTextField.typeText("invalidemail")
        tapButton(app: app, identifier: "connectButton")
        XCTAssert(waitForElementToAppear(app.alerts.element.staticTexts["E-mail inválido."]), "Alert did not appear.")
        intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")

        // Valid e-mail and invalid password
        emailTextField.doubleTap()
        //app.menuItems["Select All"].tap()
        app.menuItems["Cut"].tap()
        
        //emailTextField.tap()
        emailTextField.typeText("hugo@gmail.com")

        passwordTextField.tap()
        passwordTextField.typeText("123123123")
        tapButton(app: app, identifier: "connectButton")
        XCTAssert(waitForElementToAppear(app.alerts.element.staticTexts["A senha informada está incorreta."]), "Alert did not appear.")
        intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")
    }
    
    override func tearDown() {
        super.tearDown()
    }
}

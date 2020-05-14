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
        continueAfterFailure = false // In UI tests it is usually best to stop immediately when a failure occurs.
        UserDefaults.standard.removeObject(forKey: "token_jwt")
        app = XCUIApplication() // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()
    }

    func testEmptyEmailAndPassword() {
        // Empty email
        tapButton(identifier: "connectButton")
        XCTAssert(app.alerts.element.staticTexts["Informe o e-mail de acesso."].exists)
        intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")
        
        // Valid email and empty password
        let textField = app.textFields["emailTextField"]
        textField.tap()
        textField.typeText("hugo@gmail.com")
        tapButton(identifier: "connectButton")
    
        XCTAssert(app.alerts.element.staticTexts["Informe a senha de acesso."].exists)
    }
    
    func testInvalidEmailAndPassword() {
        // Text fields
        let emailTextField = app.textFields["emailTextField"]
        let passwordTextField = app.secureTextFields["passwordTextField"]

        // Invalid E-mail
        emailTextField.tap()
        emailTextField.typeText("invalidemail")
        tapButton(identifier: "connectButton")
        XCTAssert(app.alerts.element.staticTexts["E-mail inválido."].exists)
        intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")

        // Valid e-mail and invalid password
        emailTextField.doubleTap()
        app.menuItems["Select All"].tap()
        app.menuItems["Cut"].tap()
        
        emailTextField.tap()
        emailTextField.typeText("hugo@gmail.com")

        passwordTextField.tap()
        passwordTextField.typeText("123123123")
        tapButton(identifier: "connectButton")
        print(app.alerts.element.staticTexts)
        sleep(1)
        XCTAssert(app.alerts.element.staticTexts["A senha informada está incorreta."].exists)
    }

    func tapButton(identifier buttonIdentifier: String) {
        app.buttons[buttonIdentifier].tap()
    }
    
    // Create a helper of this
    func intercepetAndCloseAlerts(name withTitle: String, button buttonName: String) {
        addUIInterruptionMonitor(withDescription: withTitle) { (alerts) -> Bool in
            if alerts.buttons[buttonName].exists {
                alerts.buttons[buttonName].tap()
            }
            return true
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
}

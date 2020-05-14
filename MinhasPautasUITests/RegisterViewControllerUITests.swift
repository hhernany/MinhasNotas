//
//  RegisterViewControllerUITests.swift
//  MinhasPautasUITests
//
//  Created by Hugo Hernany on 08/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest

class RegisterViewControllerUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false // In UI tests it is usually best to stop immediately when a failure occurs.
        UserDefaults.standard.removeObject(forKey: "token_jwt")
        app = XCUIApplication() // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()
        tapButton(identifier: "registerButton")
    }

    func testRegisterFieldsAndAlerts() {
        let nameTextField = app.textFields["nameTextField"]
        let emailTextField = app.textFields["emailTextField"]
        let emailConfirmationTextField = app.textFields["emailConfirmationTextField"]
        let passwordTextField = app.secureTextFields["passwordTextField"]
        let passwordConfirmationTextField = app.secureTextFields["passwordConfirmationTextField"]
        
        // Name empty
        tapButton(identifier: "confirmButton")
        sleep(1)
        XCTAssert(app.alerts.element.staticTexts["Informe o seu nome."].exists)
        intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")

        // Email empty
        nameTextField.tap()
        nameTextField.typeText("UI Test")
        if app.keyboards.buttons["Continuar"].exists {
            app.keyboards.buttons["Continuar"].tap()
        }
        tapButton(identifier: "confirmButton")
        sleep(1)
        XCTAssert(app.alerts.element.staticTexts["Informe o email."].exists)
        intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")

        // Invalid email
        emailTextField.tap()
        emailTextField.typeText("invalidemail")
        if app.keyboards.buttons["Continuar"].exists {
            app.keyboards.buttons["Continuar"].tap()
        }
        tapButton(identifier: "confirmButton")
        sleep(1)
        XCTAssert(app.alerts.element.staticTexts["E-mail inválido."].exists)
        intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")

        // Valid e-mail and E-mail confirmation empty
        emailTextField.doubleTap()
        app.menuItems["Select All"].tap()
        app.menuItems["Cut"].tap()
        emailTextField.tap()
        emailTextField.typeText("teste@gmail.com")
        if app.keyboards.buttons["Continuar"].exists {
            app.keyboards.buttons["Continuar"].tap()
        }
        tapButton(identifier: "confirmButton")
        sleep(1)
        XCTAssert(app.alerts.element.staticTexts["Informe a confirmação do e-mail."].exists)
        intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")

        // E-mail confirmation not match
        emailConfirmationTextField.tap()
        emailConfirmationTextField.typeText("teste2@gmail.com")
        if app.keyboards.buttons["Continuar"].exists {
            app.keyboards.buttons["Continuar"].tap()
        }
        tapButton(identifier: "confirmButton")
        sleep(1)
        XCTAssert(app.alerts.element.staticTexts["Os emails informados não coincidem."].exists)
        intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")

        // Valid e-mail and confirmation match, with empty password
        emailConfirmationTextField.doubleTap()
        app.menuItems["Select All"].tap()
        app.menuItems["Cut"].tap()
        emailConfirmationTextField.tap()
        emailConfirmationTextField.typeText("teste@gmail.com")
        if app.keyboards.buttons["Continuar"].exists {
            app.keyboards.buttons["Continuar"].tap()
        }
        tapButton(identifier: "confirmButton")
        sleep(1)
        XCTAssert(app.alerts.element.staticTexts["Informe uma senha."].exists)
        intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")
        
        // Password and Confirmation password empty
        passwordTextField.tap()
        passwordTextField.typeText("12345")
        if app.keyboards.buttons["Continuar"].exists {
            app.keyboards.buttons["Continuar"].tap()
        }
        tapButton(identifier: "confirmButton")
        sleep(1)
        XCTAssert(app.alerts.element.staticTexts["Informe a confirmação da senha."].exists)
        intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")
        
        // Password and Confirmation password dont match
        passwordConfirmationTextField.tap()
        passwordConfirmationTextField.typeText("123456")
        if app.keyboards.buttons["Continuar"].exists {
            app.keyboards.buttons["Continuar"].tap()
        }
        tapButton(identifier: "confirmButton")
        sleep(1)
        XCTAssert(app.alerts.element.staticTexts["As senhas informadas não coincidem."].exists)
        intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")
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
        app = nil
    }
}

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
        super.setUp()
        let configuration = Configuration()
        configuration.dictionary[ConfigurationKeys.isFirstTimeUser] = "true"
        app = start(using: configuration)
    }

    func testRegisterFieldsAndAlerts() {
        tapButton(app: app, identifier: "registerButton")

        // Check if fields exists
        XCTAssert(app.textFields["nameTextField"].exists, "RegisterViewController: nameTextField dont exists")
        XCTAssert(app.textFields["emailTextField"].exists, "RegisterViewController: emailTextField dont exists")
        XCTAssert(app.textFields["emailConfirmationTextField"].exists, "RegisterViewController: emailConfirmationTextField dont exists")
        XCTAssert(app.secureTextFields["passwordTextField"].exists, "RegisterViewController: passwordTextField dont exists")
        XCTAssert(app.secureTextFields["passwordConfirmationTextField"].exists, "RegisterViewController: passwordConfirmationTextField dont exists")

        // Declare fields
        let nameTextField = app.textFields["nameTextField"]
        let emailTextField = app.textFields["emailTextField"]
        let emailConfirmationTextField = app.textFields["emailConfirmationTextField"]
        let passwordTextField = app.secureTextFields["passwordTextField"]
        let passwordConfirmationTextField = app.secureTextFields["passwordConfirmationTextField"]
        
        // Name empty
        tapButton(app: app, identifier: "confirmButton")
        XCTAssert(waitForElementToAppear(app.alerts.element.staticTexts["Informe o seu nome."]), "Alert did not appear.")
        intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")

        // Email empty
        nameTextField.tap()
        nameTextField.typeText("UI Test")
        if app.keyboards.keys.count > 0 {
            app.keyboards.buttons["Continuar"].tap()
        }
        tapButton(app: app, identifier: "confirmButton")
        XCTAssert(waitForElementToAppear(app.alerts.element.staticTexts["Informe o email."]), "Alert did not appear.")
        intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")

        // Invalid email
        emailTextField.tap()
        emailTextField.typeText("invalidemail")
        if app.keyboards.keys.count > 0 {
            app.keyboards.buttons["Continuar"].tap()
        }
        tapButton(app: app, identifier: "confirmButton")
        XCTAssert(waitForElementToAppear(app.alerts.element.staticTexts["E-mail inválido."]), "Alert did not appear.")
        intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")

        // Valid e-mail and E-mail confirmation empty
        emailTextField.doubleTap()
        app.menuItems["Select All"].tap()
        app.menuItems["Cut"].tap()
        emailTextField.tap()
        emailTextField.typeText("teste@gmail.com")
        if app.keyboards.keys.count > 0 {
            app.keyboards.buttons["Continuar"].tap()
        }
        tapButton(app: app, identifier: "confirmButton")
        XCTAssert(waitForElementToAppear(app.alerts.element.staticTexts["Informe a confirmação do e-mail."]), "Alert did not appear.")
        intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")

        // E-mail confirmation not match
        emailConfirmationTextField.tap()
        emailConfirmationTextField.typeText("teste2@gmail.com")
        if app.keyboards.keys.count > 0 {
            app.keyboards.buttons["Continuar"].tap()
        }
        tapButton(app: app, identifier: "confirmButton")
        XCTAssert(waitForElementToAppear(app.alerts.element.staticTexts["Os emails informados não coincidem."]), "Alert did not appear.")
        intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")

        // Valid e-mail and confirmation match, with empty password
        emailConfirmationTextField.doubleTap()
        app.menuItems["Select All"].tap()
        app.menuItems["Cut"].tap()
        emailConfirmationTextField.tap()
        emailConfirmationTextField.typeText("teste@gmail.com")
        if app.keyboards.keys.count > 0 {
            app.keyboards.buttons["Continuar"].tap()
        }
        tapButton(app: app, identifier: "confirmButton")
        XCTAssert(waitForElementToAppear(app.alerts.element.staticTexts["Informe uma senha."]), "Alert did not appear.")
        intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")

        // Password and Confirmation password empty
        passwordTextField.tap()
        passwordTextField.typeText("12345")
        if app.keyboards.keys.count > 0 {
            app.keyboards.buttons["Continue"].tap()
        }
        tapButton(app: app, identifier: "confirmButton")
        XCTAssert(waitForElementToAppear(app.alerts.element.staticTexts["Informe a confirmação da senha."]), "Alert did not appear.")
        intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")

        // Password and Confirmation password dont match
        passwordConfirmationTextField.tap()
        passwordConfirmationTextField.typeText("123456")
        if app.keyboards.keys.count > 0 {
            app.keyboards.buttons["Continue"].tap()
        }
        tapButton(app: app, identifier: "confirmButton")
        XCTAssert(waitForElementToAppear(app.alerts.element.staticTexts["As senhas informadas não coincidem."]), "Alert did not appear.")
        intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")
    }

    override func tearDown() {
        super.tearDown()
        app = nil
    }
}

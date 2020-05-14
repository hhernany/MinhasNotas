//
//  ResetPasswordViewControllerUITests.swift
//  MinhasPautasUITests
//
//  Created by Hugo Hernany on 08/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest

class ResetPasswordViewControllerUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        let configuration = Configuration()
        configuration.dictionary[ConfigurationKeys.isFirstTimeUser] = "true"
        app = start(using: configuration)
    }
    
    func testResetPasswordEmailField() {
        XCTAssert(app.buttons["resetPasswordButton"].exists, "LoginViewController: resetPasswordButton dont exists") // Check if button exists
        tapButton(app: app, identifier: "resetPasswordButton")

        XCTAssert(app.buttons["confirmButton"].exists, "ResetPasswordViewController: confirmButton dont exists") // Check if button exists
        XCTAssert(app.textFields["emailTextField"].exists, "ResetPasswordViewController: emailTextField dont exists") // Check if field exists
        tapButton(app: app, identifier: "confirmButton")

        // Check if the alert has appeared (Empty email field)
        XCTAssert(waitForElementToAppear(app.alerts.element.staticTexts["Informe o email."]), "Alert did not appear")
        intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")
        
        // Invalid e-mail
        let textField = app.textFields["emailTextField"]
        textField.tap()
        textField.typeText("invalidemail")
        tapButton(app: app, identifier: "confirmButton")

        XCTAssert(waitForElementToAppear(app.alerts.element.staticTexts["E-mail inválido."]), "Alert did not appear")
        intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")
    }
    
    override func tearDown() {
        super.tearDown()
    }
}

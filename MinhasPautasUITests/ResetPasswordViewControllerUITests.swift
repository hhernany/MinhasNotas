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
        continueAfterFailure = false // In UI tests it is usually best to stop immediately when a failure occurs.
        UserDefaults.standard.removeObject(forKey: "token_jwt")
        app = XCUIApplication() // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()
    }
    
    func testResetPasswordEmailField() {
        // E-mail not informed
        tapButton(identifier: "resetPasswordButton")
        tapButton(identifier: "confirmButton")
        sleep(2)
        XCTAssert(app.alerts.element.staticTexts["Informe o email."].exists)
        intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")
        
        // Invalid e-mail
        let textField = app.textFields["emailTextField"]
        textField.tap()
        textField.typeText("invalidemail")
        tapButton(identifier: "confirmButton")
        sleep(2)
        XCTAssert(app.alerts.element.staticTexts["E-mail inválido."].exists)
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

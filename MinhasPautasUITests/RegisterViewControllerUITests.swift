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
    
    func testRegisterFieldsAndAlerts() throws {
        tapButton(app: app, identifier: "registerButton")

        // Check if fields exists
        let nameTextField = try XCTUnwrap(app.scrollViews.textFields["nameTextField"], "RegisterViewController: nameTextField dont exists")
        let emailTextField = try XCTUnwrap(app.scrollViews.textFields["emailTextField"], "RegisterViewController: emailTextField dont exists")
        let emailConfirmationTextField = try XCTUnwrap(app.scrollViews.textFields["emailConfirmationTextField"], "RegisterViewController: emailConfirmationTextField dont exists")
        let passwordTextField = try XCTUnwrap(app.scrollViews.secureTextFields["passwordTextField"], "RegisterViewController: passwordTextField dont exists")
        let passwordConfirmationTextField = try XCTUnwrap(app.scrollViews.secureTextFields["passwordConfirmationTextField"], "RegisterViewController: passwordConfirmationTextField dont exists")
        let confirmButton = try XCTUnwrap(app.buttons["confirmButton"], "confirmButton dont exists")
        
        // Name empty
        confirmButton.tap()
        XCTAssertTrue(app.alerts["informationAlertDialog"].waitForExistence(timeout: 5), "Error Alert dialog does not presented")
        //XCTAssert(waitForElementToAppear(app.alerts.element.staticTexts["Informe o seu nome."]), "Alert did not appear.")
        //intercepetAndCloseAlerts(name: "Aviso", button: "Fechar")

        // Email empty
        nameTextField.tap()
        nameTextField.typeText("UI Test")
        if app.keyboards.keys.count > 0 {
            app.keyboards.buttons["continuar"].tap()
        }
        confirmButton.tap()
        XCTAssertTrue(app.alerts["informationAlertDialog"].waitForExistence(timeout: 3), "Error Alert dialog does not presented")

        // Invalid email
        emailTextField.tap()
        emailTextField.typeText("invalidemail")
        if app.keyboards.keys.count > 0 {
            app.keyboards.buttons["continuar"].tap()
        }
        confirmButton.tap()
        XCTAssertTrue(app.alerts["informationAlertDialog"].waitForExistence(timeout: 3), "Error Alert dialog does not presented")

        // Valid e-mail and E-mail confirmation empty
        emailTextField.doubleTap()
        emailTextField.typeText("teste@gmail.com")
        if app.keyboards.keys.count > 0 {
            app.keyboards.buttons["continuar"].tap()
        }
        confirmButton.tap()
        XCTAssertTrue(app.alerts["informationAlertDialog"].waitForExistence(timeout: 3), "Error Alert dialog does not presented")

        // E-mail confirmation not match
        emailConfirmationTextField.tap()
        emailConfirmationTextField.typeText("teste2@gmail.com")
        if app.keyboards.keys.count > 0 {
            app.keyboards.buttons["continuar"].tap()
        }
        confirmButton.tap()
        XCTAssertTrue(app.alerts["informationAlertDialog"].waitForExistence(timeout: 3), "Error Alert dialog does not presented")

        // Valid e-mail and confirmation match, with empty password
        emailConfirmationTextField.doubleTap()
        emailConfirmationTextField.typeText("teste@gmail.com")
        if app.keyboards.keys.count > 0 {
            app.keyboards.buttons["continuar"].tap()
        }
        confirmButton.tap()
        XCTAssertTrue(app.alerts["informationAlertDialog"].waitForExistence(timeout: 3), "Error Alert dialog does not presented")

        // Password and Confirmation password empty
        passwordTextField.tap()
        passwordTextField.typeText("12345")
        if app.keyboards.keys.count > 0 {
            app.keyboards.buttons["continue"].tap()
        }
        confirmButton.tap()
        XCTAssertTrue(app.alerts["informationAlertDialog"].waitForExistence(timeout: 3), "Error Alert dialog does not presented")

        // Password and Confirmation password dont match
        passwordConfirmationTextField.tap()
        passwordConfirmationTextField.typeText("123456")
        if app.keyboards.keys.count > 0 {
            app.keyboards.buttons["continue"].tap()
        }
        confirmButton.tap()
        XCTAssertTrue(app.alerts["informationAlertDialog"].waitForExistence(timeout: 3), "Error Alert dialog does not presented")
    }
}

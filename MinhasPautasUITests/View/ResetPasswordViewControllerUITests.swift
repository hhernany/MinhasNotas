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
    
    func testResetPasswordEmailField() throws {
        // LoginViewcontroller
        let resetPasswordButton = try XCTUnwrap(app.buttons["resetPasswordButton"], "LoginViewController: resetPasswordButton dont exists")
        resetPasswordButton.tap()
        
        // RegisterViewController (sut)
        let confirmButton = try XCTUnwrap(app.buttons["confirmButton"], "ResetPasswordViewController: confirmButton dont exists")
        let emailTextField = try XCTUnwrap(app.textFields["emailResetTextField"], "ResetPasswordViewController: emailTextField dont exists")

        // Empty Email
        confirmButton.tap()
        XCTAssertTrue(app.alerts["informationAlertDialog"].waitForExistence(timeout: 3), "Error Alert dialog does not presented")
        
        // Invalid e-mail
        emailTextField.tap()
        emailTextField.typeText("invalidemail")
        confirmButton.tap()
        XCTAssertTrue(app.alerts["informationAlertDialog"].waitForExistence(timeout: 3), "Error Alert dialog does not presented")
    }
}

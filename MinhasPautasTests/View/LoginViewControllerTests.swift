//
//  LoginViewControllerTests.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 04/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest
@testable import MinhasPautas

class LoginViewControllerTests: XCTestCase {

    var storyboard: UIStoryboard!
    var sut: LoginViewController!
    
    override func setUpWithError() throws {
        storyboard = UIStoryboard(name: "Login", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws{
        storyboard = nil
        sut = nil
    }
    
    func testLoginViewController_WhenCreated_HasRequiredOutlets() throws {
        let emailTextField = try XCTUnwrap(sut.emailTextField, "The emailTextField is not connect to an IBOutlet")
        let passwordTextField = try XCTUnwrap(sut.passwordTextField, "The passwordTextField is not connect to an IBOutlet")
        let _ = try XCTUnwrap(sut.connectButton, "The connectButton is not connect to an IBOutlet")
        let _ = try XCTUnwrap(sut.registrationButton, "The registrationButton is not connect to an IBOutlet")
        let _ = try XCTUnwrap(sut.forgetPasswordButton, "The forgetPasswordButton is not connect to an IBOutlet")

        // TextFields must be empty in the start
        XCTAssertEqual(emailTextField.text, "", "emailTextField is not empty when the view controller initially loaded")
        XCTAssertEqual(passwordTextField.text, "", "passwordTextField is not empty when the view controller initially loaded")
    }
    
    func testLoginViewController_WhenCreated_FieldsHaveCorretKeyboardAndType() throws {
        let emailTextField = try XCTUnwrap(sut.emailTextField, "The emailTextField is not connect to an IBOutlet")
        let passwordTextField = try XCTUnwrap(sut.passwordTextField, "The passwordTextField is not connect to an IBOutlet")

        // TextFields must be empty in the start
        XCTAssertEqual(emailTextField.keyboardType, .emailAddress, "emailTextField is not empty when the view controller initially loaded")
        XCTAssertTrue(passwordTextField.isSecureTextEntry, "passwordTextField must have secure text entry enable")
    }
    
    func testLoginViewController_HasCorrectKeyboardType() throws {
        XCTAssertTrue(sut.emailTextField.keyboardType == .emailAddress, "emailTextField has incorrect keyboard type")
    }
    
    func testLoginViewController_WhenCreated_HasButtonActions() throws {
        let connectButton = try XCTUnwrap(sut.connectButton, "The connectButton is not connect to an IBOutlet")
        let registrationButton = try XCTUnwrap(sut.registrationButton, "The registrationButton is not connect to an IBOutlet")
        let forgetPasswordButton = try XCTUnwrap(sut.forgetPasswordButton, "The forgetPasswordButton is not connect to an IBOutlet")
        
        let connectButtonActions = try XCTUnwrap(connectButton.actions(forTarget: sut, forControlEvent: .touchUpInside))
        let registrationButtonActions = try XCTUnwrap(registrationButton.actions(forTarget: sut, forControlEvent: .touchUpInside))
        let forgetPasswordButtonActions = try XCTUnwrap(forgetPasswordButton.actions(forTarget: sut, forControlEvent: .touchUpInside))

        XCTAssertEqual(connectButtonActions.count, 1, "connectButtonActions does not have any action assigned to it")
        XCTAssertTrue(connectButtonActions.contains("didTapConnectButton:"), "There is no action with the informed name assigned to button")
        
        XCTAssertEqual(registrationButtonActions.count, 1, "registrationButtonActions does not have any action assigned to it")
        XCTAssertTrue(registrationButtonActions.contains("didTapRegistrationButton:"), "There is no action with the informed name assigned to button")
        
        XCTAssertEqual(forgetPasswordButtonActions.count, 1, "connectButtonActions does not have any action assigned to it")
        XCTAssertTrue(forgetPasswordButtonActions.contains("didTapForgetPasswordButton:"), "There is no action with the informed name assigned to button")
    }
    
    func testLoginViewController_WhenCreateTapped_InvokesLoginProcess() throws {
        let connectButton = try XCTUnwrap(sut.connectButton, "The connectButton is not connect to an IBOutlet")
        let presenter = MockLoginPresenter()
        sut.loginPresenter = presenter

        connectButton.sendActions(for: .touchUpInside)

        // Assert
        XCTAssertTrue(presenter.sendCredentialsCalled, "The sendCredentials() method was not called when tapped in confirmButton")
    }
}

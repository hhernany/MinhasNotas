//
//  RegisterViewControllerTests.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 19/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest
@testable import MinhasPautas

class RegisterViewControllerTests: XCTestCase {

    var sut: RegisterViewController!
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "RegisterVC") as? RegisterViewController
        sut.loadViewIfNeeded()
        //let _ = sut.view // Load view hierarchy
    }
    
    override func tearDownWithError() throws {
        super.tearDown()
        sut = nil
    }
    
    func testRegisterViewController_WhenCreated_HasRequiredOutlets() throws {
        let nameTextField = try XCTUnwrap(sut.name, "The nameTextField is not connect to an IBOutlet")
        let emailTextField = try XCTUnwrap(sut.email, "The emailTextField is not connect to an IBOutlet")
        let cofirmationEmailTextField = try XCTUnwrap(sut.emailConfirmation, "The cofirmationEmailTextField is not connect to an IBOutlet")
        let passwordTextField = try XCTUnwrap(sut.password, "The passwordTextField is not connect to an IBOutlet")
        let passwordConfirmationTextField = try XCTUnwrap(sut.passwordConfirmation, "The passwordConfirmationTextField is not connect to an IBOutlet")
        let _: UIButton = try XCTUnwrap(sut.registerButton, "The registerButton is not connect to an IBOutlet")
        let _: UIBarButtonItem = try XCTUnwrap(sut.cancelButton, "The cancelButton is not connect to an IBOutlet")

        // TextFields must be empty in the start
        XCTAssertEqual(nameTextField.text, "", "nameTextField is not empty when the view controller initially loaded")
        XCTAssertEqual(emailTextField.text, "", "emailTextField is not empty when the view controller initially loaded")
        XCTAssertEqual(cofirmationEmailTextField.text, "", "cofirmationEmailTextField is not empty when the view controller initially loaded")
        XCTAssertEqual(passwordTextField.text, "", "passwordTextField is not empty when the view controller initially loaded")
        XCTAssertEqual(passwordConfirmationTextField.text, "", "passwordConfirmationTextField is not empty when the view controller initially loaded")
    }
    
    func testRegisterViewController_FieldsHaveCorretKeyboardAndType() throws {
        XCTAssertEqual(sut.email.keyboardType, .emailAddress, "emailTextField has incorrect keyboard type")
        XCTAssertEqual(sut.emailConfirmation.keyboardType, .emailAddress, "emailConfirmationTextField has incorrect keyboard type")
        XCTAssertTrue(sut.password.isSecureTextEntry, "passwordTextField must have secure text entry")
        XCTAssertTrue(sut.passwordConfirmation.isSecureTextEntry, "passwordTextField must have secure text entry enable")
    }
    
    func testRegisterViewController_WhenCreated_HasRegisterButtonAction() throws {
        let registerButton: UIButton = try XCTUnwrap(sut.registerButton, "The registerButton is not connect to an IBOutlet")
        let confirmActions = try XCTUnwrap(registerButton.actions(forTarget: sut, forControlEvent: .touchUpInside))
        
        XCTAssertEqual(confirmActions.count, 1, "registerButton does not have any action assigned to it")
        XCTAssertTrue(confirmActions.contains("didTapRegisterButton:"), "There is no action with a name didTapRegisterButton assigned to signup button")
    }
    
    func testRegisterViewController_WhenCreated_HasCancelBarButtonAction() throws {
        let cancelButton: UIBarButtonItem = try XCTUnwrap(sut.cancelButton, "The cancelButton is not connect to an IBOutlet")
        let _: Selector = try XCTUnwrap(cancelButton.action, "createButton has no action")
        XCTAssertTrue(cancelButton.action == #selector(sut.didTapCancelButton(_:)), "There is no action with a name didTapCancelButton assigned to signup button")
    }
    
    func testRegisterViewController_WhenCreateTapped_InvokesRegisterProcess() throws {
        let registerButton: UIButton = try XCTUnwrap(sut.registerButton, "registerButton is not connect to an IBOutlet")
        let presenter = MockRegisterPresenter()
        sut.registerPresenter = presenter

        registerButton.sendActions(for: .touchUpInside)

        // Assert
        XCTAssertTrue(presenter.sendCredentialsCalled, "The sendCredentials() method was not called when tapped in confirmButton")
    }
}

//
//  ResetPasswordViewControllerTests.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 03/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest
@testable import MinhasPautas

class ResetPasswordViewControllerTests: XCTestCase {
    
    var storyboard: UIStoryboard!
    var sut: ResetPasswordViewController!
    
    override func setUp() {
        storyboard = UIStoryboard(name: "Login", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "ResetPasswordVC") as? ResetPasswordViewController
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        storyboard = nil
        sut = nil
    }

    func testResetPasswordViewControllerTests_WhenCreated_HasRequiredOutlets() throws {
        let emailTextField = try XCTUnwrap(sut.emailTextField, "The emailTextField is not connect to an IBOutlet")

        // TextFields must be empty in the start
        XCTAssertEqual(emailTextField.text, "", "emailTextField is not empty when the view controller initially loaded")
    }
    
    func testCreateScheduleViewController_WhenCreated_HasCreateButtonAction() throws {
        let confirmButton: UIButton = try XCTUnwrap(sut.confirmButton, "confirmButton it not connect to an IBOutlet")
        let confirmActions = try XCTUnwrap(confirmButton.actions(forTarget: sut, forControlEvent: .touchUpInside))
        
        XCTAssertEqual(confirmActions.count, 1, "Sign up button does not have any action assigned to it")
        XCTAssertTrue(confirmActions.contains("didtapCofirmButton:"), "There is no action with a name signupButtonTapped assigned to signup button")
    }

    func testCreateScheduleViewController_WhenCreateTapped_InvokesCreateProcess() throws {
        let confirmButton: UIButton = try XCTUnwrap(sut.confirmButton, "confirmButton it not connect to an IBOutlet")
        let viewModel = MockResetPasswordViewModel()
        sut.resetPasswordViewModel = viewModel

        confirmButton.sendActions(for: .touchUpInside)

        // Assert
        XCTAssertTrue(viewModel.sendCredentialsCalled, "The sendCredentialsCalled() method was not called when tapped in confirmButton")
    }
}

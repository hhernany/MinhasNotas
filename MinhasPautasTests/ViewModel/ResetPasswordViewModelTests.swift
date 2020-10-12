//
//  ResetPasswordPresenterTests.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 03/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest
@testable import MinhasPautas

class ResetPasswordPresenterTests: XCTestCase {

    var sut: ResetPasswordPresenter!
    var viewDelegate: MockResetPasswordViewDelegate!
    var firebase: MockResetPasswordFirebaseService!
    
    override func setUpWithError() throws {
        viewDelegate = MockResetPasswordViewDelegate()
        firebase = MockResetPasswordFirebaseService()
        sut = ResetPasswordPresenter(delegate: viewDelegate, firebaseService: firebase)
    }

    override func tearDownWithError() throws {
        sut = nil
        viewDelegate = nil
        firebase = nil
    }

    func testPresenter_WhenEmailIsEmpty_ShouldCallResetError() throws {
        // Arrange
        let myExpectation = expectation(description: "Expected the resetError() method to be called")
        viewDelegate.expectation = myExpectation
        
        // Act
        sut.sendCredentials(email: "")
        self.wait(for: [myExpectation], timeout: 5)
        
        // Assert
        XCTAssertEqual(viewDelegate.resetErrorCounter, 1, "The resetError() method was called more than one time")
    }
    
    func testPresenter_WhenEmailIsInvalid_ShouldCallResetError() throws {
        // Arrange
        let myExpectation = expectation(description: "Expected the resetError() method to be called")
        viewDelegate.expectation = myExpectation
        
        // Act
        sut.sendCredentials(email: "invalidemail")
        self.wait(for: [myExpectation], timeout: 5)
        
        // Assert
        XCTAssertEqual(viewDelegate.resetErrorCounter, 1, "The resetError() method was called more than one time")
    }
    
    func testPresenter_WhenEmailIsValid_ShouldCallResetSuccess() throws {
        // Arrange
        let myExpectation = expectation(description: "Expected the resetSuccess() method to be called")
        viewDelegate.expectation = myExpectation
        
        // Act
        sut.sendCredentials(email: "validemail@gmail.com")
        self.wait(for: [myExpectation], timeout: 5)
        
        // Assert
        XCTAssertEqual(viewDelegate.resetSuccessCounter, 1, "The resetSuccess() method was called more than one time")
    }
    
    func testPresenter_WhenRequestFaield_ShouldCallResetError() throws {
        // Arrange
        let myExpectation = expectation(description: "Expected the resetError() method to be called")
        firebase.shoudReturnError = true
        viewDelegate.expectation = myExpectation
        
        // Act
        sut.sendCredentials(email: "validemail@gmail.com")
        self.wait(for: [myExpectation], timeout: 5)
        
        // Assert
        XCTAssertEqual(viewDelegate.resetErrorCounter, 1, "The resetError() method was called more than one time")
    }
}

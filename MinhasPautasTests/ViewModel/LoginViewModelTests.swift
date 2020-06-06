//
//  LoginViewModelTests.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 04/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest
@testable import MinhasPautas

class LoginViewModelTests: XCTestCase {

    var sut: LoginViewModel!
    var viewDelegate: MockLoginViewDelegate!
    var webservice: MockLoginWebService!
    var loginModel: LoginModel!
    
    override func setUpWithError() throws {
        viewDelegate = MockLoginViewDelegate()
        webservice = MockLoginWebService()
        sut = LoginViewModel(delegate: viewDelegate, webservice: webservice)
    }

    override func tearDownWithError() throws {
        sut = nil
        viewDelegate = nil
        webservice = nil
        loginModel = nil
    }

    func testViewModel_WhenLoginSuccess_ShouldCallLoginSuccess() throws {
        // Arrange
        let myExpectation = expectation(description: "Expected the loginSuccess() method to be called")
        viewDelegate.expectation = myExpectation
        
        // Act
        sut.sendCredentials(email: "validemail@gmail.com", password: "1234567890")
        self.wait(for: [myExpectation], timeout: 5)
        
        // Assert
        XCTAssertEqual(viewDelegate.loginSuccessCounter, 1, "The loginSuccess() method was called more than one time")
    }
    
    func testViewModel_WhenRecieveEmptyData_ShouldCallLoginError() throws {
        // Arrange
        let myExpectation = expectation(description: "Expected the loginError() method to be called")
        viewDelegate.expectation = myExpectation
        
        // Act
        sut.sendCredentials(email: "", password: "")
        self.wait(for: [myExpectation], timeout: 5)
        
        // Assert
        XCTAssertEqual(viewDelegate.loginErrorCounter, 1, "The loginError() method was called more than one time")
    }
    
    func testViewModel_WhenRecieveValidData_FailedFirebaseLogin() throws {
        // Arrange
        let myExpectation = expectation(description: "Expected the loginError() method to be called when failed firebase login")
        viewDelegate.expectation = myExpectation
        webservice.shouldReturnFirebaseError = true
        
        // Act
        sut.sendCredentials(email: "validemail@gmail.com", password: "test123456")
        self.wait(for: [myExpectation], timeout: 5)
        
        // Assert
        XCTAssertEqual(viewDelegate.loginErrorCounter, 1, "The loginError() method was called more than one time")
    }
    
    func testViewModel_WhenRecieveValidData_FailedDatabaseLogin() throws {
        // Arrange
        let myExpectation = expectation(description: "Expected the loginError() method to be called")
        viewDelegate.expectation = myExpectation
        webservice.shouldReturnDatabaseError = true

        // Act
        sut.sendCredentials(email: "validemail@gmail.com", password: "test123456")
        self.wait(for: [myExpectation], timeout: 5)
        
        // Assert
        XCTAssertEqual(viewDelegate.loginErrorCounter, 1, "The loginError() method was called more than one time")
    }
    
    func testViewModel_WhenRemoteWebServiceReturnError_ShouldCallResetError() throws{
        // Arrange
        let myExpectation = expectation(description: "Expected the loginError() method to be called")
        webservice.shouldReturnRemoteErrorMessage = true
        viewDelegate.expectation = myExpectation

        // Act
        sut.sendCredentials(email: "validemail@gmail.com", password: "test123456")
        self.wait(for: [myExpectation], timeout: 5)

        // Assert
        XCTAssertEqual(viewDelegate.loginErrorCounter, 1, "The loginError() method was called more than one time")
    }
}

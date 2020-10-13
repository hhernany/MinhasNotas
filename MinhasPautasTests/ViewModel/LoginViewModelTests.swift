//
//  LoginPresenterTests.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 04/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest
@testable import MinhasPautas

class LoginPresenterTests: XCTestCase {

    var sut: LoginPresenter!
    var viewDelegate: MockLoginViewDelegate!
    var webservice: MockLoginWebService!
    var loginModel: LoginModel!
    
    override func setUpWithError() throws {
        viewDelegate = MockLoginViewDelegate()
        webservice = MockLoginWebService()
        sut = LoginPresenter(delegate: viewDelegate, webservice: webservice)
    }

    override func tearDownWithError() throws {
        sut = nil
        viewDelegate = nil
        webservice = nil
        loginModel = nil
    }

    func testPresenter_WhenLoginSuccess_ShouldCallLoginSuccess() throws {
        // Arrange
        let myExpectation = expectation(description: "Expected the loginSuccess() method to be called")
        viewDelegate.expectation = myExpectation
        
        // Act
        sut.sendCredentials(email: "validemail@gmail.com", password: "1234567890")
        self.wait(for: [myExpectation], timeout: 5)
        
        // Assert
        XCTAssertEqual(viewDelegate.loginSuccessCounter, 1, "The loginSuccess() method was called more than one time")
    }
    
    func testPresenter_WhenRecieveEmptyData_ShouldCallLoginError() throws {
        // Arrange
        let myExpectation = expectation(description: "Expected the loginError() method to be called")
        viewDelegate.expectation = myExpectation
        
        // Act
        sut.sendCredentials(email: "", password: "")
        self.wait(for: [myExpectation], timeout: 5)
        
        // Assert
        XCTAssertEqual(viewDelegate.loginErrorCounter, 1, "The loginError() method was called more than one time")
    }
    
    func testPresenter_WhenRecieveValidData_FailedFirebaseLogin() throws {
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
    
    func testPresenter_WhenRecieveValidData_FailedDatabaseLogin() throws {
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
    
    func testPresenter_WhenRemoteWebServiceReturnError_ShouldCallResetError() throws{
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

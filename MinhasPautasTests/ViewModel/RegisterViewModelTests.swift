//
//  RegisterPresenterTests.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 04/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest
@testable import MinhasPautas

class RegisterPresenterTests: XCTestCase {

    var sut: RegisterPresenter!
    var viewDelegate: MockRegisterViewDelegate!
    var webservice: MockRegisterWebService!
    var registerModel: RegisterModel!
    
    override func setUpWithError() throws {
        viewDelegate = MockRegisterViewDelegate()
        webservice = MockRegisterWebService()
        registerModel = RegisterModel(name: "First Name",
                              email: "newemail@gmail.com",
                              emailConfirmation: "newemail@gmail.com",
                              password: "123456",
                              passwordConfirmation: "123456")
        sut = RegisterPresenter(delegate: viewDelegate, webserrvice: webservice)
    }

    override func tearDownWithError() throws {
        sut = nil
        viewDelegate = nil
        webservice = nil
        registerModel = nil
    }

    func testPresenter_WhenRecieveEmptyData_ShouldCallRegisterError() throws {
        // Arrange
        let myExpectation = expectation(description: "Expected the registerError() method to be called")
        viewDelegate.expectation = myExpectation
        
        // Act
        sut.sendCredentials(data: RegisterModel(name: "", email: "", emailConfirmation: "", password: "", passwordConfirmation: ""))
        self.wait(for: [myExpectation], timeout: 5)
        
        // Assert
        XCTAssertEqual(viewDelegate.registerErrorCounter, 1, "The registerError() method was called more than one time")
    }
    
    func testPresenter_WhenRecieveValidData_FailedFirebaseRegistration() throws {
        // Arrange
        let myExpectation = expectation(description: "Expected the registerError() method to be called when failed firebase registration")
        viewDelegate.expectation = myExpectation
        webservice.shouldReturnFirebaseError = true
        
        // Act
        sut.sendCredentials(data: registerModel)
        self.wait(for: [myExpectation], timeout: 5)
        
        // Assert
        XCTAssertEqual(viewDelegate.registerErrorCounter, 1, "The registerError() method was called more than one time")
    }
    
    func testPresenter_WhenRecieveValidData_FailedDatabaseRegistration() throws {
        // Arrange
        let myExpectation = expectation(description: "Expected the registerError() method to be called")
        viewDelegate.expectation = myExpectation
        webservice.shouldReturnDatabaseError = true

        // Act
        sut.sendCredentials(data: registerModel)
        self.wait(for: [myExpectation], timeout: 5)
        
        // Assert
        XCTAssertEqual(viewDelegate.registerErrorCounter, 1, "The registerError() method was called more than one time")
    }
    
    func testPresenter_WhenRemoteWebServiceReturnError_ShouldCallResetError() throws {
        // Arrange
        let myExpectation = expectation(description: "Expected the resetError() method to be called")
        webservice.shouldReturnRemoteErrorMessage = true
        viewDelegate.expectation = myExpectation

        // Act
        sut.sendCredentials(data: registerModel)
        self.wait(for: [myExpectation], timeout: 5)

        // Assert
        XCTAssertEqual(viewDelegate.registerErrorCounter, 1, "The resetError() method was called more than one time")
    }
}

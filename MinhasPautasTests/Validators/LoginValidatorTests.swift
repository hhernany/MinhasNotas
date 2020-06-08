//
//  LoginValidatorTests.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 04/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest
@testable import MinhasPautas

class LoginValidatorTests: XCTestCase {
    var sut: LoginValidator!
    
    override func setUpWithError() throws {
        sut = LoginValidator()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testValidator_EmailIsEmpty() throws {
        let resultValidation = sut.validateData(email: "", password: "")
        XCTAssertFalse(resultValidation.0, "Result of validation must be false")
    }
    
    func testValidator_EmailIsInvalid() throws {
        let resultValidation = sut.validateData(email: "testemail", password: "")
        XCTAssertFalse(resultValidation.0, "Result of validation must be false")
    }
    
    func testValidator_PasswordIsInvalid() throws {
        let resultValidation = sut.validateData(email: "validemail@gmail.com", password: "")
        XCTAssertFalse(resultValidation.0, "Result of validation must be false")
    }
    
    func testValidator_AllValidInformations() throws {
        let resultValidation = sut.validateData(email: "validemail@gmail.com", password: "password")
        XCTAssertTrue(resultValidation.0, "Result of validation must be true")
    }
}

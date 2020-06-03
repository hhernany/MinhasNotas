//
//  ResetPasswordValidator.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 03/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest
import Firebase
@testable import MinhasPautas

class ResetPasswordValidatorTests: XCTestCase {
    var sut: ResetPasswordValidator!
    
    override func setUpWithError() throws {
        sut = ResetPasswordValidator()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testValidator_EmailIsEmpty() throws {
        let email = ""
        let resultValidation = sut.isEmailValid(email: email)
        XCTAssertFalse(resultValidation.0, "Result of validation must be false")
    }
    
    func testValidator_EmailIsInvalid() throws {
        let email = "testemail"
        let resultValidation = sut.isEmailValid(email: email)
        XCTAssertFalse(resultValidation.0, "Result of validation must be false")
    }
    
    func testValidator_EmailIsValid() throws {
        let email = "testemail@gmail.com"
        let resultValidation = sut.isEmailValid(email: email)
        XCTAssertTrue(resultValidation.0, "Result of validation must be true")
    }
}

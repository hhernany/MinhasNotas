//
//  RegisterViewModelValidatorTests.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 03/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest
@testable import MinhasPautas

class RegisterViewModelValidatorTests: XCTestCase {
    
    var sut: RegisterViewModelValidator!
    var registerModel: RegisterModel!
    
    override func setUpWithError() throws {
        sut = RegisterViewModelValidator()
    }

    override func tearDownWithError() throws {
        sut = nil
        registerModel = nil
    }
    
    func testRegisterViewModelValidator_WithEmptyName() {
        registerModel = RegisterModel(name: "", email: "", emailConfirmation: "", password: "", passwordConfirmation: "")
        let resultValidation = sut.validateModel(data: registerModel)

        XCTAssertNotNil(resultValidation, "Validator return nil. Expected .errorName.")
        switch resultValidation {
        case .errorName( _):
            XCTAssert(true)
        default:
            XCTAssert(false, "Validator return incorret type after validation. Expected .errorName.")
        }
    }
    
    func testRegisterViewModelValidator_WithEmptyEmail() {
        registerModel = RegisterModel(name: "First Name", email: "", emailConfirmation: "", password: "", passwordConfirmation: "")
        let resultValidation = sut.validateModel(data: registerModel)

        XCTAssertNotNil(resultValidation, "Validator return nil. Expected .errorEmail.")
        switch resultValidation {
        case .errorEmail( _):
            XCTAssert(true)
        default:
            XCTAssert(false, "Validator return incorret type after validation. Expected .errorEmail.")
        }
    }
    
    func testRegisterViewModelValidator_WithInvalidEmail() {
        registerModel = RegisterModel(name: "First Name", email: "invalidemail", emailConfirmation: "", password: "", passwordConfirmation: "")
        let resultValidation = sut.validateModel(data: registerModel)

        XCTAssertNotNil(resultValidation, "Validator return nil. Expected .errorEmail.")
        switch resultValidation {
        case .errorEmail( _):
            XCTAssert(true)
        default:
            XCTAssert(false, "Validator return incorret type after validation. Expected .errorEmail.")
        }
    }
    
    func testRegisterViewModelValidator_WithEmailConfirmationEmpty() {
        registerModel = RegisterModel(name: "First Name", email: "validemail@gmail.com", emailConfirmation: "", password: "", passwordConfirmation: "")
        let resultValidation = sut.validateModel(data: registerModel)

        XCTAssertNotNil(resultValidation, "Validator return nil. Expected .errorEmail.")
        switch resultValidation {
        case .errorEmail( _):
            XCTAssert(true)
        default:
            XCTAssert(false, "Validator return incorret type after validation. Expected .errorEmail.")
        }
    }
    
    func testRegisterViewModelValidator_EmailConfirmationDontMatch() {
        registerModel = RegisterModel(name: "First Name", email: "validemail@gmail.com", emailConfirmation: "123", password: "", passwordConfirmation: "")
        let resultValidation = sut.validateModel(data: registerModel)

        XCTAssertNotNil(resultValidation, "Validator return nil. Expected .errorEmail.")
        switch resultValidation {
        case .errorEmail( _):
            XCTAssert(true)
        default:
            XCTAssert(false, "Validator return incorret type after validation. Expected .errorEmail.")
        }
    }
    
    func testRegisterViewModelValidator_WithEmptyPassword() {
        registerModel = RegisterModel(name: "First Name", email: "validemail@gmail.com", emailConfirmation: "validemail@gmail.com", password: "", passwordConfirmation: "")
        let resultValidation = sut.validateModel(data: registerModel)

        XCTAssertNotNil(resultValidation, "Validator return nil. Expected .errorPassword.")
        switch resultValidation {
        case .errorPassword( _):
            XCTAssert(true)
        default:
            XCTAssert(false, "Validator return incorret type after validation. Expected .errorPassword.")
        }
    }
    
    func testRegisterViewModelValidator_WithEmptyConfirmationPassword() {
        registerModel = RegisterModel(name: "First Name", email: "validemail@gmail.com", emailConfirmation: "validemail@gmail.com", password: "test123456", passwordConfirmation: "")
        let resultValidation = sut.validateModel(data: registerModel)

        XCTAssertNotNil(resultValidation, "Validator return nil. Expected .errorPassword.")
        switch resultValidation {
        case .errorPassword( _):
            XCTAssert(true)
        default:
            XCTAssert(false, "Validator return incorret type after validation. Expected .errorPassword.")
        }
    }
    
    func testRegisterViewModelValidator_PasswordsDontMatch() {
        registerModel = RegisterModel(name: "First Name", email: "validemail@gmail.com", emailConfirmation: "validemail@gmail.com", password: "test123456", passwordConfirmation: "test")
        let resultValidation = sut.validateModel(data: registerModel)

        XCTAssertNotNil(resultValidation, "Validator return nil. Expected .errorPassword.")
        switch resultValidation {
        case .errorPassword( _):
            XCTAssert(true)
        default:
            XCTAssert(false, "Validator return incorret type after validation. Expected .errorPassword.")
        }
    }
    
    func testRegisterViewModelValidator_WithValidInformations() {
        registerModel = RegisterModel(name: "First Name", email: "validemail@gmail.com", emailConfirmation: "validemail@gmail.com", password: "test123456", passwordConfirmation: "test123456")
        let resultValidation = sut.validateModel(data: registerModel)

        XCTAssertNil(resultValidation, "With valid data, returned error must be nil")
    }
}

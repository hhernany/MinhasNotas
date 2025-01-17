//
//  RegisterPresenterValidatorTests.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 03/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest
@testable import MinhasPautas

class RegisterPresenterValidatorTests: XCTestCase {
    
    var sut: RegisterValidator!
    var registerModel: RegisterModel!
    
    override func setUpWithError() throws {
        sut = RegisterValidator()
    }

    override func tearDownWithError() throws {
        sut = nil
        registerModel = nil
    }
    
    func testRegisterPresenterValidator_WithEmptyName() throws {
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
    
    func testRegisterPresenterValidator_WithEmptyEmail() throws {
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
    
    func testRegisterPresenterValidator_WithInvalidEmail() throws {
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
    
    func testRegisterPresenterValidator_WithEmailConfirmationEmpty() throws {
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
    
    func testRegisterPresenterValidator_EmailConfirmationDontMatch() throws {
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
    
    func testRegisterPresenterValidator_WithEmptyPassword() throws {
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
    
    func testRegisterPresenterValidator_WithEmptyConfirmationPassword() throws {
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
    
    func testRegisterPresenterValidator_PasswordsDontMatch() throws {
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
    
    func testRegisterPresenterValidator_WithValidInformations() throws {
        registerModel = RegisterModel(name: "First Name", email: "validemail@gmail.com", emailConfirmation: "validemail@gmail.com", password: "test123456", passwordConfirmation: "test123456")
        let resultValidation = sut.validateModel(data: registerModel)

        XCTAssertNil(resultValidation, "With valid data, returned error must be nil")
    }
}

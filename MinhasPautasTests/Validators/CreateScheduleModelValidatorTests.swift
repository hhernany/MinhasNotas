//
//  CreateScheduleModelValidatorTests.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 29/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest
@testable import MinhasPautas

class CreateScheduleModelValidatorTests: XCTestCase {

    var sut: CreateScheduleModelValidator!
    var createScheduleModel: CreateScheduleModel!
    
    override func setUp() {
        sut = CreateScheduleModelValidator()
    }

    override func tearDown() {
        sut = nil
        createScheduleModel = nil
    }

    func testCreateScheduleModelValidator_WithEmptyTitle() {
        // Arrange
        createScheduleModel = CreateScheduleModel(titulo: "", descricao: "description", detalhes: "detail")
        
        // Act
        let resultValidation = sut.validateScheduleModel(formData: createScheduleModel)

        // Assert
        XCTAssertNotNil(resultValidation, "Validator return nil. Expected .errorTitle.")
        
        switch resultValidation {
        case .errorTitle( _):
            XCTAssert(true)
        default:
            XCTAssert(false, "Validator return incorret type after validation. Expected .errorTitle.")
        }
    }
    
    func testCreateScheduleModelValidator_WithEmptyDescription() {
        // Arrange
        createScheduleModel = CreateScheduleModel(titulo: "title", descricao: "", detalhes: "detail")
        
        // Act
        let resultValidation = sut.validateScheduleModel(formData: createScheduleModel)

        // Assert
        XCTAssertNotNil(resultValidation, "Validator return nil. Expected .errorDescription.")
        
        switch resultValidation {
        case .errorDescription( _):
            XCTAssert(true)
        default:
            XCTAssert(false, "Validator return incorret type after validation. Expected .errorDescription")
        }
    }
    
    func testCreateScheduleModelValidator_WithEmptyDetail() {
        // Arrange
        createScheduleModel = CreateScheduleModel(titulo: "title", descricao: "description", detalhes: "")
        
        // Act
        let resultValidation = sut.validateScheduleModel(formData: createScheduleModel)

        // Assert
        XCTAssertNotNil(resultValidation, "Validator return nil. Expected .errorDetail.")
        
        switch resultValidation {
        case .errorDetail( _):
            XCTAssert(true)
        default:
            XCTAssert(false, "Validator return incorret type after validation. Expected .errorDetail")
        }
    }
}


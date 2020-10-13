//
//  CreteSchedulePresenterTests.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 29/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest
import Moya
@testable import MinhasPautas

class CreteSchedulePresenterTests: XCTestCase {

    var sut: CreateSchedulePresenter!
    var viewDelegate: MockCreateScheduleViewDelegate!
    var webservice: CreateScheduleWebServiceProtocol!
    var createScheduleModel: CreateScheduleModel!
    
    override func setUpWithError() throws {
        viewDelegate = MockCreateScheduleViewDelegate()
        webservice = CreateScheduleWebService(moyaProvider: MoyaProvider<SchedulesAPI>(stubClosure: MoyaProvider.immediatelyStub))
        sut = CreateSchedulePresenter(delegate: viewDelegate, webservice: webservice)
    }

    override func tearDownWithError() throws {
        sut = nil
        viewDelegate = nil
        webservice = nil
        createScheduleModel = nil
    }

    func testPresenter_WhenOperationSuccess_ShouldCallCreateSuccess() throws {
        // Arrange
        createScheduleModel = CreateScheduleModel(titulo: "Titulo", descricao: "Descricao", detalhes: "Detalhes")
        let myExpectation = expectation(description: "Expected the createSuccess() method to be called")
        viewDelegate.expectation = myExpectation
        
        // Act
        sut.sendFormData(formData: createScheduleModel)
        self.wait(for: [myExpectation], timeout: 5)
        
        // Assert
        XCTAssertEqual(viewDelegate.createSuccessCounter, 1, "The createSuccess() method was called more than one time")
    }
    
    func testPresenter_WhenModelValidatorFail_ShouldCallCreateError() throws {
        // Arrange
        createScheduleModel = CreateScheduleModel(titulo: "", descricao: "", detalhes: "")
        let myExpectation = expectation(description: "Expected the createError() method to be called")
        viewDelegate.expectation = myExpectation
        
        // Act
        sut.sendFormData(formData: createScheduleModel)
        self.wait(for: [myExpectation], timeout: 5)
        
        // Assert
        XCTAssertEqual(viewDelegate.createErrorCounter, 1, "The createError() method was called more than one time")
    }
    
    func testPresenter_WhenOperationFail_ShouldCallCreateError() throws {
        // Arrange
        let provider = MoyaProvider<SchedulesAPI>(endpointClosure: customErrorEndpoint, stubClosure: MoyaProvider.immediatelyStub)
        webservice = CreateScheduleWebService(moyaProvider: provider)
        sut = CreateSchedulePresenter(delegate: viewDelegate, webservice: webservice)
        
        createScheduleModel = CreateScheduleModel(titulo: "Titulo", descricao: "Descricao", detalhes: "Detalhes")
        let myExpectation = expectation(description: "Expected the createError() method to be called")
        
        viewDelegate.expectation = myExpectation

        // Act
        sut.sendFormData(formData: createScheduleModel)
        self.wait(for: [myExpectation], timeout: 5)
        
        // Assert
        XCTAssertEqual(viewDelegate.createErrorCounter, 1, "The createError() method was called more than one time")
    }

}

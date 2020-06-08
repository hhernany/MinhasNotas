//
//  CreteScheduleViewModelTests.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 29/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest
import Moya
@testable import MinhasPautas

class CreteScheduleViewModelTests: XCTestCase {

    var sut: CreateScheduleViewModel!
    var viewDelegate: MockCreateScheduleViewDelegate!
    var webservice: CreateScheduleWebServiceProtocol!
    var createScheduleModel: CreateScheduleModel!
    
    override func setUpWithError() throws {
        viewDelegate = MockCreateScheduleViewDelegate()
        webservice = CreateScheduleWebService(moyaProvider: MoyaProvider<SchedulesAPI>(stubClosure: MoyaProvider.immediatelyStub))
        sut = CreateScheduleViewModel(delegate: viewDelegate, webservice: webservice)
    }

    override func tearDownWithError() throws {
        sut = nil
        viewDelegate = nil
        webservice = nil
        createScheduleModel = nil
    }

    func testViewModel_WhenOperationSuccess_ShouldCallCreateSuccess() throws {
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
    
    func testViewModel_WhenModelValidatorFail_ShouldCallCreateError() throws {
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
    
    func testViewModel_WhenOperationFail_ShouldCallCreateError() throws {
        // Arrange
        let provider = MoyaProvider<SchedulesAPI>(endpointClosure: customErrorEndpoint, stubClosure: MoyaProvider.immediatelyStub)
        webservice = CreateScheduleWebService(moyaProvider: provider)
        sut = CreateScheduleViewModel(delegate: viewDelegate, webservice: webservice)
        
        createScheduleModel = CreateScheduleModel(titulo: "Titulo", descricao: "Descricao", detalhes: "Detalhes")
        let myExpectation = expectation(description: "Expected the createError() method to be called")
        
        viewDelegate.expectation = myExpectation

        // Act
        sut.sendFormData(formData: createScheduleModel)
        self.wait(for: [myExpectation], timeout: 5)
        
        // Assert
        XCTAssertEqual(viewDelegate.createErrorCounter, 1, "The createError() method was called more than one time")
    }
    
    func customErrorEndpoint(_ target: SchedulesAPI) -> Endpoint {
        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: { .networkError(NSError(domain: "Error 500", code: 500)) },
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }
}

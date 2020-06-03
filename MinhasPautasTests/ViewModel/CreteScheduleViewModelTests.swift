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
    
    override func setUp() {
        viewDelegate = MockCreateScheduleViewDelegate()
        webservice = CreateScheduleWebService(moyaProvider: MoyaProvider<SchedulesAPI>(stubClosure: MoyaProvider.immediatelyStub))
        sut = CreateScheduleViewModel(delegate: viewDelegate, webservice: webservice)
    }

    override func tearDown() {
        sut = nil
        viewDelegate = nil
        webservice = nil
        createScheduleModel = nil
    }

    func testViewModel_WhenOperationSuccess_ShouldCallCreateSuccess() {
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
    
    func testViewModel_WhenModelValidatorFail_ShouldCallCreateError() {
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
    
    // Problemas
    // 1 - Eu injetei tudo no começo, porém eu precisaria de um endpoint personalizado pra forçar error com o Moya
    // 2 - Eu arrumou um jeito aqui de injetar, ou o certo seria criar um WebService Mock?
    // 3 - Se eu criar um Mock, é certo? Eu usar Mock aqui, e nos outros lugares, vou suar o Moack ou o Oficial?
    // 4 - O Oficial já tá pronto com os testes dele em separado.
    func testViewModel_WhenOperationFail_ShouldCallCreateError() {
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

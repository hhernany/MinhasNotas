//
//  SchedulesWebServiceTests.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 05/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest
import Moya
@testable import MinhasPautas

class SchedulesWebServiceTests: XCTestCase {

    var sut: SchedulesWebService!
    var provider: MoyaProvider<SchedulesAPI>!
    var updateScheduleData: [String:Any]!
    
    override func setUpWithError() throws {
        updateScheduleData = [
            "email": "validemail@gmail.com",
            "token_autenticacao": "notification_token"
        ]
    }

    override func tearDownWithError() throws {
        sut = nil
        provider = nil
        updateScheduleData = nil
    }
    
    // MARK: Get Data Routine
    func testSchedulesWebService_WhenGetData_SuccessRequest() throws {
        let provider = MoyaProvider<SchedulesAPI>(stubClosure: MoyaProvider.immediatelyStub)
        sut = SchedulesWebService(moyaProvider: provider)
        let expectation = self.expectation(description: "Response with success expectation")
        
        sut.getData(page: 0) { (schedulesList, resultModel, error) in
            XCTAssertNil(resultModel, "resultModel must be nil when get data succeed")
            XCTAssertNil(error, "Error must be nil when get data succeed")
            XCTAssertNotNil(schedulesList, "schedulesList cannot be nil when get data succeed")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }
    
    func testSchedulesWebService_WhenGetData_ReturnResultFalse() throws {
        let provider = MoyaProvider<SchedulesAPI>(endpointClosure: customWebServiceValidatingError, stubClosure: MoyaProvider.immediatelyStub)
        sut = SchedulesWebService(moyaProvider: provider)
        let expectation = self.expectation(description: "Response with validating error expectation")
        
        sut.getData(page: 0) { (schedulesList, resultModel, error) in
            XCTAssertNil(schedulesList, "schedulesList must be nil when get data return validation error")
            XCTAssertNotNil(resultModel, "resultModel cannot be nil when get data return validation error")
            XCTAssertNotNil(error, "Error cannot be nil when get data return validation error")
            
            XCTAssertFalse(resultModel!.success, "ResultModel success must be false when get data failed")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testSchedulesWebService_WhenGetData_ReturnInvalidResultStruct() throws {
        let provider = MoyaProvider<SchedulesAPI>(endpointClosure: customSuccessWithInvalidStruct, stubClosure: MoyaProvider.immediatelyStub)
        sut = SchedulesWebService(moyaProvider: provider)
        let expectation = self.expectation(description: "Response with invalid struct returned from remote webservice")
        
        sut.getData(page: 0) { (schedulesList, resultModel, error) in
            XCTAssertNil(schedulesList, "schedulesList must be nil when get data return validation error")
            XCTAssertNil(resultModel, "resultModel cannot be nil when get data return validation error")
            XCTAssertNotNil(error, "Error cannot be nil when get data return validation error")

            XCTAssertEqual(error!.response!.statusCode, 200 , "Status code must be the same returned correctly")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testSchedulesWebService_WhenGetData_FailedRequest() throws {
        let provider = MoyaProvider<SchedulesAPI>(endpointClosure: customErrorEndpoint, stubClosure: MoyaProvider.immediatelyStub)
        sut = SchedulesWebService(moyaProvider: provider)
        let expectation = self.expectation(description: "Response with failed request")
        
        sut.getData(page: 0) { (schedulesList, resultModel, error) in
            XCTAssertNil(schedulesList, "schedulesList must be nil when get data request failed")
            XCTAssertNil(resultModel, "resultModel cannot be nil when get data request failed")
            XCTAssertNotNil(error, "Error cannot be nil when get data request failed")

            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    // MARK: Update Data Routine
    func testSchedulesWebService_WhenUpdateStatus_SuccessRequest() throws {
        let provider = MoyaProvider<SchedulesAPI>(stubClosure: MoyaProvider.immediatelyStub)
        sut = SchedulesWebService(moyaProvider: provider)
        let expectation = self.expectation(description: "Response with success expectation")
        
        sut.updateStatus(data: [:]) { (resultModel, error) in
            XCTAssertNotNil(resultModel, "resultModel must be nil when update succeed")
            XCTAssertNil(error, "Error must be nil when update status succeed")
            XCTAssertTrue(resultModel!.success, "resultModel success must be true when update status with success")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }
    
    func testSchedulesWebService_WhenUpdateStatus_ReturnResultFalse() throws {
        let provider = MoyaProvider<SchedulesAPI>(endpointClosure: customWebServiceValidatingError, stubClosure: MoyaProvider.immediatelyStub)
        sut = SchedulesWebService(moyaProvider: provider)
        let expectation = self.expectation(description: "Response with validating error expectation")
        
        sut.updateStatus(data: [:]) { (resultModel, error) in
            XCTAssertNotNil(resultModel, "resultModel cannot be nil when update status return validation error")
            XCTAssertNil(error, "Error cannot be nil when update status return validation error")
            
            XCTAssertFalse(resultModel!.success, "ResultModel success must be false when update status failed")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testSchedulesWebService_WhenUpdateStatus_FailedRequest() throws {
        let provider = MoyaProvider<SchedulesAPI>(endpointClosure: customErrorEndpoint, stubClosure: MoyaProvider.immediatelyStub)
        sut = SchedulesWebService(moyaProvider: provider)
        let expectation = self.expectation(description: "Response with failed request")
        
        sut.updateStatus(data: [:]) { (resultModel, error) in
            XCTAssertNil(resultModel, "resultModel cannot be nil when update status request failed")
            XCTAssertNotNil(error, "Error cannot be nil when get data request failed")

            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    // MARK: Custom Moya functions
    func customSuccessWithInvalidStruct(_ target: SchedulesAPI) -> Endpoint {
        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: {.networkResponse(200, Data("Invalid message to be parsed".utf8))},
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }
    
    func customWebServiceValidatingError(_ target: SchedulesAPI) -> Endpoint {
        let data = "{\"success\": false, \"message\": \"Result with success equal false.\"}"
        let sampleData = Data(data.utf8)

        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: {.networkResponse(200, sampleData)},
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }
    
    func customErrorEndpoint(_ target: SchedulesAPI) -> Endpoint {
        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: { .networkError(NSError(domain: "Error 500", code: 500)) },
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }
}

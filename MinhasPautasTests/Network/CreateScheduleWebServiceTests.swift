//
//  CreateScheduleWebServiceTests.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 02/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest
import Moya
@testable import MinhasPautas

class CreateScheduleWebServiceTests: XCTestCase {

    var sut: CreateScheduleWebService!
    var provider: MoyaProvider<SchedulesAPI>!
    
    override func setUpWithError() throws {  }

    override func tearDownWithError() throws {
        sut = nil
        provider = nil
    }
    
    func testWebService_WhithSuccessRequest() throws {
        // Arrange
        let provider = MoyaProvider<SchedulesAPI>(stubClosure: MoyaProvider.immediatelyStub)
        sut = CreateScheduleWebService(moyaProvider: provider)
        let expectation = self.expectation(description: "Response with success expectation")

        // Act
        sut?.insertSchedule([:], completionHandler: { (result, error) in
            // Assert
            XCTAssertNil(error, "Request to .createSchedule return error, but must be nil")
            XCTAssertNotNil(result, "Result can't be nil")
            XCTAssertTrue(result!.success, "Result must be true but returned \(result!.success)")
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5)
    }
    
    // When webservice return "success: false", indicating that an error has occurred (Ex: {success: false, message: "Title field not informed"})
    func testWebService_ReturnValidatingError() throws {
        // Arrange
        let provider = MoyaProvider<SchedulesAPI>(endpointClosure: customWebServiceValidatingError, stubClosure: MoyaProvider.immediatelyStub)
        sut = CreateScheduleWebService(moyaProvider: provider)
        let expectation = self.expectation(description: "Response with invalid return expectation")

        // Act
        sut?.insertSchedule([:], completionHandler: { (result, error) in
            // Assert
            XCTAssertNotNil(result, "Result can't be nil")
            XCTAssertFalse(result!.success, "Result success must be false")
            XCTAssertNil(error, "Error must be nil")
            
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testWebService_WithInvalidResultStruct() throws {
        // Arrange
        let provider = MoyaProvider<SchedulesAPI>(endpointClosure: customSuccessWithInvalidStruct, stubClosure: MoyaProvider.immediatelyStub)
        sut = CreateScheduleWebService(moyaProvider: provider)
        let expectation = self.expectation(description: "Response with invalid return expectation")

        // Act
        sut?.insertSchedule([:], completionHandler: { (result, error) in
            // Assert
            XCTAssertNil(result, "Request to .createSchedule return result, but must be nil")
            XCTAssertNotNil(error, "Request must return error")
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testWebService_WithFailedRequest() throws {
        // Arrange
        let provider = MoyaProvider<SchedulesAPI>(endpointClosure: customErrorEndpoint, stubClosure: MoyaProvider.immediatelyStub)
        sut = CreateScheduleWebService(moyaProvider: provider)
        let expectation = self.expectation(description: "Response with error expectation")

        // Act
        sut?.insertSchedule([:], completionHandler: { (result, error) in
            // Assert
            XCTAssertNil(result, "Request to .createSchedule return result, but must be nil")
            XCTAssertNotNil(error, "Request must return error")
            expectation.fulfill()
        })
        
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

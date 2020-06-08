//
//  RegisterWebServiceTests.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 03/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest
import Moya
@testable import MinhasPautas

class RegisterWebServiceTests: XCTestCase {

    var sut: RegisterWebService!
    var provider: MoyaProvider<LoginAPI>!
    var userData: [String:String]!
    
    override func setUpWithError() throws {
        // Fake user data
        userData = [
            "nome": "First Name",
            "email": "validemail@gmail.com",
            "token_autenticacao": "uidtoken"
        ]
    }

    override func tearDownWithError() throws {
        sut = nil
        provider = nil
        userData = nil
    }

    func testRegisterWebService_WhithSuccessRequest() throws {
        let provider = MoyaProvider<LoginAPI>(stubClosure: MoyaProvider.immediatelyStub)
        sut = RegisterWebService(moyaProvider: provider)
        let expectation = self.expectation(description: "Response with success expectation")
        
        sut.registerDatabase(userData) { (loginResult, resultModel, error) in
            XCTAssertNil(resultModel, "Result Model must be nil when registration succeed")
            XCTAssertNil(error, "Error must be nil when registration succeed")
            XCTAssertNotNil(loginResult, "Error must be nil when registration succeed")
            XCTAssertTrue(loginResult!.success, "Login success must be true when registration succeed")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testRegisterWebService_ReturnValidatingError() throws {
        let provider = MoyaProvider<LoginAPI>(endpointClosure: customWebServiceValidatingError, stubClosure: MoyaProvider.immediatelyStub)
        sut = RegisterWebService(moyaProvider: provider)
        let expectation = self.expectation(description: "Response with validating error expectation")
        
        sut.registerDatabase(userData) { (loginResult, resultModel, error) in
            XCTAssertNil(loginResult, "Result Model must be nil when registration return validation error")
            XCTAssertNotNil(resultModel, "Result Model cannot be nil when registration return validation error")
            XCTAssertNotNil(error, "Error cannot be nil when registration return validation error")
            
            XCTAssertFalse(resultModel!.success, "ResultModel success must be false when registration failed")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testRegisterWebService_WithInvalidResultStruct() throws {
        let provider = MoyaProvider<LoginAPI>(endpointClosure: customSuccessWithInvalidStruct, stubClosure: MoyaProvider.immediatelyStub)
        sut = RegisterWebService(moyaProvider: provider)
        let expectation = self.expectation(description: "Response with invalid struct returned from remote webservice")
        
        sut.registerDatabase(userData) { (loginResult, resultModel, error) in
            XCTAssertNil(loginResult, "Result Model must be nil when registration return validation error")
            XCTAssertNil(resultModel, "Result Model cannot be nil when registration return validation error")
            XCTAssertNotNil(error, "Error cannot be nil when registration return validation error")

            XCTAssertEqual(error!.response!.statusCode, 200 , "Status code must be the same returned correctly")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testWebService_WithFailedRequest() throws {
        let provider = MoyaProvider<LoginAPI>(endpointClosure: customErrorEndpoint, stubClosure: MoyaProvider.immediatelyStub)
        sut = RegisterWebService(moyaProvider: provider)
        let expectation = self.expectation(description: "Response with failed request")
        
        sut.registerDatabase(userData) { (loginResult, resultModel, error) in
            XCTAssertNil(loginResult, "Result Model must be nil when registration request failed")
            XCTAssertNil(resultModel, "Result Model cannot be nil when registration request failed")
            XCTAssertNotNil(error, "Error cannot be nil when registration request failed")

            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    // MARK: Custom Moya functions
    func customSuccessWithInvalidStruct(_ target: LoginAPI) -> Endpoint {
        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: {.networkResponse(200, Data("Invalid message to be parsed".utf8))},
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }
    
    func customWebServiceValidatingError(_ target: LoginAPI) -> Endpoint {
        let data = "{\"success\": false, \"message\": \"Result with success equal false.\"}"
        let sampleData = Data(data.utf8)

        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: {.networkResponse(200, sampleData)},
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }
    
    func customErrorEndpoint(_ target: LoginAPI) -> Endpoint {
        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: { .networkError(NSError(domain: "Error 500", code: 500)) },
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }
}

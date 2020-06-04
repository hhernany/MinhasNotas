//
//  LoginWebServiceTests.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 04/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest
import Moya
@testable import MinhasPautas

class LoginWebServiceTests: XCTestCase {

    var sut: LoginWebService!
    var provider: MoyaProvider<LoginAPI>!
    var userData: [String:String]!
    
    override func setUpWithError() throws {
        userData = [
            "email": "validemail@gmail.com",
            "token_autenticacao": "notification_token"
        ]
    }

    override func tearDownWithError() throws {
        sut = nil
        provider = nil
        userData = nil
    }
    
    func testLoginWebService_WhithSuccessRequest() throws {
        let provider = MoyaProvider<LoginAPI>(stubClosure: MoyaProvider.immediatelyStub)
        sut = LoginWebService(moyaProvider: provider)
        let expectation = self.expectation(description: "Response with success expectation")
        
        sut.performLogin(userData) { (loginModel, resultModel, error) in
            XCTAssertNil(resultModel, "resultModel must be nil when login succeed")
            XCTAssertNil(error, "Error must be nil when login succeed")
            XCTAssertNotNil(loginModel, "loginModel cannot be nil when login succeed")
            XCTAssertTrue(loginModel!.success, "Login success must be true when login succeed")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testLoginWebService_ReturnValidatingError() throws {
        let provider = MoyaProvider<LoginAPI>(endpointClosure: customWebServiceValidatingError, stubClosure: MoyaProvider.immediatelyStub)
        sut = LoginWebService(moyaProvider: provider)
        let expectation = self.expectation(description: "Response with validating error expectation")
        
        sut.performLogin(userData) { (loginModel, resultModel, error) in
            XCTAssertNil(loginModel, "loginModel must be nil when login return validation error")
            XCTAssertNotNil(resultModel, "resultModel cannot be nil when login return validation error")
            XCTAssertNotNil(error, "Error cannot be nil when login return validation error")
            
            XCTAssertFalse(resultModel!.success, "ResultModel success must be false when registration failed")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testLoginWebService_WithInvalidResultStruct() throws {
        let provider = MoyaProvider<LoginAPI>(endpointClosure: customSuccessWithInvalidStruct, stubClosure: MoyaProvider.immediatelyStub)
        sut = LoginWebService(moyaProvider: provider)
        let expectation = self.expectation(description: "Response with invalid struct returned from remote webservice")
        
        sut.performLogin(userData) { (loginModel, resultModel, error) in
            XCTAssertNil(loginModel, "loginModel must be nil when login return validation error")
            XCTAssertNil(resultModel, "resultModel cannot be nil when login return validation error")
            XCTAssertNotNil(error, "Error cannot be nil when login return validation error")

            XCTAssertEqual(error!.response!.statusCode, 200 , "Status code must be the same returned correctly")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testLoginWebService_WithFailedRequest() throws {
        let provider = MoyaProvider<LoginAPI>(endpointClosure: customErrorEndpoint, stubClosure: MoyaProvider.immediatelyStub)
        sut = LoginWebService(moyaProvider: provider)
        let expectation = self.expectation(description: "Response with failed request")
        
        sut.performLogin(userData) { (loginModel, resultModel, error) in
            XCTAssertNil(loginModel, "loginModel must be nil when login request failed")
            XCTAssertNil(resultModel, "resultModel cannot be nil when login request failed")
            XCTAssertNotNil(error, "Error cannot be nil when login request failed")

            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
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

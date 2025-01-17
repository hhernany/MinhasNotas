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
}

//
//  XCTestExt.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 30/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import XCTest
import Moya

extension XCTest {
    // MARK: Custom Moya functions for Stubbed Responses
    func customSuccessWithInvalidStruct<T:TargetType>(_ target: T) -> Endpoint {
        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: {.networkResponse(200, Data("Invalid message to be parsed".utf8))},
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }
    
    func customWebServiceValidatingError<T:TargetType>(_ target: T) -> Endpoint {
        let data = "{\"success\": false, \"message\": \"Result with success equal false.\"}"
        let sampleData = Data(data.utf8)

        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: {.networkResponse(200, sampleData)},
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }
    
    func customErrorEndpoint<T:TargetType>(_ target: T) -> Endpoint {
        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: { .networkError(NSError(domain: "Error 500", code: 500)) },
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }
}

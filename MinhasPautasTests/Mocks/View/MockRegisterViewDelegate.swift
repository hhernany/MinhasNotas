//
//  MockRegisterViewDelegate.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 04/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import XCTest
@testable import MinhasPautas

class MockRegisterViewDelegate: RegisterViewControlerProtocol {
    var expectation: XCTestExpectation?
    var registerSuccessCounter = 0
    var registerErrorCounter = 0
    
    func registerSuccess() {
        registerSuccessCounter += 1
        expectation?.fulfill()
    }
    
    func registerError(message: String) {
        registerErrorCounter += 1
        expectation?.fulfill()
    }
}

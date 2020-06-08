//
//  MockLoginViewDelegate.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 04/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import XCTest
@testable import MinhasPautas

class MockLoginViewDelegate: LoginViewControlerProtocol {
    var expectation: XCTestExpectation?
    var loginSuccessCounter = 0
    var loginErrorCounter = 0
    
    func loginSuccess() {
        loginSuccessCounter += 1
        expectation?.fulfill()
    }
    
    func loginError(message: String) {
        loginErrorCounter += 1
        expectation?.fulfill()
    }
}

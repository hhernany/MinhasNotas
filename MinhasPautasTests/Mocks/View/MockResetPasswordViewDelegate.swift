//
//  MockResetPasswordViewDelegate.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 03/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import XCTest
@testable import MinhasPautas

class MockResetPasswordViewDelegate: ResetPasswordViewControlerProtocol {
    var expectation: XCTestExpectation?
    var resetSuccessCounter = 0
    var resetErrorCounter = 0
    
    func resetSuccess() {
        resetSuccessCounter += 1
        expectation?.fulfill()
    }
    
    func resetError(message: String) {
        resetErrorCounter += 1
        expectation?.fulfill()
    }
}

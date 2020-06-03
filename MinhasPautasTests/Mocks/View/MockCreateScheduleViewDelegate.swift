//
//  MockCreateScheduleViewDelegate.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 02/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import XCTest
@testable import MinhasPautas

class MockCreateScheduleViewDelegate: CreateScheduleViewControllerDelegate {
    var expectation: XCTestExpectation?
    var createSuccessCounter = 0
    var createErrorCounter = 0
    
    func createSuccess() {
        createSuccessCounter += 1
        expectation?.fulfill()
    }
    
    func createError(message: String) {
        createErrorCounter += 1
        expectation?.fulfill()
    }
}

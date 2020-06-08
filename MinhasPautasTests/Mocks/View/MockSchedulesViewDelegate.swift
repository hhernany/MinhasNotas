//
//  MockSchedulesViewDelegate.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 05/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import XCTest
@testable import MinhasPautas

class MockSchedulesViewDelegate: SchedulesViewControlerProtocol {
    //var expectation: XCTestExpectation?
    var reloadTableViewCounter = 0
    var resultLabelIsHiddenCounter = 0
    var updateErrorCounter = 0
    var resetCellStatusCounter = 0
    var controlMessageStatusCounter = 0

    func reloadTableView() {
        reloadTableViewCounter += 1
        //expectation?.fulfill()
    }
    
    func resultLabelIsHidden(state: Bool, message: String) {
        resultLabelIsHiddenCounter += 1
       // expectation?.fulfill()
    }
    
    func updateError(message: String) {
        updateErrorCounter += 1
        //expectation?.fulfill()
    }
    
    func resetLastCellStatus(tab: String) {
        resetCellStatusCounter += 1
        //expectation?.fulfill()
    }
    
    func controlMessageStatus() {
        controlMessageStatusCounter += 1
        //expectation?.fulfill()
    }
}

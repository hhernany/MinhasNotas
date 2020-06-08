//
//  MockSchedulesViewModel.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 05/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
@testable import MinhasPautas

// Used to test LoginViewController
class MockSchedulesViewModel: SchedulesViewModelProtocol {
    var schedulesList: [SchedulesModel] = []
    var schedulesListOpen: [SchedulesModel] = []
    var schedulesListClose: [SchedulesModel] = []
    
    var getInitialDataCalled = false
    var getMoreDataCalled = false
    var updateTableViewCalled = false
    var controlResultLabelCalled = false
    var expandedCellCalled = false
    var updateScheduleStatusCalled = false

    func getInitialData() {
        getInitialDataCalled = true
    }
    
    func getMoreData() {
        getMoreDataCalled = true
    }
    
    func updateTableView() {
        updateTableViewCalled = true
    }
    
    func controlResultLabel() {
        controlResultLabelCalled = true
    }
    
    func expandedCell(index: Int, type: String, status: Bool) {
        expandedCellCalled = true
    }
    
    func updateScheduleStatus(index: Int, listType: String) {
        updateScheduleStatusCalled = true
    }
}

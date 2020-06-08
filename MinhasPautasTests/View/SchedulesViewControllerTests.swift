//
//  SchedulesViewControllerTests.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 05/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest
@testable import MinhasPautas

class SchedulesViewControllerTests: XCTestCase {

    var storyboard: UIStoryboard!
    var sut: SchedulesViewController!
    var viewModel: MockSchedulesViewModel!
    
    override func setUpWithError() throws {
        storyboard = UIStoryboard(name: "Schedules", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "SchedulesVC") as? SchedulesViewController
        viewModel = MockSchedulesViewModel()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws{
        storyboard = nil
        sut = nil
        viewModel = nil
    }
    
    func testSchedulesViewController_WhenCreated_HasRequiredOutlets() throws {
        let _ = try XCTUnwrap(sut.noResultLabel, "The noResultLabel is not connect to an IBOutlet")
        let _ = try XCTUnwrap(sut.addButton, "The addButton is not connect to an IBOutlet")
        let _ = try XCTUnwrap(sut.segmentedControl, "The segmentedControl is not connect to an IBOutlet")
        let _ = try XCTUnwrap(sut.tableView, "The tableView is not connect to an IBOutlet")
    }
    
    func testSchedulesViewController_WhenUpdateSchedulesHandleRefresh_CallGetInitialData() throws {
        sut.schedulesViewModel = viewModel
        sut.updateSchedules()
        
        XCTAssertTrue(viewModel.getInitialDataCalled)
    }
}

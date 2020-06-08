//
//  SchedulesViewControllerUITests.swift
//  MinhasPautasUITests
//
//  Created by Hugo Hernany on 11/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest

class SchedulesViewControllerUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        super.setUp()
        let configuration = ConfigurationUITests()
        app = start(using: configuration)
    }
    
    override func tearDownWithError() throws {
        super.tearDown()
        app = nil
    }
    
    func testSchedulesListLabelsAndCells() throws {
        // Check if tableView exist and if have cells
        let tablesQuery = try XCTUnwrap(app.tables["scheduleTableView"], "SchedulesViewController: scheduleTableView dont exists")
        XCTAssert(tablesQuery.cells.count > 0, "SchedulesViewController: scheduleTableView dont have any open schedule")

        // Check if found first cell in table
        let firstCell = try XCTUnwrap(tablesQuery.cells.element(boundBy: 0), "SchedulesViewController: scheduleTableView cant detect first cell")
        
        // Expand Cell and click "Encerrar" button
        firstCell.tap()
        let changeStateButton = try XCTUnwrap(tablesQuery.buttons["changeStateButton"], "SchedulesTableViewCell: changeStateButton dont exists")
        changeStateButton.tap()
        
        // Verify total of open schedules and message label
        XCTAssert(tablesQuery.cells.count == 0, "Total of open schedules is incorret")
        XCTAssertTrue(app.staticTexts["Você não possui nenhuma pauta em aberto"].exists)
        
        // Change tab and check if have at less one schedule
        app.buttons["Fechadas"].tap()
        XCTAssert(tablesQuery.cells.count > 0, "SchedulesViewController: scheduleTableView dont have any closed schedule")
        
        // Expand Cell and click "Reabrir" button
        firstCell.tap()
        changeStateButton.tap()
        
        // Verify total of closed schedules and message label
        XCTAssert(tablesQuery.cells.count == 0, "Total of closed schedules is incorret")
        XCTAssertTrue(app.staticTexts["Você não possui nenhuma pauta fechada"].exists)
    }
    
    func testTableViewHandleRefresh() throws {
        // XCUICoordinate - Simulate pull to refresh using fisrt cell position.
        let firstCell = try XCTUnwrap(app.tables["scheduleTableView"].cells.element(boundBy: 0), "SchedulesViewController: scheduleTableView cant detect first cell")
        let start = firstCell.coordinate(withNormalizedOffset: (CGVector(dx: 0, dy: 0)))
        let finish = firstCell.coordinate(withNormalizedOffset: (CGVector(dx: 0, dy: 5)))
        start.press(forDuration: 0, thenDragTo: finish)
    }
}

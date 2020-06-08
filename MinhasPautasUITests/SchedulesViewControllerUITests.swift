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

    override func setUp() {
        super.setUp()
        let configuration = Configuration()
        app = start(using: configuration)
    }
    
    func testSchedulesListLabelsAndCells() {
        // Check if tableView exist and if have cells
        XCTAssert(app.tables["scheduleTableView"].exists, "SchedulesViewController: scheduleTableView dont exists")
        let tablesQuery = app.tables["scheduleTableView"]
        XCTAssert(tablesQuery.cells.count > 0, "SchedulesViewController: scheduleTableView dont have any open schedule")

        // Check if found first cell in table
        XCTAssert(tablesQuery.cells.element(boundBy: 0).exists, "SchedulesViewController: scheduleTableView cant detect first cell")
        let firstCell = tablesQuery.cells.element(boundBy: 0)
        
        // Expand Cell and click "Encerrar" button
        firstCell.tap()
        XCTAssert(tablesQuery.buttons["changeStateButton"].exists, "SchedulesCell: changeStateButton dont exists")
        let changeStateButton = tablesQuery.buttons["changeStateButton"]
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
    
    func testTableViewHandleRefresh() {
        // XCUICoordinate - Simulate pull to refresh using fisrt cell position.
        let firstCell = app.tables["scheduleTableView"].cells.element(boundBy: 0)
        let start = firstCell.coordinate(withNormalizedOffset: (CGVector(dx: 0, dy: 0)))
        let finish = firstCell.coordinate(withNormalizedOffset: (CGVector(dx: 0, dy: 5)))
        start.press(forDuration: 0, thenDragTo: finish)
    }
    
    override func tearDown() {
        super.tearDown()
        app = nil
    }
}

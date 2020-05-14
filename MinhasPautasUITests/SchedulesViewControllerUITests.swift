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

    // O que falta arrumar
    // 1 - Como lidar quando demora pra sumir o spinner por causa da internet lenta?
    // 2 - É correto testar pegando da API? Esses testes deveriam ser sempre locais?
    // 3 - Como lidar com o caso de que nem sempre vai ter a lista vazia pra testar as mensagens? Usar contas diferentes ou dados locais?
    override func setUp() {
        super.setUp()
        UserDefaults.standard.set("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mywibm9tZSI6IlRFU1RBTkRPIFBFTE8gQVBQIiwiaWF0IjoxNTg5MjI0MDIzfQ.GcrGUO_idI1W8bmq3GNMrlIuIaXZOX8bFwppvw95YtA", forKey: "token_jwt")
        app = XCUIApplication()
        continueAfterFailure = false
        app.launch()
    }

    func testSegmentedControlLabelAndAction() {
        let tablesQuery = app.tables["scheduleTableView"]

        app/*@START_MENU_TOKEN@*/.buttons["Fechadas"]/*[[".segmentedControls.buttons[\"Fechadas\"]",".buttons[\"Fechadas\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        if tablesQuery.cells.count == 0 {
            XCTAssertTrue(app.staticTexts["Você não possui nenhuma pauta fechada"].exists)
        }

        app/*@START_MENU_TOKEN@*/.buttons["Abertas"]/*[[".segmentedControls.buttons[\"Abertas\"]",".buttons[\"Abertas\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        if tablesQuery.cells.count == 0 {
            XCTAssertTrue(app.staticTexts["Você não possui nenhuma pauta em aberto"].exists)
        }
    }
    
    func testExpandableCellAndChangeStatus() {
        // TableView
        let tablesQuery = app.tables["scheduleTableView"]
        XCTAssertTrue(tablesQuery.cells.count > 0)
        
        let firstCell = tablesQuery.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists)
        firstCell.tap()
        
        // Expand Cell and click "Encerrar" button
        let encerrarButton = tablesQuery.buttons["Encerrar"]
        encerrarButton.tap()
        if tablesQuery.cells.count == 0 {
            XCTAssertTrue(app.staticTexts["Você não possui nenhuma pauta em aberto"].exists)
        }
        
        // Change tab and click in firstCell
        app.buttons["Fechadas"].tap()
        XCTAssertTrue(tablesQuery.cells.count > 0)
        firstCell.tap()
        
        let reabrirButton = tablesQuery.buttons["Reabrir"]
        reabrirButton.tap()
        if tablesQuery.cells.count == 0 {
            XCTAssertTrue(app.staticTexts["Você não possui nenhuma pauta fechada"].exists)
        }
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
        UserDefaults.standard.removeObject(forKey: "token_jwt")
        app = nil
    }
}

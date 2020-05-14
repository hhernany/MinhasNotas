//
//  CreateScheduleViewControllerTests.swift
//  MinhasPautasUITests
//
//  Created by Hugo Hernany on 13/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest

class CreateScheduleViewControllerTests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        app = start(using: Configuration())
    }

    override func tearDown() {
        super.tearDown()
        app = nil
    }

    func testScreenCreateSchedules() {
        XCTAssert(app.navigationBars["Minhas Pautas"].buttons["addButton"].exists, "addButton not found: SchedulesViewController")
        app.navigationBars["Minhas Pautas"].buttons["addButton"].tap()
        
        // Fields and Labels
        let title = app.textFields["titleTextField"]
        let description = app.textFields["descriptionTextField"]
        let content = app.textViews["contentTextView"]
        let author = app.staticTexts["authorLabel"]
        let qtdCharacters = app.staticTexts["qtdCharactersLabel"]
        let createButton = app.navigationBars["Nova Pauta"].buttons["createButton"]
        let keyboardOkButton = app.toolbars["Toolbar"].buttons["OK"]

        // Button must be disabled at start
        XCTAssert(!createButton.isEnabled, "Button must be disabled at start")
        
        // Author name
        let authorText = "Autor: \(UserDefaults.standard.object(forKey: "nome_usuario") as? String ?? "")"
        XCTAssert(author.label == authorText, "authorLabel format is incorrect")
        
        // Title Field and Characters count
        title.tap()
        XCTAssert(qtdCharacters.label == "0 de 50", "titleTextField characters count is incorrect")
        title.typeText("Titulo")
        XCTAssert(qtdCharacters.label == "6 de 50", "titleTextField characters count is incorrect")
        keyboardOkButton.tap()
        
        // Description Field and Characters count
        description.tap()
        XCTAssert(qtdCharacters.label == "0 de 100", "descriptionTextField characters count is incorrect")
        description.typeText("Descrição")
        XCTAssert(qtdCharacters.label == "9 de 100", "descriptionTextField characters count is incorrect")
        keyboardOkButton.tap()
        
        // Content Field and Characters count
        content.tap()
        XCTAssert(qtdCharacters.label == "0 de 1000", "contentTextField characters count is incorrect")
        content.typeText("Conteudo")
        XCTAssert(qtdCharacters.label == "8 de 1000", "contentTextField characters count is incorrect")
        keyboardOkButton.tap()

        // Check if create button is enabled
        XCTAssertTrue(createButton.isEnabled)
    }
}

// Helpers of all this
extension XCTestCase {
    func start(using configuration: Configuration) -> XCUIApplication {
        continueAfterFailure = false // Stop execution after a failure occurs
        let app = XCUIApplication() // Create instance
        app.launchEnvironment.merge((configuration.dictionary), uniquingKeysWith: { (_, new) in new }) // Add launch parameters
        app.launchArguments += ["UI-Testing"]
        app.launch() // Launch app
        return app // Return instance
    }
    
    func intercepetAndCloseAlerts(name withTitle: String, button buttonName: String) {
        addUIInterruptionMonitor(withDescription: withTitle) { (alerts) -> Bool in
            if alerts.buttons[buttonName].exists {
                alerts.buttons[buttonName].tap()
            }
            return true
        }
    }
    
    // Melhorar com o link = https://masilotti.com/xctest-helpers/
    func waitForElementToAppear(_ element: XCUIElement) -> Bool {
        let existsPredicate = NSPredicate(format: "exists == true")
        let expectation = XCTNSPredicateExpectation(predicate: existsPredicate,
                                                    object: element)
        
        let result = XCTWaiter().wait(for: [expectation], timeout: 5)
        
        if result == .completed {
            return true
        } else {
            return false
        }
        //return result == .completed
    }
    
    func tapButton(app: XCUIApplication, identifier buttonIdentifier: String) {
        app.buttons[buttonIdentifier].tap()
    }
}

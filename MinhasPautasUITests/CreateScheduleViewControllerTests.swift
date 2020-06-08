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
    var configurationKeys: ConfigurationKeys!
    
    override func setUpWithError() throws {
        app = start(using: ConfigurationUITests())
    }

    override func tearDownWithError() throws {
        super.tearDown()
        app = nil
        configurationKeys = ConfigurationKeys()
    }

    func testScreenCreateSchedules() throws {
        let addButton = try XCTUnwrap(app.navigationBars["Minhas Pautas"].buttons["addButton"], "addButton not found: SchedulesViewController")
        addButton.tap()
        
        // Fields and Labels
        let titleTextField = try XCTUnwrap(app.textFields["titleTextField"], "titleTextField dont exists")
        let descriptionTextField = try XCTUnwrap(app.textFields["descriptionTextField"], "descriptionTextField dont exists")
        let contentTextView = try XCTUnwrap(app.textViews["contentTextView"], "contentTextView dont exists")
        let authorLabel = try XCTUnwrap(app.staticTexts["authorLabel"], "authorLabel dont exists")
        let qtdCharactersLabel = try XCTUnwrap(app.staticTexts["qtdCharactersLabel"], "qtdCharactersLabel dont exists")
        let createButton = try XCTUnwrap(app.navigationBars["Nova Pauta"].buttons["createButton"], "createButton dont exists")
        let keyboardOkButton = try XCTUnwrap(app.toolbars["Toolbar"].buttons["OK"], "Keyboard toolbar dont exists")

        // Button must be disabled at start
        XCTAssert(!createButton.isEnabled, "Button must be disabled at start")
        
//        // Author name
//        let authorText = "Autor: \(UserDefaults.standard.object(forKey: "nome_usuario") as? String ?? "")"
//        print(authorText)
//        print(authorLabel.label)
//
//        XCTAssert(authorLabel.label == authorText, "authorLabel format is incorrect")
        
        // Title Field and Characters count
        titleTextField.tap()
        XCTAssert(qtdCharactersLabel.label == "0 de 50", "titleTextField characters count is incorrect")
        titleTextField.typeText("Titulo")
        XCTAssert(qtdCharactersLabel.label == "6 de 50", "titleTextField characters count is incorrect")
        keyboardOkButton.tap()
        
        // Description Field and Characters count
        descriptionTextField.tap()
        XCTAssert(qtdCharactersLabel.label == "0 de 100", "descriptionTextField characters count is incorrect")
        descriptionTextField.typeText("Descrição")
        XCTAssert(qtdCharactersLabel.label == "9 de 100", "descriptionTextField characters count is incorrect")
        keyboardOkButton.tap()
        
        // Content Field and Characters count
        contentTextView.tap()
        XCTAssert(qtdCharactersLabel.label == "0 de 1000", "contentTextField characters count is incorrect")
        contentTextView.typeText("Conteudo")
        XCTAssert(qtdCharactersLabel.label == "8 de 1000", "contentTextField characters count is incorrect")
        keyboardOkButton.tap()

        // Check if create button is enabled
        XCTAssertTrue(createButton.isEnabled)
    }
}

// Helpers of all this
extension XCTestCase {
    func start(using configuration: ConfigurationUITests) -> XCUIApplication {
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

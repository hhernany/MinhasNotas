//
//  XCTestExt.swift
//  MinhasPautasUITests
//
//  Created by Hugo Hernany on 10/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import XCTest

extension XCTestCase {
    func start(using configuration: ConfigurationUITests) -> XCUIApplication {
        let app = XCUIApplication() // Create instance
        continueAfterFailure = false // Stop execution after a failure occurs
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

//
//  CreateScheduleViewControllerTests.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 02/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest
@testable import MinhasPautas

class CreateScheduleViewControllerTests: XCTestCase {

    var storyboard: UIStoryboard!
    var sut: CreateScheduleViewController!
    
    override func setUpWithError() throws {
        storyboard = UIStoryboard(name: "Schedules", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "CreateScheduleVC") as? CreateScheduleViewController
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        storyboard = nil
        sut = nil
    }

    func testCreateScheduleViewController_WhenCreated_HasRequiredOutlets() throws {
        let titleTextFeild = try XCTUnwrap(sut.titleTextField, "The titleTextField is not connect to an IBOutlet")
        let descriptionTextField = try XCTUnwrap(sut.descriptionTextField, "The descriptionTextField is not connect to an IBOutlet")
        let contentTextView = try XCTUnwrap(sut.contentTextView, "The contentTextView is not connect to an IBOutlet")
        let _ = try XCTUnwrap(sut.totalCharactersTextField, "The totalCharactersTextField is not connect to an IBOutlet")

        // TextFields must be empty in the start
        XCTAssertEqual(titleTextFeild.text, "", "descriptionTextField is not empty when the view controller initially loaded")
        XCTAssertEqual(descriptionTextField.text, "", "descriptionTextField is not empty when the view controller initially loaded")
        XCTAssertEqual(contentTextView.text, "", "contentTextView not empty when the view controller initially loaded")
    }
    
    
    func testCreateScheduleViewController_WhenCreated_HasCreateButtonAction() throws {
        // Arrange
        let createButton: UIBarButtonItem = try XCTUnwrap(sut.createButton, "createButton it not connect to an IBOutlet")
        let _: Selector = try XCTUnwrap(sut.createButton.action, "createButton has no action")
        
        // Assert
        XCTAssertFalse(createButton.isEnabled, "createButton must be disable in the start")
    }

    func testCreateScheduleViewController_WhenCreateTapped_InvokesCreateProcess() throws {
        // Arrange
        let buttonSelector : Selector = try XCTUnwrap(sut.createButton.action, "createButton has no action")

        let viewDelegate = MockCreateScheduleViewDelegate()
        let webservice = CreateScheduleWebService()
        let viewModel = MockCreateScheduleViewModel(delegate: viewDelegate, webservice: webservice)
        sut.createScheduleViewModel = viewModel
        
        // Act
        _ = sut.createButton.target?.perform(buttonSelector, with: nil)
        
        // Assert
        XCTAssertTrue(viewModel.sendFormDataCalled, "The sendFormData() method was not called when tapped in createButton")
    }
}

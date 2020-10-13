//
//  SchedulesPresenterTests.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 05/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest
@testable import MinhasPautas

class SchedulesPresenterTests: XCTestCase {

    var sut: SchedulesPresenter!
    var viewDelegate: MockSchedulesViewDelegate!
    var webservice: MockSchedulesWebService!
    var schedulesModel: SchedulesModel!
    
    override func setUpWithError() throws {
        viewDelegate = MockSchedulesViewDelegate()
        webservice = MockSchedulesWebService()
        sut = SchedulesPresenter(delegate: viewDelegate, webservice: webservice)
        
        sut.schedulesList = [SchedulesModel(id_pauta: 1, titulo: "Title 1", descricao: "Description 1", detalhes: "Detail 1", nome_usuario: "User 1", status: "Aberto", expanded: true)]
        sut.schedulesListOpen = [SchedulesModel(id_pauta: 2, titulo: "Title 2", descricao: "Description 2", detalhes: "Detail 2", nome_usuario: "User 2", status: "Aberto", expanded: true)]
        sut.schedulesListClose = [SchedulesModel(id_pauta: 3, titulo: "Title 3", descricao: "Description 3", detalhes: "Detail 3", nome_usuario: "User 3", status: "Fechado", expanded: false)]
    }

    override func tearDownWithError() throws {
        sut = nil
        viewDelegate = nil
        webservice = nil
        schedulesModel = nil
    }

    func testPresenter_WhenGetInitialDataSucceed_ShouldCallReloadTableView() throws {
        // Act
        sut.getInitialData()
        
        // Assert
        XCTAssertEqual(viewDelegate.reloadTableViewCounter, 1, "The reloadTableView() method was called more than one time")
    }
    
    func testPresenter_WhenGetInitialDataReturnError_ShouldCallReloadTableView() throws {
        // Act
        webservice.getDataReturnResultErrorMessage = true
        sut.getInitialData()
        
        // Assert
        XCTAssertEqual(viewDelegate.reloadTableViewCounter, 1, "The reloadTableView() method was called more than one time")
        XCTAssertEqual(viewDelegate.resultLabelIsHiddenCounter, 1, "The resultLabelIsHidden() method was called more than one time")
    }
    
    func testPresenter_WhenGetInitialDataWebServiceError_ShouldCallReloadTableView() throws {
        // Act
        webservice.getDataRemoteErrorMessage = true
        sut.getInitialData()
        
        // Assert
        XCTAssertEqual(viewDelegate.reloadTableViewCounter, 1, "The reloadTableView() method was called more than one time")
        XCTAssertEqual(viewDelegate.resultLabelIsHiddenCounter, 1, "The resultLabelIsHidden() method was called more than one time")
    }
    
    func testPresenter_WhenUpdataStatusOpenSucceed_MustContainCorrectData() throws {
        sut.updateScheduleStatus(index: 0, listType: "Aberto")
        
        XCTAssertEqual(sut.schedulesListOpen.count, 0, "After update list must be updated")
        XCTAssertEqual(sut.schedulesListClose.count, 2, "After update list must be updated")
        XCTAssertEqual(viewDelegate.reloadTableViewCounter, 1, "The reloadTableView() method was called more than one time")
    }
    
    func testPresenter_WhenUpdataStatusClosedSucceed_MustContainCorrectData() throws {
        sut.updateScheduleStatus(index: 0, listType: "Fechado")
        
        XCTAssertEqual(sut.schedulesListClose.count, 0, "After update list must be updated")
        XCTAssertEqual(sut.schedulesListOpen.count, 2, "After update list must be updated")
        XCTAssertEqual(viewDelegate.reloadTableViewCounter, 1, "The reloadTableView() method was called more than one time")
    }
    
    func testPresenter_WhenUpdataStatusReturnFalse_ShouldCallUpdateError() throws {
        webservice.updateDataReturnError = true
        sut.updateScheduleStatus(index: 0, listType: "Fechado")
        
        XCTAssertEqual(sut.schedulesListClose.count, 0, "After update list must be updated")
        XCTAssertEqual(sut.schedulesListOpen.count, 2, "After update list must be updated")
        XCTAssertEqual(viewDelegate.updateErrorCounter, 1, "The updateError() method was called more than one time")
        XCTAssertEqual(viewDelegate.reloadTableViewCounter, 1, "The reloadTableView() method was called more than one time")
    }
    
    func testPresenter_WhenUpdataStatusReturnRemoteError_ShouldCallUpdateError() throws {
        webservice.updateDataRemoteErrorMessage = true
        sut.updateScheduleStatus(index: 0, listType: "Fechado")
        
        XCTAssertEqual(sut.schedulesListClose.count, 0, "After update list must be updated")
        XCTAssertEqual(sut.schedulesListOpen.count, 2, "After update list must be updated")
        XCTAssertEqual(viewDelegate.updateErrorCounter, 1, "The updateError() method was called more than one time")
        XCTAssertEqual(viewDelegate.reloadTableViewCounter, 1, "The reloadTableView() method was called more than one time")
    }
    
    func testPresenter_WhenCollapseCell_ExpandedMustBeFalse() throws {
        sut.expandedCell(index: 0, type: "Aberto", status: false)
        
        XCTAssertFalse(sut.schedulesListOpen[0].expanded, "Cell must collapse after update status. Status must be false")
    }
    
    func testPresenter_WhenCollapseCell_ExpandedMustBeTrue() throws {
        sut.expandedCell(index: 0, type: "Fechado", status: true)
        
        XCTAssertTrue(sut.schedulesListClose[0].expanded, "Cell must expand after update status. Status must be true")
    }
    
    func testPresenter_WhenGetMoreDataSuccess_ShouldCallReloadTableView() throws {
        sut.getMoreData()
        
        XCTAssertEqual(viewDelegate.reloadTableViewCounter, 1, "The reloadTableView() method was called more than one time")
    }
}

//
//  SchedulesModelTests.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 05/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest
@testable import MinhasPautas

class SchedulesModelTests: XCTestCase {

    var sut: SchedulesModel!
    
    override func setUpWithError() throws {
        sut = SchedulesModel(id_pauta: 1,
                             titulo: "Title",
                             descricao: "description",
                             detalhes: "details",
                             nome_usuario: "userName",
                             status: "Aberto",
                             expanded: false)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testScheduleModel_UpdateStatus() throws {
        sut.updateStatus("Fechado")
        XCTAssertEqual(sut.status, "Fechado", "Schedule status dont update")
    }
    
    func testScheduleModel_ExpandCell() throws {
        sut.expandedCell(true)
        XCTAssertTrue(sut.expanded, "Expanded field must be true")
    }
}

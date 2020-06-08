//
//  PerfilViewControllerTests.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 05/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest
@testable import MinhasPautas

class PerfilViewControllerTests: XCTestCase {
    
    var storyboard: UIStoryboard!
    var sut: PerfilViewController!
    
    override func setUpWithError() throws {
        storyboard = UIStoryboard(name: "Perfil", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "PerfilVC") as? PerfilViewController
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws{
        storyboard = nil
        sut = nil
    }
    
    func testPerfilViewControllerTests_WhenCreated_HasRequiredOutlets() throws {
        let _ = try XCTUnwrap(sut.nameTextField, "The nameTextField is not connect to an IBOutlet")
        let _ = try XCTUnwrap(sut.emailTextField, "The emailTextField is not connect to an IBOutlet")
        let _ = try XCTUnwrap(sut.tableView, "The tableView is not connect to an IBOutlet")
    }
}

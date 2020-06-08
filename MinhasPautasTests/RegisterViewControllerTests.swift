//
//  RegisterViewControllerTests.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 19/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest
@testable import MinhasPautas

class RegisterViewControllerTests: XCTestCase {

    var sut: RegisterViewController!
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "registerVC") as! RegisterViewController
//        let nav = UINavigationController.init(rootViewController: vc)
//        sut = (nav.topViewController as! RegisterViewController)
        sut = vc
        let _ = sut.view // Load view hierarchy
    }

    func testSUT() {
        XCTAssertNotNil(sut)
    }
    
    // Diz que é possível usar is, as ou as? para testar se está em conformidade no Swift.
    // Porém não deu certo, fica dando vários avisos e não encontrei nada rapidamente de reposta sobre isso.
    // Pesquisar mais a fundo. Assim posso tirar o @objc do protocolo e testar no padrão Swift em vez de usar uma função do OBJ-c
    func testControllerConformsToDelegate() {
        let conforms = sut.conforms(to: RegisterViewControlerDelegate.self)
        XCTAssert(conforms, "sut does not conform to RegisterViewControllerDelegate protocol")
    }
    
    func testViewModelIsSet() {
        XCTAssertNotNil(sut.registerViewModel)
    }
    
    func testOutlets() {
        
    }
    
    func testConfirmButtonAction() {
        let actions = buttonActions(button: sut.registerButton)
        XCTAssertNotNil(actions)
        if let actions = actions {
            XCTAssertTrue(actions.count > 0)
            XCTAssert(actions.contains("didTapRegisterButton:"))
        }
    }
    
    func testCancelBarButtonAction() {
        XCTAssertTrue(sut.cancelButton.action == #selector(RegisterViewController.didTapCancelButton(_:)))
    }
    
    func buttonActions(button: UIButton?) -> [String]? {
        return button?.actions(forTarget: sut, forControlEvent: .touchUpInside)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
}

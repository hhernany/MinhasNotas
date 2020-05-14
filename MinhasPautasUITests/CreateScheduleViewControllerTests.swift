//
//  CreateScheduleViewControllerTests.swift
//  MinhasPautasUITests
//
//  Created by Hugo Hernany on 13/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest

class CreateScheduleViewControllerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    // Ao entrar o botão Criar tem que estar desativado
    // Nome do autor na barra inferior tem que ser o usuário atualmente logado
    // Quando clicar em cada um dos campos tem que mostrar "0 de xxxx"
    // Digitar algo no campo titulo e a quantidade de digitos tem que estar correta
    // Digitar algo no campo de descrição e a quantidade de digitos tem que estar correta
    // Digitar algo no campo de conteúdo e a quantidade de digitos tem que estar correta
    // Após todos os campos digitos o botão Criar tem que estar ativado para clique.
    
    // Não precisa testar avisos pq não tem nem como clicar em Criar sem estar tudo preenchido.
}

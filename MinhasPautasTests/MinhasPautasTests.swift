//
//  MinhasPautasTests.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 30/04/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest
@testable import MinhasPautas

// Possíveis testes
// Se o ViewModel consegue obter os dados da APIService
// Se o ViewModel está mostrando as mensagens de erro quando um erro acontece.
// Se o Spinner começou a executar quando inicio a obtenção dos dados
// Se o spinner parou quando terminar de obter os dados ou deu erro
// Testar se um model está inicializando corretamente e não é nulo (Salvar o JSON talvez e passar o map pra ver se os campos estão preenchidos?)

class MinhasPautasTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

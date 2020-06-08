//
//  MinhasPautasTests.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 30/04/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import XCTest
@testable import MinhasPautas

// Um teste unitário não testa várias funções diferentes. Ele deve testar um única função.



// Possíveis testes
// Se o ViewModel consegue obter os dados da APIService
// Se o ViewModel está mostrando as mensagens de erro quando um erro acontece.
// Se o Spinner começou a executar quando inicio a obtenção dos dados
// Se o spinner parou quando terminar de obter os dados ou deu erro
// Testar se um model está inicializando corretamente e não é nulo (Salvar o JSON talvez e passar o map pra ver se os campos estão preenchidos?)

class MinhasPautasTests: XCTestCase {

    var sut: RegisterViewModel!
    var fakeVC = FakeViewController()
    
    override func setUp() {
        super.setUp()
        sut = RegisterViewModel(delegate: fakeVC)
    }

    override func tearDown() {
        sut = nil
    }

    func testValidateCredentialsFields() {
        // Quando não preenche um campo, é chamada uma função dentro do viewModel, que por sua vez chamada a função dentro da viewController.
        // A função dentro da viewController monstra o alerta na tela.
        // Como testar isso?
        
        // Criei uma viewControllerFake, que extende do protocolo que ao ViewModel precisa.
        // Assim o que a viewController vai executar eu determino dentro da fakeVC.
        
        // Ou aqui no caso apenas testando as mensagens de erro dos campos, pra ver se tá validando mesmo.
        // Está correto isso? Pegar uma mensagem da fakeVC? Qual outra forma?
        // Minha viewModel está errada? Minha Função está errada lá? O que seria?
        let model = RegisterModel(name: "Test", email: "hugo@gmail.com", emailConfirmation: "hugo2@gmail.com", password: "123456", passwordConfirmation: "123456")
        sut.sendCredentials(data: model)
        XCTAssertNotNil(fakeVC.errorMessage)
        XCTAssertEqual("mensagem de erro", fakeVC.errorMessage)
    }
    
    func testReturnStatus() {
        // Agora fazer uma chamada falsa de API, para ter o retorno esperado.
        // Quando da certo, remove o spinner, e mostra a mensagem de sucesso.
        // quando da erro, remove o spinner, e mostra a mensagem de erro.
    }
    
    func testeRegisterViewController() {
        // Da pra testar a viewController em si, se ela está preenchendo corretamente, se os botões estão com ação, etc.
        // https://www.vadimbulavin.com/unit-testing-view-controller-uiviewcontroller-and-uiview-in-swift/
        // https://priteshrnandgaonkar.github.io/Unit-Testing-a-feature/
        // https://clean-swift.com/testing-view-controller-part-1/
    }
}

// Inicialmente apenas testando as possibilidades para entender melhor a forma correta de testar tudo.
// E se terei que refator algumas partes do projeto para ser mais "testável"
class FakeViewController: RegisterViewControlerDelegate {
    var errorMessage: String?
    
    func registerSuccess() {
        errorMessage = nil
    }
    
    func registerError(message: String) {
        errorMessage = message
    }
}

//
//  LoginViewModel.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 30/04/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import Moya

// Add ": class"  if change struct by class
protocol LoginViewModelDelegate {
    func sendCredentials(email: String, password: String)
}

struct LoginViewModel {
    
    // weak var is not necessary. Because we are using Struct instead of Class
    // If using class instead struct, change for weak var because of reference cycles.
    var viewModelDelegate: LoginViewControlerDelegate?
    fileprivate let provider = MoyaProvider<LoginAPI>()
    fileprivate let decoder = JSONDecoder()

    // Dependency Injection
    init(delegate: LoginViewControlerDelegate?) {
        viewModelDelegate = delegate
    }
    
//    fileprivate func performLogin(email: String, password: String) {
//        provider.request(.loadIssues(page: page)) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let response):
//                do {
//                    // DEU SUCESSO, CHAMA A FUNÇÃO NA VC QUE PREENCHER A TELA E FAZ O REDIRECIONAMENTO E TAL.
//                    self.issuesList += try response.map([IssuesDataset].self)
//                    self.showView()
//                } catch {
//                    // DEU FALHA, CHAMA A FUNÇÃO NA VC QUE MOSTRA OS AVISOS DE ERROS E TAL.
//                    // TIRAR TUDO DAQUI QUE COMUNICA COM A VIEW, VAI SER TUDO LA DENTRO.
//                    self.showView()
//                    self.hideResultLabel(state: false)
//                    print("Erro ao mapear resultados: \(error.localizedDescription)")
//                }
//            case .failure:
//                // DEU FALHA, CHAMA A FUNÇÃO NA VC QUE MOSTRA OS AVISOS DE ERROS E TAL.
//                // TIRAR TUDO DAQUI QUE COMUNICA COM A VIEW, VAI SER TUDO LA DENTRO.
//                self.showView()
//                if self.page == 0 {
//                    self.hideResultLabel(state: false)
//                }
//                print("Erro ao obter dados: \(result.error.debugDescription)")
//            }
//        }
//    }
}

extension LoginViewModel: LoginViewModelDelegate {
    // Recieve credentials to login
    // Talvez criar um completion handler aqui, que ao finalizar a execução da chamada da API, executar a closure passada.
    // Onde a closure será mostrar ou não mostrar os spinners de carregamento por exemplo. Algo assim.
    func sendCredentials(email: String, password: String) {
        //performLogin(email: email, password: password)
    }
}

//
//  LoginViewModel.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 30/04/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import Moya
import Firebase

// Add ": class"  if change struct by class
protocol LoginViewModelDelegate {
    func sendCredentials(email: String, password: String)
    func loginSuccess()
    func loginError(message: String)
}

struct LoginViewModel {
    
    // weak var is not necessary. Because we are using Struct instead of Class.
    // If using class instead struct, change for weak var because of reference cycles.
    var viewModelDelegate: LoginViewControlerDelegate?
    fileprivate let provider = MoyaProvider<LoginAPI>()

    // Dependency Injection
    init(delegate: LoginViewControlerDelegate?) {
        viewModelDelegate = delegate
        self.logoutUserFirebase()
    }
    
    // Logout user on Firebase when loginVC are presented.
    private func logoutUserFirebase() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    // Firebase login
    private func loginFirebase(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard let userData = user?.user else {
                let err = error! as NSError
                let errorMessage = self.firebaseErrorCode(err)
                self.loginError(message: errorMessage)
                return
            }
            
            // POST DATA
            // ESSE NOME NÃO VAI TER MAIS NO LOGIN DEPOIS QUE FIZER A NOVA API
//            "nome": userData.displayName ?? "",

            let data: [String:String] = [
                "nome": userData.displayName ?? "TESTANDO PELO APP",
                "email": email,
                "token_autenticacao": userData.uid,
                "token_notificacao": "NOTIFICACAO TESTE"
            ]
            
            self.performLogin(data)
        }
    }
    
    private func performLogin(_ userData: [String:String]) {
        provider.request(.login(data: userData)) { result in
            switch result {
            case .success(let response):
                do {
                    let login = try response.map(LoginModel.self)
                    if login.success == false {
                        self.loginError(message: login.message)
                        return
                    }
                    self.loginSuccess()
                } catch {
//                    {
//                        message = "Informe o nome do usu\U00e1rio";
//                        success = 0;
//                    }
                    // QUANDO UM CAMPO TA FALTANDO VEM ISSO ACIMA. CONFERIR.
                    self.loginError(message: "Não foi possível realizar o login. Por favor, entre em contato com o suporte.")
                    print("Erro ao mapear resultados: \(error.localizedDescription)")
                }
            case .failure:
                self.loginError(message: "Não foi possível realizar o login. Por favor, entre em contato com o suporte.")
                print("Erro ao obter dados: \(result.error.debugDescription)")
            }
        }
    }
    
    // Firebase error code
    private func firebaseErrorCode(_ error: NSError) -> String {
        switch error.code {
        case 17008:
            return "E-mail inválido."
        case 17009:
            return "Senha inválida."
        case 17011:
            return "Conta não cadastrada."
        default:
            return "Não foi possível realizar o login. Por favor, tente novamente."
        }
    }
}

extension LoginViewModel: LoginViewModelDelegate {
    func loginSuccess() {
        viewModelDelegate?.loginSuccess()
    }
    
    func loginError(message: String) {
        viewModelDelegate?.loginError(message: message)
    }
    
    func sendCredentials(email: String, password: String) {
        loginFirebase(email: email, password: password)
    }

}


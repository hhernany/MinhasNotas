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
        self.removeLocalData()
    }
    
    // Logout user on Firebase when loginVC are presented.
    private func logoutUserFirebase() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    // Save local data (UserDefaults)
    private func saveLocalData(data: LoginModel) {
        UserDefaults.standard.set(data.token_jwt, forKey: "token_jwt")
        UserDefaults.standard.set(data.usuario.nome, forKey: "nome_usuario")
        UserDefaults.standard.set(data.usuario.email, forKey: "email_usuario")
    }
    
    // Remove local data from UserDefaults
    private func removeLocalData() {
        let chaves = [
            "nome_usuario",
            "token_jwt",
            "email_usuario"
        ]
        
        for key in chaves {
            UserDefaults.standard.removeObject(forKey: key)
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
            let data: [String:String] = [
                "email": email,
                "token_autenticacao": userData.uid
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
                    self.saveLocalData(data: login)
                    self.loginSuccess()
                } catch {
                    guard let json = try? JSONSerialization.jsonObject(with: response.data, options: []) as! [String : Any] else {
                        self.loginError(message: "Não foi possível realizar o login. Por favor, tente novamente mais tarde.")
                        return
                    }
                    if json["success"] as? Bool == false {
                        self.loginError(message: json["message"] as? String ?? "Não foi possível realizar o login. Por favor, tente novamente mais tarde.")
                        return
                    }
                    print("Erro desconhecido ao tentar mapear resultados: \(error.localizedDescription)")
                }
            case .failure:
                self.loginError(message: "Não foi possível realizar o login. Por favor, tente novamente mais tarde.")
                print("Erro ao obter dados: \(result.error.debugDescription)")
            }
        }
    }
    
    // Firebase error code
    private func firebaseErrorCode(_ error: NSError) -> String {
        switch error.code {
        case AuthErrorCode.invalidEmail.rawValue:
            return "O e-mail informado não é uma e-mail válido."
        case AuthErrorCode.wrongPassword.rawValue:
            return "A senha informada está incorreta."
        case AuthErrorCode.userNotFound.rawValue:
            return "Conta não cadastrada."
        default:
            return "Não foi possível realizar o login. Por favor, tente novamente mais tarde."
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
        if email.isEmpty {
            loginError(message: "Informe o e-mail de acesso.")
            return
        }
        if !email.contains(".") || !email.contains("@") {
            loginError(message: "E-mail inválido.")
        }
        if password.isEmpty {
            loginError(message: "Informe a senha de acesso.")
            return
        }
        loginFirebase(email: email, password: password)
    }
}


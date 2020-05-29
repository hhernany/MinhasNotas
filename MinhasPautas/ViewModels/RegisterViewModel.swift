//
//  RegisterViewModel.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 01/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import Moya
import Firebase

// Add ": class"  if change struct by class
protocol RegisterViewModelDelegate {
    func sendCredentials(data: RegisterModel)
    func registerSuccess()
    func registerError(message: String)
}

struct RegisterViewModel {
    
    // weak var is not necessary. Because we are using Struct instead of Class.
    // If using class instead struct, change for weak var because of reference cycles.
    var viewModelDelegate: RegisterViewControlerDelegate?
    fileprivate let provider = MoyaProvider<LoginAPI>()
    
    // Dependency Injection
    init(delegate: RegisterViewControlerDelegate?) {
        viewModelDelegate = delegate
    }
    
    // Firebase Register
    private func registerFirebase(registerData: RegisterModel) {
        Auth.auth().createUser(withEmail: registerData.email , password: registerData.password) { (authResult, error) in
            guard let user = authResult?.user else {
                let err = error! as NSError
                let errorMessage = self.firebaseRegisterErrorCode(err)
                self.registerError(message: errorMessage)
                return
            }

            // Save user in database
            let userData: [String:String] = [
                "nome": registerData.name,
                "email": registerData.email,
                "token_autenticacao": user.uid
            ]
            self.registerDatabase(userData)
        }
    }
    
    private func registerDatabase(_ userData: [String:String]) {
        provider.request(.register(data: userData)) { result in
            switch result {
            case .success(let response):
                do {
                    let login = try response.map(LoginModel.self)
                    if login.success == false {
                        self.registerError(message: login.message)
                        return
                    }
                    self.registerSuccess()
                } catch {
                    guard let json = try? JSONSerialization.jsonObject(with: response.data, options: []) as! [String : Any] else {
                        self.registerError(message: "Não foi possível finalizar o cadastro. Por favor, tente novamente mais tarde.")
                        return
                    }
                    if json["success"] as? Bool == false {
                        self.registerError(message: json["message"] as? String ?? "Não foi possível finalizar o cadastro. Por favor, tente novamente mais tarde.")
                        return
                    }
                    print(json)
                    print("Erro desconhecido ao tentar mapear resultados: \(error.localizedDescription)")
                }
            case .failure:
                self.registerError(message: "Não foi possível finalizar o cadastro. Por favor, tente novamente mais tarde.")
                print("Erro ao obter dados: \(result.error.debugDescription)")
            }
        }
    }
    
    // Firebase error code
    private func firebaseRegisterErrorCode(_ error: NSError) -> String {
        switch error.code {
        case AuthErrorCode.weakPassword.rawValue:
            return "Senha muito fraca. Informe uma senha mais segura."
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return "E-mail já possui cadastro. Caso tenha esquecido a sua senha, você pode resetá-la através da tela de Login."
        case AuthErrorCode.invalidEmail.rawValue:
            return "O e-mail informado não é uma e-mail válido."
        case AuthErrorCode.missingEmail.rawValue:
            return "E-mail não informado."
        default:
            return "Não foi possível finalizar o cadastro. Por favor, tente novamente mais tarde."
        }
    }
}

extension RegisterViewModel: RegisterViewModelDelegate {
    func sendCredentials(data: RegisterModel) {
        // Maybe separete this logic in another function ou class?
        if data.name.isEmpty == true {
            registerError(message: "Informe o seu nome.")
            return
        }
        if data.email.isEmpty == true {
            registerError(message: "Informe o email.")
            return
        }
        if !data.email.contains(".") || !data.email.contains("@") {
            registerError(message: "E-mail inválido.")
        }
        if data.emailConfirmation.isEmpty == true {
            registerError(message: "Informe a confirmação do e-mail.")
            return
        }
        if data.email != data.emailConfirmation {
            registerError(message: "Os emails informados não coincidem.")
            return
        }
        if data.password.isEmpty == true {
            registerError(message: "Informe uma senha.")
            return
        }
        if data.passwordConfirmation.isEmpty == true {
            registerError(message: "Informe a confirmação da senha.")
            return
        }
        if data.password != data.passwordConfirmation {
            registerError(message: "As senhas informadas não coincidem.")
            return
        }
        registerFirebase(registerData: data)
    }
    
    func registerSuccess() {
        viewModelDelegate?.registerSuccess()
    }
    
    func registerError(message: String) {
        viewModelDelegate?.registerError(message: message)
    }
}

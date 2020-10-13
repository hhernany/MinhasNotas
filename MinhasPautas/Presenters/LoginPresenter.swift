//
//  LoginPresenter.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 30/04/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import Moya
import Firebase

// Add ": class"  if change struct by class
protocol LoginPresenterProtocol {
    func sendCredentials(email: String, password: String)
}

struct LoginPresenter {
    
    // weak var is not necessary. Because we are using Struct instead of Class.
    // If using class instead struct, change for weak var because of reference cycles.
    var presenterDelegate: LoginViewControlerProtocol?
    var validator = LoginValidator()
    var webService: LoginWebserviceProtocol?
    var firebaseValidator = FirebaseErrorCodeValidator()

    // Dependency Injection
    init(delegate: LoginViewControlerProtocol?,
         webservice: LoginWebserviceProtocol = LoginWebService()) {
        presenterDelegate = delegate
        webService = webservice
        
        self.logoutUserFirebase()
        self.removeLocalData()
    }
    
    // Logout user on Firebase when LoginVC are presented.
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
}

extension LoginPresenter: LoginPresenterProtocol {
    func sendCredentials(email: String, password: String) {
        let returnValidation = validator.validateData(email: email, password: password)
        if returnValidation.0 == false {
            presenterDelegate?.loginError(message: returnValidation.1)
            return
        }
        
        webService?.loginFirebase(email: email, password: password, completionHandler: { (resultData, error) in
            if error != nil {
                let err = error! as NSError
                self.presenterDelegate?.loginError(message: err.domain)
            } else {
                self.webService?.performLogin(resultData!, completionHandler: { (loginModel, resultModel, error) in
                    if loginModel == nil && resultModel == nil {
                        self.presenterDelegate?.loginError(message: error?.localizedDescription ?? "Erro desconhecido durante o login. Tente novamente.")
                        return
                    }
                    if resultModel?.success == false && loginModel == nil {
                        self.presenterDelegate?.loginError(message: resultModel?.message ?? "Erro desconhecido durante o login. Tente novamente.")
                        return
                    }
                    
                    self.saveLocalData(data: loginModel!)
                    self.presenterDelegate?.loginSuccess()
                })
            }
        })
    }
}


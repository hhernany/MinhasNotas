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
protocol RegisterViewModelProtocol {
    func sendCredentials(data: RegisterModel)
}

struct RegisterViewModel {
    // weak var is not necessary. Because we are using Struct instead of Class.
    // If using class instead struct, change for weak var because of reference cycles.
    var viewModelDelegate: RegisterViewControlerProtocol?
    var webService: RegisterWebServiceProtocol!
    var validator = RegisterValidator()
    
    // Dependency Injection
    init(delegate: RegisterViewControlerProtocol?,
         webserrvice: RegisterWebServiceProtocol = RegisterWebService()) {
        viewModelDelegate = delegate
        webService = webserrvice
    }
}

extension RegisterViewModel: RegisterViewModelProtocol {
    func sendCredentials(data: RegisterModel) {
        let resultValidation = validator.validateModel(data: data)
        if resultValidation != nil {
            viewModelDelegate?.registerError(message: resultValidation?.localizedDescription ?? "Erro desconhecido. Tente novamente mais tarde.")
            return
        }

        webService.registerFirebase(registerData: data) { (result, error) in
            if error != nil {
                let err = error! as NSError
                self.viewModelDelegate?.registerError(message: err.domain)
            } else {
                self.webService.registerDatabase(result!) { (loginResult, defaultResult, error) in
                    if loginResult == nil && defaultResult == nil {
                        self.viewModelDelegate?.registerError(message: error?.localizedDescription ?? "")
                        return
                    }
                    
                    if defaultResult?.success == false {
                        self.viewModelDelegate?.registerError(message: defaultResult?.message ?? "")
                    } else {
                        self.viewModelDelegate?.registerSuccess()
                    }
                }
            }
        }
    }
}

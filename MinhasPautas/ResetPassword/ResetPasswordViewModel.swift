//
//  ResetPasswordViewModel.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 01/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import Firebase

// Add ": class"  if change struct by class
protocol ResetPasswordViewModelDelegate {
    func sendCredentials(email: String)
    func resetSucess()
    func resetError(message: String)
}

struct ResetPasswordViewModel {
    
    // weak var is not necessary. Because we are using Struct instead of Class.
    // If using class instead struct, change for weak var because of reference cycles.
    var viewModelDelegate: ResetPasswordViewControlerDelegate?
    
    // Dependency Injection
    init(delegate: ResetPasswordViewControlerDelegate?) {
        viewModelDelegate = delegate
    }
    
    // Firebase reset password
    private func resetPassword(email: String) {
        Auth.auth().languageCode = "pt-BR" // Setar o idioma do e-mail
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            guard error == nil else {
                if let err = error as NSError? {
                    self.resetError(message: self.firebaseRegisterErrorCode(err))
                }
                return
            }
            self.resetSucess()
        }
    }
    
    // Firebase error code
    private func firebaseRegisterErrorCode(_ error: NSError) -> String {
        switch error.code {
        case AuthErrorCode.userNotFound.rawValue:
            return "E-mail informado não cadastrado. Confira os dados informados e tente novamente."
        case AuthErrorCode.userNotFound.rawValue:
            return "Usuário não encontrado. Confira os dados informados e tente novamente."
        case AuthErrorCode.networkError.rawValue:
            return "Houve um erro com a conexão da internet. Por favor, tente novamente."
        default:
            return "Não foi possível processar a sua solicitação, por favor, tente novamente mais tarde."
        }
    }
}

extension ResetPasswordViewModel: ResetPasswordViewModelDelegate {
    func sendCredentials(email: String) {
        if email.isEmpty == true {
            resetError(message: "Informe o email.")
            return
        }
        resetPassword(email: email)
    }
    
    func resetSucess() {
        viewModelDelegate?.resetSuccess()
    }
    
    func resetError(message: String) {
        viewModelDelegate?.resetError(message: message)
    }
}


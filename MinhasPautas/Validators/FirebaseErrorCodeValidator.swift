//
//  FirebaseErrorCodeValidator.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 03/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import Firebase

class FirebaseErrorCodeValidator {
    func firebaseRegisterErrorCode(_ error: NSError) -> String {
        switch error.code {
        case AuthErrorCode.weakPassword.rawValue:
            return "Senha muito fraca. Informe uma senha mais segura."
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return "E-mail já possui cadastro. Caso tenha esquecido a sua senha, você pode resetá-la através da tela de Login."
        case AuthErrorCode.invalidEmail.rawValue:
            return "O e-mail informado não é um e-mail válido."
        case AuthErrorCode.missingEmail.rawValue:
            return "E-mail não informado."
        case AuthErrorCode.userNotFound.rawValue:
            return "Usuário não encontrado. Confira os dados informados e tente novamente."
        case AuthErrorCode.networkError.rawValue:
            return "Houve um erro com a conexão da internet. Por favor, tente novamente."
        default:
            return "Não foi possível finalizar o cadastro. Por favor, tente novamente mais tarde."
        }
    }
}

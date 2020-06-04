//
//  RegisterViewModelValidator.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 03/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation

class RegisterViewModelValidator {
    func validateModel(data: RegisterModel) -> RegisterError? {
        if data.name.isEmpty == true {
            return RegisterError.errorName(description: "Informe o seu nome.")
        }
        if data.email.isEmpty == true {
            return RegisterError.errorEmail(description: "Informe o email.")
        }
        if !data.email.contains(".") || !data.email.contains("@") {
            return RegisterError.errorEmail(description: "E-mail inválido.")
        }
        if data.emailConfirmation.isEmpty == true {
            return RegisterError.errorEmail(description: "Informe a confirmação do e-mail.")
        }
        if data.email != data.emailConfirmation {
            return RegisterError.errorEmail(description: "Os emails informados não coincidem.")
        }
        if data.password.isEmpty == true {
            return RegisterError.errorPassword(description: "Informe uma senha.")
        }
        if data.passwordConfirmation.isEmpty == true {
            return RegisterError.errorPassword(description: "Informe a confirmação da senha.")
        }
        if data.password != data.passwordConfirmation {
            return RegisterError.errorPassword(description: "As senhas informadas não coincidem.")
        }
        return nil
    }
}

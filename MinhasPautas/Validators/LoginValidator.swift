//
//  LoginValidator.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 04/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation

class LoginValidator {
    func validateData(email: String, password: String) -> (Bool, String) {
        if email.isEmpty {
            return(false, "Informe o e-mail de acesso.")
        }
        if !email.contains(".") || !email.contains("@") {
            return(false, "E-mail inválido.")
        }
        if password.isEmpty {
            return(false, "Informe a senha de acesso.")
        }
        return(true, "")
    }
}

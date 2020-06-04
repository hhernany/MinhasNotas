//
//  ResetPasswordValidator.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 03/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import Firebase

class ResetPasswordValidator {
    func isEmailValid(email: String) -> (Bool, String) {
        if email.isEmpty == true {
            return (false, "Informe o e-mail")
        }
        if !email.contains(".") || !email.contains("@") {
            return (false, "E-mail inválido.")
        }
        return (true, "")
    }
}

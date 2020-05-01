//
//  LoginModel.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 30/04/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation

struct LoginModel: Codable {
    let success: Bool
    let message: String
    let token_jwt: String
    
    struct User: Codable {
        let id_usuario: Int
        let nome: String
        let sobrenome: String?
        let email: String
        let receber_notificacao: String
        let foto: String?
    }
    
    let user: [User]
}

//
//  ResetPasswordFirebaseService.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 03/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import Firebase

protocol ResetPasswordFirebaseProtocol {
    func resetPassword(email: String, completionHandler: @escaping (Bool, NSError?) -> Void)
}

class ResetPasswordFirebaseService: ResetPasswordFirebaseProtocol {
    func resetPassword(email: String, completionHandler: @escaping (Bool, NSError?) -> Void) {
        Auth.auth().languageCode = "pt-BR" // Setar o idioma do e-mail
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            guard error == nil else {
                if let err = error as NSError? {
                    completionHandler(false, err)
                    return
                }
                completionHandler(false, NSError(domain: "Unknow error", code: 500))
                return
            }
            completionHandler(true, nil)
        }
    }
}

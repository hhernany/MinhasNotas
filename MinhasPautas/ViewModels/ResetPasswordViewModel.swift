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
}

struct ResetPasswordViewModel {
    
    // weak var is not necessary. Because we are using Struct instead of Class.
    // If using class instead struct, change for weak var because of reference cycles.
    var viewDelegate: ResetPasswordViewControlerDelegate?
    var validator = ResetPasswordValidator()
    var firebaserService: ResetPasswordFirebaseProtocol!
    
    // Dependency Injection
    init(delegate: ResetPasswordViewControlerDelegate?,
         firebaseService: ResetPasswordFirebaseProtocol = ResetPasswordFirebaseService()) {
        viewDelegate = delegate
        self.firebaserService = firebaseService
    }
}

extension ResetPasswordViewModel: ResetPasswordViewModelDelegate {
    func sendCredentials(email: String) {
        let resultValidation = validator.isEmailValid(email: email)
        if resultValidation.0 == false {
            self.viewDelegate?.resetError(message: resultValidation.1)
            return
        }
        
        print(firebaserService)
        firebaserService?.resetPassword(email: email, completionHandler: { (success, error) in
            if success && error == nil{
                self.viewDelegate?.resetSuccess()
            } else {
                self.viewDelegate?.resetError(message: self.validator.firebaseRegisterErrorCode(error!))
            }
        })
    }
}


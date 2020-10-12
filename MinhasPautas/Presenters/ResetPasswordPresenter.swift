//
//  ResetPasswordPresenter.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 01/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import Firebase

// Add ": class"  if change struct by class
protocol ResetPasswordPresenterProtocol {
    func sendCredentials(email: String)
}

struct ResetPasswordPresenter {
    // weak var is not necessary. Because we are using Struct instead of Class.
    // If using class instead struct, change for weak var because of reference cycles.
    var viewDelegate: ResetPasswordViewControlerProtocol?
    var validator = ResetPasswordValidator()
    var firebaseValidator = FirebaseErrorCodeValidator()
    var firebaserService: ResetPasswordFirebaseProtocol!
    
    // Dependency Injection
    init(delegate: ResetPasswordViewControlerProtocol?,
         firebaseService: ResetPasswordFirebaseProtocol = ResetPasswordFirebaseService()) {
        viewDelegate = delegate
        self.firebaserService = firebaseService
    }
}

extension ResetPasswordPresenter: ResetPasswordPresenterProtocol {
    func sendCredentials(email: String) {
        let resultValidation = validator.isEmailValid(email: email)
        if resultValidation.0 == false {
            self.viewDelegate?.resetError(message: resultValidation.1)
            return
        }
        
        firebaserService?.resetPassword(email: email, completionHandler: { (success, error) in
            if success && error == nil{
                self.viewDelegate?.resetSuccess()
            } else {
                self.viewDelegate?.resetError(message: self.firebaseValidator.firebaseRegisterErrorCode(error!))
            }
        })
    }
}


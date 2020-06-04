//
//  MockRegisterWebService.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 04/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import Moya
@testable import MinhasPautas

class MockRegisterWebService: RegisterWebServiceProtocol {
    var shouldReturnFirebaseError = false
    var shouldReturnDatabaseError = false
    var shouldReturnRemoteErrorMessage = false
    
    func registerFirebase(registerData: RegisterModel, completionHandler: @escaping ([String : String]?, NSError?) -> Void) {
        if shouldReturnFirebaseError {
            completionHandler(nil, NSError(domain: "Mock error returned", code: 500))
        } else {
            // Fake data
            let userData: [String:String] = [
                "nome": "registration name",
                "email": "registration email",
                "token_autenticacao": "registration uid"
            ]
            completionHandler(userData, nil)
        }
    }
    
    func registerDatabase(_ userData: [String : String], completionHandler: @escaping (LoginModel?, ResultModel?, MoyaError?) -> Void) {
        if shouldReturnDatabaseError {
            completionHandler(nil, nil, MoyaError.requestMapping("Fake returned error"))
        } else if shouldReturnRemoteErrorMessage {
            let resultErrorMessage = ResultModel(success: false, message: "Message return from webservice")
            completionHandler(nil, resultErrorMessage, nil)
        } else {
            let userModel = LoginModel.User(nome: "First Name", email: "email@email.coms", receber_notificacao: "N")
            let loginModel = LoginModel(success: true, message: "Login succeed", token_jwt: "token_jwt", usuario: userModel)
            completionHandler(loginModel, nil, nil)
        }
    }
}

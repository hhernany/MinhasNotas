//
//  LoginWebService.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 04/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import Firebase
import Moya

protocol LoginWebserviceProtocol {
    func loginFirebase(email: String, password: String, completionHandler: @escaping ([String:String]?, NSError?) -> Void)
    func performLogin(_ userData: [String:String], completionHandler: @escaping (LoginModel?, ResultModel?, MoyaError?) -> Void)
}

class LoginWebService: LoginWebserviceProtocol {
    var provider: MoyaProvider<LoginAPI>
    var firebaseValidator = FirebaseErrorCodeValidator()
    
    init(moyaProvider: MoyaProvider<LoginAPI> = MoyaProvider<LoginAPI>()) {
        provider = moyaProvider
    }
    
    // Firebase login
    func loginFirebase(email: String, password: String, completionHandler: @escaping ([String:String]?, NSError?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard let userData = user?.user else {
                let err = error! as NSError
                let errorMessage = self.firebaseValidator.firebaseRegisterErrorCode(err)
                completionHandler(nil, NSError(domain: errorMessage, code: err.code))
                return
            }
            
            // Data to be sent to the database
            let data: [String:String] = [
                "email": email,
                "token_autenticacao": userData.uid
            ]
            completionHandler(data, nil)
        }
    }
    
    func performLogin(_ userData: [String:String], completionHandler: @escaping (LoginModel?, ResultModel?, MoyaError?) -> Void) {
        provider.request(.login(data: userData)) { result in
            switch result {
            case .success(let response):
                do {
                    let login = try response.map(LoginModel.self)
                    completionHandler(login, nil, nil)
                } catch {
                    // If don't decode with LoginModel, try with ResulModel.
                    let resultLogin = try? JSONDecoder().decode(ResultModel.self, from: response.data)
                    if resultLogin == nil {
                        // TODO: Create custom message to return
                        completionHandler(nil, nil, MoyaError.jsonMapping(response)) // "Não foi possível realizar o login"
                        return
                    }
                    
                    // TODO: Se chegou aqui é porque consegui processar o ResultModel
                    completionHandler(nil, resultLogin, MoyaError.jsonMapping(response))
                }
            case .failure:
                // TODO: Create custom message to return
                completionHandler(nil, nil, result.error)
                //print("Erro ao obter dados: \(result.error.debugDescription)")
            }
        }
    }
}

//
//  RegisterWebService.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 03/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import Firebase
import Moya

protocol RegisterWebServiceProtocol {
    func registerDatabase(_ userData: [String:String], completionHandler: @escaping (LoginModel?, ResultModel?, MoyaError?) -> Void)
    func registerFirebase(registerData: RegisterModel, completionHandler: @escaping ([String:String]?, NSError?) -> Void)
}

class RegisterWebService: RegisterWebServiceProtocol {
    var provider: MoyaProvider<LoginAPI>
    var firebaseValidator = FirebaseErrorCodeValidator()
    
    init(moyaProvider: MoyaProvider<LoginAPI> = MoyaProvider<LoginAPI>()) {
        provider = moyaProvider
    }
    
    // Firebase Register
    func registerFirebase(registerData: RegisterModel, completionHandler: @escaping ([String:String]?, NSError?) -> Void) {
        Auth.auth().createUser(withEmail: registerData.email , password: registerData.password) { (authResult, error) in
            guard let user = authResult?.user else {
                let err = error! as NSError
                let errorMessage = self.firebaseValidator.firebaseRegisterErrorCode(err)
                completionHandler(nil, NSError(domain: errorMessage, code: err.code))
                return
            }

            // Save user in database
            let userData: [String:String] = [
                "nome": registerData.name,
                "email": registerData.email,
                "token_autenticacao": user.uid
            ]
            
            completionHandler(userData, nil)
        }
    }
    
    func registerDatabase(_ userData: [String:String], completionHandler: @escaping (LoginModel?, ResultModel?, MoyaError?) -> Void) {
        provider.request(.register(data: userData)) { result in
            switch result {
            case .success(let response):
                do {
                    let login = try response.map(LoginModel.self)
                    completionHandler(login, nil, nil)
                } catch {
                    // If don't decode with LoginModel, try with ResulModel.
                    let resultLogin = try? JSONDecoder().decode(ResultModel.self, from: response.data)
                    if resultLogin == nil {
                        completionHandler(nil, nil, MoyaError.jsonMapping(response)) // "Não foi possível finalizar o cadastro. Por favor, tente novamente mais tarde."
                        return
                    }

                    // TODO: Se chegou aqui é um erro desconhecido. Como está vai retornar uma mensagem nada a ver.
                    // Corrigir e também corrigir o teste.
                    completionHandler(nil, resultLogin, MoyaError.jsonMapping(response))
                    //print("Erro desconhecido ao tentar mapear resultados: \(error.localizedDescription)")
                }
            case .failure:
                // TODO: Criar um erro personalizado, não da pra saber qual erro que vem aqui e vai mostrar tudo estranho pro usuário.
                completionHandler(nil, nil, result.error)
                //print("Erro ao obter dados: \(result.error.debugDescription)")
            }
        }
    }
}

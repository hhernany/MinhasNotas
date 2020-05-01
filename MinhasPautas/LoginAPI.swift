//
//  LoginAPI.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 30/04/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import Moya

public enum LoginAPI {
    case login(email: String, password: String)
}

extension LoginAPI: TargetType {
    
    public var baseURL: URL {
        return Network.URLS.baseURL
    }
    
    public var path: String {
        switch self {
        case .login:
            return "login"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .login(let email, let password):
            // Aqui tem que ver como que faz um POST
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return Network.Headers.contentTypeWithAuthJSON
    }
}

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
    case login(data: [String:String])
    case register(data: [String:String])
}

extension LoginAPI: TargetType {
    
    public var baseURL: URL {
        return Network.URLS.baseURL
    }
    
    public var path: String {
        switch self {
        case .login:
            return "login"
        case .register:
            return "register"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .login, .register:
            return .post
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .login(let data), .register(let data):
            return .requestParameters(parameters: data, encoding: JSONEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return Network.Headers.contentTypeWithAuthJSON
    }
}

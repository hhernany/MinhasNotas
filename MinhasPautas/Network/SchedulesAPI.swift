//
//  SchedulesAPI.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 01/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import Moya

public enum SchedulesAPI {
    case getData(page: Int)
    case create(data: [String:String]) // Todos os dados de inclusão
    case update(data: [String:String]) // Codigo da pauta e o novo status
}

extension SchedulesAPI: TargetType {
    
    public var baseURL: URL {
        return Network.URLS.baseURL
    }
    
    public var path: String {
        switch self {
        case .getData:
            return "pautas/listar"
        case .create:
            return "pautas/incluir"
        case .update:
            return "patuas/status"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getData:
            return .get
        case .create:
            return .post
        case .update:
            return .put
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .getData(let page):
            return .requestParameters(parameters: ["pagina": page], encoding: URLEncoding.queryString)
        case .create(let data), .update(let data):
            return .requestParameters(parameters: data, encoding: JSONEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return Network.Headers.contentTypeWithAuthJSON
    }
}

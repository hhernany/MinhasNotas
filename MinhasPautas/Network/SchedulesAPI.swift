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
    case update(data: [String:Any]) // Codigo da pauta e o novo status
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
            return "pautas/status"
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
        switch self {
        case .getData( _):
            return stubbedResponse("Schedules")
        case .update( _):
            return stubbedResponse("UpdateScheduleReturn")
        case .create( _):
            return stubbedResponse("CreateScheduleReturn")
        default:
            return Data()
        }
    }
    
    public var task: Task {
        switch self {
        case .getData(let page):
            return .requestParameters(parameters: ["pagina": page], encoding: URLEncoding.queryString)
        case .create(let data):
            return .requestParameters(parameters: data, encoding: JSONEncoding.default)
        case .update(let data):
            return .requestParameters(parameters: data, encoding: JSONEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        var header = Network.Headers.contentTypeWithAuthJSON
        header["x-auth-token"] = UserDefaults.standard.object(forKey: "token_jwt") as? String ?? ""
        return header
    }
}

// MARK: - Provider Support
func stubbedResponse(_ filename: String) -> Data! {
    @objc class TestClass: NSObject { }
    
    let bundle = Bundle(for: TestClass.self)
    let path = bundle.path(forResource: filename, ofType: "json")
    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
}

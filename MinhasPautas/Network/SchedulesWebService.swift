//
//  SchedulesWebService.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 05/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import Moya

protocol SchedulesWebServiceProtocol {
    func getData(page: Int, completionHandler: @escaping ([SchedulesModel]?, ResultModel?, MoyaError?) -> Void)
    func updateStatus(data: [String:Any], completionHandler: @escaping (ResultModel?, Error?) -> Void)
}

class SchedulesWebService: SchedulesWebServiceProtocol {
    var provider: MoyaProvider<SchedulesAPI>
    
    init(moyaProvider: MoyaProvider<SchedulesAPI> = MoyaProvider<SchedulesAPI>()) {
         let isTesting = AppDelegate.isUITestingEnabled
         if isTesting {
             provider = MoyaProvider<SchedulesAPI>(stubClosure: MoyaProvider.immediatelyStub)
         } else {
             provider = moyaProvider
         }
    }
    
//    func setMoyaProvider() {
//        let isTesting = AppDelegate.isUITestingEnabled
//        if isTesting {
//            provider = MoyaProvider<SchedulesAPI>(stubClosure: MoyaProvider.immediatelyStub)
//        } else {
//            provider = MoyaProvider<SchedulesAPI>()
//        }
//    }
    
    func getData(page: Int, completionHandler: @escaping ([SchedulesModel]?, ResultModel?, MoyaError?) -> Void) {
        provider.request(.getData(page: page)) { result in
            switch result {
            case .success(let response):
                do {
                    let schedulesList = try response.map(SchedulesResults<SchedulesModel>.self).items
                    completionHandler(schedulesList, nil, nil)
                } catch {
                    // If don't decode with LoginModel, try with ResulModel.
                    let resultSchedules = try? JSONDecoder().decode(ResultModel.self, from: response.data)
                    if resultSchedules == nil {
                        //print("Erro ao mapear resultados: \(error.localizedDescription)")
                        // TODO: Create custom message to return
                        completionHandler(nil, nil, MoyaError.jsonMapping(response))
                        return
                    }
                    completionHandler(nil, resultSchedules, MoyaError.jsonMapping(response))
                }
            case .failure:
                // TODO: Create custom message to return
                completionHandler(nil, nil, result.error)
                print("Erro ao obter dados: \(result.error.debugDescription)")
            }
        }
    }

    func updateStatus(data: [String:Any], completionHandler: @escaping (ResultModel?, Error?) -> Void) {
        provider.request(.update(data: data)) { result in
            switch result {
            case .success(let response):
                let resultUpdate = try? JSONDecoder().decode(ResultModel.self, from: response.data)
                completionHandler(resultUpdate, nil)
            case .failure:
                completionHandler(nil, NSError(domain: "Não foi possível atualizar o status.", code: 500))
                print("Erro ao obter dados: \(result.error.debugDescription)")
            }
        }
    }
}

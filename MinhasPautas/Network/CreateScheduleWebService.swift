//
//  CreateScheduleWebService.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 29/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import Moya

protocol CreateScheduleWebServiceProtocol {
    func insertSchedule(_ scheduleData: [String:String], completionHandler: @escaping (ResultModel?, MoyaError?) -> Void)
}

class CreateScheduleWebService: CreateScheduleWebServiceProtocol {
    var provider: MoyaProvider<SchedulesAPI>
    
    init(moyaProvider: MoyaProvider<SchedulesAPI> = MoyaProvider<SchedulesAPI>()) {
        provider = moyaProvider
    }
    
    func insertSchedule(_ scheduleData: [String:String], completionHandler: @escaping (ResultModel?, MoyaError?) -> Void) {
        provider.request(.create(data: scheduleData)) { result in
            switch result {
            case .success(let response):
                do {
                    let resultModel = try response.map(ResultModel.self)
                    completionHandler(resultModel, nil)
                } catch {
                    // TODO: Create custom message to return
                    completionHandler(nil, MoyaError.jsonMapping(response))
                    //print("Erro desconhecido ao tentar mapear resultados (inclusao de pauta): \(error.localizedDescription)")
                }
            case .failure( _):
                // TODO: Create custom message to return
                //print("Erro ao incluir a pauta: \(result.error.debugDescription)")
                completionHandler(nil, result.error)
            }
        }
    }
}

//
//  MockSchedulesWebService.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 05/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import Moya
@testable import MinhasPautas

class MockSchedulesWebService: SchedulesWebServiceProtocol {
    var getDataReturnSuccess = false
    var getDataReturnResultErrorMessage = false
    var getDataRemoteErrorMessage = false
    
    var updateDataReturnSuccess = false
    var updateDataReturnError = false
    var updateDataRemoteErrorMessage = false
    
    func getData(page: Int, completionHandler: @escaping ([SchedulesModel]?, ResultModel?, MoyaError?) -> Void) {
        if getDataReturnResultErrorMessage {
            let resultErrorMessage = ResultModel(success: false, message: "Message return from webservice")
            completionHandler(nil, resultErrorMessage, nil)
        } else if getDataRemoteErrorMessage {
            completionHandler(nil, nil, MoyaError.requestMapping("Fake returned error"))
        } else {
            // TODO: Colocar para retornar uma pauta
            let model = SchedulesModel(id_pauta: 1,
                                       titulo: "Title",
                                       descricao: "description",
                                       detalhes: "details",
                                       nome_usuario: "userName",
                                       status: "Aberto",
                                       expanded: false)
            completionHandler([model], nil, nil)
        }
    }
    
    func updateStatus(data: [String : Any], completionHandler: @escaping (ResultModel?, Error?) -> Void) {
        if updateDataReturnError {
            let resultErrorMessage = ResultModel(success: false, message: "Message return from webservice")
            completionHandler(resultErrorMessage, nil)
        } else if updateDataRemoteErrorMessage {
            completionHandler(nil, MoyaError.requestMapping("Fake returned error"))
        } else {
            let resultErrorMessage = ResultModel(success: true, message: "Message return from webservice")
            completionHandler(resultErrorMessage, nil)
        }
    }
}

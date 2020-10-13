//
//  CreateSchedulePresenter.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 02/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import Moya

// Add ": class"  if change struct by class
protocol CreateSchedulePresenterProtocol {
    init(delegate: CreateScheduleViewControllerProtocol?, webservice: CreateScheduleWebServiceProtocol)
    func sendFormData(formData: CreateScheduleModel)
}

struct CreateSchedulePresenter {
    // weak var is not necessary. Because we are using Struct instead of Class.
    // If using class instead struct, change for weak var because of reference cycles.
    var presenterDelegate: CreateScheduleViewControllerProtocol?
    var webService: CreateScheduleWebServiceProtocol?
    let validator = CreateScheduleValidator()
    
    // Dependency Injection
    init(delegate: CreateScheduleViewControllerProtocol?, webservice: CreateScheduleWebServiceProtocol) {
        presenterDelegate = delegate
        webService = webservice
    }
}

extension CreateSchedulePresenter: CreateSchedulePresenterProtocol {
    func sendFormData(formData: CreateScheduleModel) {
        let validationError = validator.validateScheduleModel(formData: formData)
        if validationError != nil {
            presenterDelegate?.createError(message: validationError?.localizedDescription ?? "Erro desconhecido. Tente novamente mais tarde.")
            return
        }

        // Form data to sending via POST
        let postData: [String:String] = [
            "titulo": formData.titulo,
            "descricao": formData.descricao,
            "detalhes": formData.detalhes
        ]
        
        webService?.insertSchedule(postData) { (result, error) in
            if error == nil && result?.success == true {
                self.presenterDelegate?.createSuccess()
            } else {
                self.presenterDelegate?.createError(message: error?.errorDescription ?? "Erro desconhecido. Tente novamente mais tarde.")
            }
        }
    }
}


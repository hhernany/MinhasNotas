//
//  CreateScheduleViewModel.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 02/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import Moya

// Add ": class"  if change struct by class
protocol CreateScheduleViewModelDelegate {
    init(delegate: CreateScheduleViewControllerDelegate?, webservice: CreateScheduleWebServiceProtocol)
    func sendFormData(formData: CreateScheduleModel)
}

struct CreateScheduleViewModel {
    // weak var is not necessary. Because we are using Struct instead of Class.
    // If using class instead struct, change for weak var because of reference cycles.
    var viewModelDelegate: CreateScheduleViewControllerDelegate?
    var webService: CreateScheduleWebServiceProtocol?
    let validator = CreateScheduleModelValidator()
    
    // Dependency Injection
    init(delegate: CreateScheduleViewControllerDelegate?, webservice: CreateScheduleWebServiceProtocol) {
        viewModelDelegate = delegate
        webService = webservice
    }
}

extension CreateScheduleViewModel: CreateScheduleViewModelDelegate {
    func sendFormData(formData: CreateScheduleModel) {
        let validationError = validator.validateScheduleModel(formData: formData)
        if validationError != nil {
            viewModelDelegate?.createError(message: validationError?.localizedDescription ?? "Erro desconhecido. Tente novamente mais tarde.")
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
                self.viewModelDelegate?.createSuccess()
            } else {
                self.viewModelDelegate?.createError(message: error?.errorDescription ?? "Erro desconhecido. Tente novamente mais tarde.")
            }
        }
    }
}


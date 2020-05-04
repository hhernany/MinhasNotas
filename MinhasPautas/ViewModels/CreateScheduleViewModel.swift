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
    func sendFormData(formData: CreateScheduleModel)
    func createSuccess()
    func createError(message: String)
}

struct CreateScheduleViewModel {
    
    // weak var is not necessary. Because we are using Struct instead of Class.
    // If using class instead struct, change for weak var because of reference cycles.
    var viewModelDelegate: CreateScheduleViewControllerDelegate?
    fileprivate let provider = MoyaProvider<SchedulesAPI>()
    
    // Dependency Injection
    init(delegate: CreateScheduleViewControllerDelegate?) {
        viewModelDelegate = delegate
    }
    
    private func insertSchedule(_ scheduleData: [String:String]) {
        provider.request(.create(data: scheduleData)) { result in
            switch result {
            case .success(let response):
                do {
                    let result = try response.map(ResultModel.self)
                    if result.success == false {
                        self.createError(message: result.message)
                        return
                    }
                    self.createSuccess()
                } catch {
                    self.createError(message: "Não foi possível incluir a pauta. Por favor, tente novamente mais tarde.")
                    print("Erro desconhecido ao tentar mapear resultados (inclusao de pauta): \(error.localizedDescription)")
                }
            case .failure:
                self.createError(message: "Não foi possível incluir a pauta. Por favor, tente novamente mais tarde.")
                print("Erro ao incluir a pauta: \(result.error.debugDescription)")
            }
        }
    }
}

extension CreateScheduleViewModel: CreateScheduleViewModelDelegate {
    func createSuccess() {
        viewModelDelegate?.createSuccess()
    }
    
    func createError(message: String) {
        viewModelDelegate?.createError(message: message)
    }
    
    func sendFormData(formData: CreateScheduleModel) {
        if formData.titulo.isEmpty {
            createError(message: "Informe o titulo da pauta.")
            return
        }
        if formData.descricao.isEmpty {
            createError(message: "Informe a descrição da pauta.")
            return
        }
        if formData.detalhes.isEmpty {
            createError(message: "Informe os datalhes da pauta.")
            return
        }
        
        // POST DATA
        let postData: [String:String] = [
            "titulo": formData.titulo,
            "descricao": formData.descricao,
            "detalhes": formData.detalhes
        ]
        insertSchedule(postData)
    }
}


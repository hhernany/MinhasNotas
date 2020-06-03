//
//  CreateScheduleModelValidator.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 29/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation

class CreateScheduleModelValidator {
    func validateScheduleModel(formData: CreateScheduleModel) -> CreateScheduleError? {
        if formData.titulo.isEmpty {
            return CreateScheduleError.errorTitle(description: "Informe o titulo da pauta.")
        }
        if formData.descricao.isEmpty {
            return CreateScheduleError.errorDescription(description: "Informe a descrição da pauta.")
        }
        if formData.detalhes.isEmpty {
            return CreateScheduleError.errorDetail(description: "Informe a descrição da pauta.")
        }
        return nil
    }
}

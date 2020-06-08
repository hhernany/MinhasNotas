//
//  CreateScheduleError.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 29/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation

enum CreateScheduleError: LocalizedError, Equatable {
    case errorTitle(description: String)
    case errorDescription(description: String)
    case errorDetail(description: String)
    case unknowError
    
    // Faz parte do protocolo LocalizedError. Essa variável é usada para determinar uma mensagem de error para cada erro.
    // Esse protocolo é usado para capturar o localized description de um erro. Anteriormente aqui usava somente o Error. Porém a mensagem do error,
    // é diferente do localized.
    var errorDescription: String? {
        switch self {
        case .errorTitle (let description),
             .errorDescription (let description),
             .errorDetail (let description):
            return description
        case .unknowError:
            return ""
        }
    }
}

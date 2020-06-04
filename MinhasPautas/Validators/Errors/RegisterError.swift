//
//  RegisterError.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 03/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation

enum RegisterError: LocalizedError, Equatable {
    case errorName(description: String)
    case errorEmail(description: String)
    case errorPassword(description: String)
    case unknowError
    
    var errorDescription: String? {
        switch self {
        case .errorName (let description),
             .errorEmail (let description),
             .errorPassword (let description):
            return description
        case .unknowError:
            return ""
        }
    }
}

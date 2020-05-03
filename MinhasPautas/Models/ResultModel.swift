//
//  ResultModel.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 02/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation

// Default JSON Result
struct ResultModel: Codable {
    let success: Bool
    let message: String
}

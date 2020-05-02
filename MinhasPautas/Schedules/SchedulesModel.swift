//
//  SchedulesModel.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 01/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation

struct SchedulesResults<T: Codable>: Codable {
    let items: [T]
}

struct SchedulesModel: Codable {
    let id_pauta: Int
    let titulo: String
    let descricao: String
    let nome_usuario: String
    var status: String
    var expanded: Bool = false

    // Only fields that will be decode/encode
    enum CodingKeys: String, CodingKey {
        case id_pauta, titulo, descricao, nome_usuario, status
    }
    
    mutating func updateStatus(_ status: String) {
        self.status = status
    }
    
    mutating func expandedCell(_ status: Bool) {
        self.expanded = status
    }
}

//
//  StringExt.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 01/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func alert(_ vc: UIViewController, title: String = "Aviso", handler: ((UIAlertAction) -> Void)? = nil) {
        DispatchQueue.main.async {
            // Cria um botão com o título e mensagem que se deseja.
            let alerta = UIAlertController.init(title: title, message: self, preferredStyle: .alert)
            // Cria o botão com a ação de fechar a mensagem de alerta apresentada.
            alerta.addAction(UIAlertAction(title: "Fechar", style: .default, handler: handler))
            // Apresenta o alerta definido acima, com animação.
            vc.present(alerta, animated: true, completion: nil)
        }
    }
}

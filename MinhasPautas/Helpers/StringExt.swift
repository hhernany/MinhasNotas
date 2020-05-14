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
            let alerta = UIAlertController.init(title: title, message: self, preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Fechar", style: .default, handler: handler))
            vc.present(alerta, animated: true, completion: nil)
        }
    }
    
    func boolValue() -> Bool {
        return (self as NSString).boolValue
    }
    
    func truncateKey() -> String {
        if let range = self.range(of: "FakeData_") {
            let key = self[range.upperBound...]
            return String(key)
        }
        return self
    }
}

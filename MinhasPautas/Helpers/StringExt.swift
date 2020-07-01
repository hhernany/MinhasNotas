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
    /// Create alert from a string
    ///
    /// - Author: Hugo Hernany
    ///
    /// - Returns: Show UIAlert from String
    ///
    /// - Parameters:
    ///     - vc: viewController who will present alert
    ///     - title: Optional alert title (If not informed, the title will be "Aviso")
    ///     - handler: Optional handler UIAlertAction.
    ///
    ///  - Note:[Reference](https://stackoverflow.com)
    ///
    ///  - Important: Simple use: "Alert Text".alert()
    ///
    ///  - Version: 0.1
    func alert(_ vc: UIViewController, title: String = "Aviso", handler: ((UIAlertAction) -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController.init(title: title, message: self, preferredStyle: .alert)
            alert.view.accessibilityIdentifier = "informationAlertDialog"
            alert.addAction(UIAlertAction(title: "Fechar", style: .default, handler: handler))
            vc.present(alert, animated: true, completion: nil)
        }
    }

    /// Return boolean when convertible
    ///
    /// - Author: Hugo Hernany
    ///
    /// - Returns: Return true or false when convertible
    ///
    ///  - Note:[Reference](https://stackoverflow.com)
    ///
    ///  - Important: Simple use: "true".boolValue()
    ///
    ///  - Version: 0.1
    func boolValue() -> Bool {
        return (self as NSString).boolValue
    }
    
    /// Truncate key from informed key
    ///
    /// - Returns: Show UIAlert from String
    ///
    /// - Parameters:
    ///     - key: key to truncate
    ///
    ///  - Version: 0.1
    func truncateKey(key: String) -> String {
        if let range = self.range(of: key) {
            let key = self[range.upperBound...]
            return String(key)
        }
        return self
    }
}

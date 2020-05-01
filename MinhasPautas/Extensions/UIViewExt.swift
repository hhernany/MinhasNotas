//
//  UIViewExt.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 01/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    func showSpinner() -> UIView {
        let spinnerView = UIView.init(frame: self.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        let ai = UIActivityIndicatorView.init(style: .white)
        ai.startAnimating()
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            self.addSubview(spinnerView)
            ai.translatesAutoresizingMaskIntoConstraints = false
            ai.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            ai.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            
            ai.layoutIfNeeded()
            ai.updateConstraintsIfNeeded()
            
            self.layoutIfNeeded()
            ai.updateConstraintsIfNeeded()
        }
        
        return spinnerView
    }
    
    func showSpinnerGray() -> UIView {
        let spinnerView = UIView.init(frame: self.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        let ai = UIActivityIndicatorView.init(style: .gray)
        ai.startAnimating()
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            self.addSubview(spinnerView)
            ai.translatesAutoresizingMaskIntoConstraints = false
            ai.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            ai.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            
            ai.layoutIfNeeded()
            ai.updateConstraintsIfNeeded()
            
            self.layoutIfNeeded()
            ai.updateConstraintsIfNeeded()
        }
        
        return spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.removeFromSuperview()
        }
    }
}

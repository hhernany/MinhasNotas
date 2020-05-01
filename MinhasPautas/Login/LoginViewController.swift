//
//  LoginViewController.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 30/04/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import UIKit

protocol LoginViewControlerDelegate: class {
    func loginSuccess()
    func loginError(message: String)
}

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var loginViewModel: LoginViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()

        loginViewModel = LoginViewModel(delegate: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func didTapConnectButton(_ sender: UIButton) {
        guard let _ = loginViewModel else { fatalError("ViewModel not implemented")}
        guard let email = emailTextField.text else {
            "Informe o e-mail de acesso.".alert(self)
            return
        }
        guard let password = passwordTextField.text else {
            "Informe a senha de acesso.".alert(self)
            return
        }
        print("chamando o send Credentials")
        //loginViewModel?.sendCredentials(email: email, password: password)
        loginViewModel?.sendCredentials(email: "hugo@gmail.com", password: "123456")
    }
}

extension LoginViewController: LoginViewControlerDelegate {
    func loginSuccess() {
        "LOGIN FEITO COM SUCESSO - CONFERIR NO BANCO".alert(self)
        // activityIndicator.stopAnimating()
    }
    
    func loginError(message: String) {
        message.alert(self)
        // activityIndicator.stopAnimating()
    }
}

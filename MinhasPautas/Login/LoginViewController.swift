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

    // Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Variables and Constants
    var loginViewModel: LoginViewModel?
    private var spinner: UIView? = nil

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
        spinner = self.view.showSpinnerGray()
        guard let email = emailTextField.text else {
            "Informe o e-mail de acesso.".alert(self)
            return
        }
        guard let password = passwordTextField.text else {
            "Informe a senha de acesso.".alert(self)
            return
        }
        loginViewModel?.sendCredentials(email: email, password: password)
    }
}

extension LoginViewController: LoginViewControlerDelegate {
    func loginSuccess() {
        spinner?.removeSpinner()
        // Chamar a segue pra tela seguinte
        "LOGIN FEITO COM SUCESSO - CONFERIR NO BANCO".alert(self)
        // activityIndicator.stopAnimating()
    }
    
    func loginError(message: String) {
        spinner?.removeSpinner()
        message.alert(self)
    }
}

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
    @IBOutlet weak var connectButton: UIButton!
    
    // Variables and Constants
    var loginViewModel: LoginViewModel?
    private var spinner: UIView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()

        connectButton.layer.cornerRadius = 10
        connectButton.layer.borderWidth = 1
        connectButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        loginViewModel = LoginViewModel(delegate: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func didTapConnectButton(_ sender: UIButton) {
        guard let _ = loginViewModel else { fatalError("ViewModel not implemented")}
        spinner = self.view.showSpinnerGray()
        loginViewModel?.sendCredentials(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
    }
}

extension LoginViewController: LoginViewControlerDelegate {
    func loginSuccess() {
        spinner?.removeSpinner()
        performSegue(withIdentifier: Segue.loginToMain, sender: self)
    }
    
    func loginError(message: String) {
        spinner?.removeSpinner()
        message.alert(self)
    }
}

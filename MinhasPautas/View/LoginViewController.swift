//
//  LoginViewController.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 30/04/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import UIKit

protocol LoginViewControlerProtocol: class {
    func loginSuccess()
    func loginError(message: String)
}

class LoginViewController: UIViewController {

    // Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var bottomStackView: NSLayoutConstraint!
    
    // Variables and Constants
    var loginViewModel: LoginViewModelProtocol?
    private var spinner: UIView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupKeyboard()
        loginViewModel = LoginViewModel(delegate: self)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupLayout() {
        connectButton.layer.cornerRadius = 10
        connectButton.layer.borderWidth = 1
        connectButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    private func setupKeyboard() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardWillHide)))
    }
    
    @objc private func keyboardWillHide(notification:NSNotification){
        self.view.endEditing(true)
    }
    
    @IBAction func didTapForgetPasswordButton(_ sender: UIButton) {
        performSegue(withIdentifier: "forgetPasswordSegue", sender: self)
    }
    
    @IBAction func didTapRegistrationButton(_ sender: UIButton) {
        performSegue(withIdentifier: "registrationSegue", sender: self)
    }
    
    @IBAction func didTapConnectButton(_ sender: UIButton) {
        guard let _ = loginViewModel else { fatalError("ViewModel not implemented")}
        spinner = self.view.showSpinnerGray()
        loginViewModel?.sendCredentials(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
    }
}

extension LoginViewController: LoginViewControlerProtocol {
    func loginSuccess() {
        spinner?.removeSpinner()
        let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbarVC")
        UIApplication.setRootView(rootVC, options: UIApplication.loginAnimation)
    }
    
    func loginError(message: String) {
        spinner?.removeSpinner()
        message.alert(self)
    }
}

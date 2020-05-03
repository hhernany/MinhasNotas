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
    @IBOutlet weak var bottomStackView: NSLayoutConstraint!
    
    // Variables and Constants
    var loginViewModel: LoginViewModel?
    private var spinner: UIView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        // setupKeyboard() // Corrigir
        loginViewModel = LoginViewModel(delegate: self)
    }
    
    private func setupLayout() {
        connectButton.layer.cornerRadius = 10
        connectButton.layer.borderWidth = 1
        connectButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardWillHide)))
    }
    
    @objc private func keyboardWillHide(notification:NSNotification){
        self.view.endEditing(true)
    }
    
    @objc private func keyboardNotification(notification: NSNotification){
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            var height = self.view.frame.height - endFrameY
            if self.view.frame.height - endFrameY == 0 {
                bottomStackView.constant = 10 // Constraint inicial
                self.view.layoutIfNeeded()
                return
            } else {
                height -= 20 // Era 10
            }
            bottomStackView.constant = height
            self.view.layoutIfNeeded()
        }
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

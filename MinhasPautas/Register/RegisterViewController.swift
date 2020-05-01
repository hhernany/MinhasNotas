//
//  RegisterViewController.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 30/04/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import UIKit

protocol RegisterViewControlerDelegate {
    func registerSuccess()
    func registerError(message: String)
}

class RegisterViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var emailConfirmation: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirmation: UITextField!
    
    // Variables and Constants
    var registerViewModel: RegisterViewModel?
    private var spinner: UIView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        registerViewModel = RegisterViewModel(delegate: self)
    }

    @IBAction func didTapCancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapRegisterButton(_ sender: UIButton) {
        guard let _ = registerViewModel else { fatalError("ViewModel not implemented") }
        spinner = self.view.showSpinnerGray()
        let registerData = RegisterModel(
            name: name.text ?? "hugao pelo app",
            email: email.text ?? "hugo2@gmail.com",
            emailConfirmation: emailConfirmation.text ?? "hugo2@gmail.com",
            password: password.text ?? "12345678",
            passwordConfirmation: passwordConfirmation.text ?? "12345678"
            )
        registerViewModel?.sendCredentials(data: registerData)
    }
}

extension RegisterViewController: RegisterViewControlerDelegate {
    func registerSuccess() {
        spinner?.removeSpinner()
        "Seu cadastro foi finalizado com sucesso. Você já pode realizar o login com sua nova conta.".alert(self, title: "Cadastro realizado com sucesso") { UIAlertAction in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func registerError(message: String) {
        spinner?.removeSpinner()
        message.alert(self)
    }
}

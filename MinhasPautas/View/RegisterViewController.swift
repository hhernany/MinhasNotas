//
//  RegisterViewController.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 30/04/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import UIKit

@objc protocol RegisterViewControlerProtocol {
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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    // Variables and Constants
    var registerPresenter: RegisterPresenterProtocol?
    private var spinner: UIView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
        self.setNeedsStatusBarAppearanceUpdate()
        setupObservers()
        registerPresenter = RegisterPresenter(delegate: self)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func keyboardDoneButton(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardWillHide)))
    }
    
    @objc private func keyboardWillShow(notification:NSNotification){
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc private func keyboardWillHide(notification:NSNotification){
        self.view.endEditing(true)
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    @IBAction func didTapCancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapRegisterButton(_ sender: UIButton) {
        guard let _ = registerPresenter else { fatalError("Presenter not implemented") }
        spinner = self.view.showSpinnerGray()
        let registerData = RegisterModel(
            name: name.text ?? "",
            email: email.text ?? "",
            emailConfirmation: emailConfirmation.text ?? "",
            password: password.text ?? "",
            passwordConfirmation: passwordConfirmation.text ?? ""
            )
        registerPresenter?.sendCredentials(data: registerData)
    }
}

extension RegisterViewController: RegisterViewControlerProtocol {
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

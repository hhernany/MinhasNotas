//
//  ResetPasswordViewController.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 30/04/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import UIKit

protocol ResetPasswordViewControlerProtocol {
    func resetSuccess()
    func resetError(message: String)
}

class ResetPasswordViewController: UIViewController {

    // Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var confirmButton: UIButton!
    
    // Variables and Constants
    var resetPasswordViewModel: ResetPasswordViewModelProtocol?
    private var spinner: UIView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        resetPasswordViewModel = ResetPasswordViewModel(delegate: self)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func didTapBackButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func didtapCofirmButton(_ sender: UIButton) {
        guard let _ = resetPasswordViewModel else { fatalError("ViewModel not implemented") }
        spinner = self.view.showSpinnerGray()
        resetPasswordViewModel?.sendCredentials(email: emailTextField.text ?? "")
    }
}

extension ResetPasswordViewController: ResetPasswordViewControlerProtocol {
    func resetSuccess() {
        spinner?.removeSpinner()
        "As instruções para resetar a sua senha foram enviadas para o e-mail informado. Verifique seus e-mails recebidos.".alert(self, title: "E-mail enviado") { (AlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func resetError(message: String) {
        spinner?.removeSpinner()
        message.alert(self)
    }
}

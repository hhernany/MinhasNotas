//
//  LoginViewController.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 30/04/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import UIKit

protocol LoginViewControlerDelegate: class {
    func retrieveData(user: LoginModel.User)
}

class LoginViewController: UIViewController {

    var loginViewModel: LoginViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginViewModel = LoginViewModel(delegate: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginViewController: LoginViewControlerDelegate {
    // Essa função é chamada na hora que clicar no botão de logar
    // Ela chamar a função no viewModel que vai fazer o login.
    // ATENÇÃO - UM EXEMPLO QUE VI, NÃO PRECISA DESSE AQUI SEPARADO. MUDA ESSA FUNÇÃO PARA DENTRO DA AÇÃO DO BOTÃO DE LOGIN.
    func fazerLogin() {
        // Começar a rodar o spinner aqui
        // activityIndicator.startAnimating()
        loginViewModel?.sendCredentials(email: "hugohernany@gmail.com", password: "123456")
    }
    
    // Aqui eu vou receber todos os dados da API após uma login com sucesso.
    // Ai posso preencher a tela por exemplo.
    // Também da para colocar para parar o spinner bem aqui.
    func retrieveData(user: LoginModel.User) {
        // activityIndicator.stopAnimating()
    }
}

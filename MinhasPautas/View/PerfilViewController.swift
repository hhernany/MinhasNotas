//
//  PerfilViewController.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 02/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import UIKit

class PerfilViewController: UIViewController {

    // Outlets
    @IBOutlet weak var nameTextField: UILabel!
    @IBOutlet weak var emailTextField: UILabel!
    
    // Struct
    private enum Perfil: String {
        case logout = "Sair"
    }
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Variables and Contants
    private var optionsList: [Perfil] = [.logout]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillLabels()
        tableView.tableFooterView = UIView() // Remove blank cells
    }
    
    func fillLabels() {
        emailTextField.text = UserDefaults.standard.object(forKey: "email_usuario") as? String ?? ""
        nameTextField.text = UserDefaults.standard.object(forKey: "nome_usuario") as? String ?? ""
    }
}

extension PerfilViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "perfilCell") else {
            fatalError("Invalid dequeueReusableCell - Not Found: perfilCell")
        }
        cell.textLabel?.text = optionsList[indexPath.row].rawValue
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension PerfilViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch optionsList[indexPath.row] {
        case .logout:
            let rootVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
            UIApplication.setRootView(rootVC, options: UIApplication.logoutAnimation)
        }
    }
}


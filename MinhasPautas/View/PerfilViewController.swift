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
        tableView.accessibilityIdentifier = "perfilTableViewOptions"
        tableView.tableFooterView = UIView() // Remove blank cells
        self.setNeedsStatusBarAppearanceUpdate()
        self.configureNavigationBar(largeTitleColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                                    backgoundColor: UIColor.init(named: "customSecondaryColor")!,
                                    tintColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                                    title: "Perfil",
                                    preferredLargeTitle: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        let chevronImageView = UIImageView(image: UIImage(named: "rightArrow"))
        chevronImageView.tintColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        cell.accessoryView = chevronImageView
        cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        return cell
    }
}

extension PerfilViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch optionsList[indexPath.row] {
        case .logout:
            let rootVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            UIApplication.setRootView(rootVC, options: UIApplication.logoutAnimation)
        }
    }
}


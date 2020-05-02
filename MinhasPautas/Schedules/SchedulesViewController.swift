//
//  SchedulesViewController.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 01/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import UIKit

protocol SchedulesViewControlerDelegate {
    func reloadTableView()
    func resultLabelIsHidden(state: Bool, message: String)
}

class SchedulesViewController: UIViewController {

    // Oulets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // Variables and Constants
    var schedulesViewModel: SchedulesViewModel?
    private var spinner: UIView? = nil
    private var lastCellOpen: IndexPath?
    private var tabStatus = "Aberto"
    
    // Refresh Control
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.updateSchedules), for: .valueChanged)
        return refresh
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(UserDefaults.standard.object(forKey: "token_jwt") as? String ?? "")
//        print(UserDefaults.standard.object(forKey: "token_jwt") as? String ?? "")
//        print(UserDefaults.standard.object(forKey: "token_jwt") as? String ?? "")
//        print(UserDefaults.standard.object(forKey: "token_jwt") as? String ?? "")
//        print(UserDefaults.standard.object(forKey: "token_jwt") as? String ?? "")
//        print(UserDefaults.standard.object(forKey: "token_jwt") as? String ?? "")
//        print(UserDefaults.standard.object(forKey: "token_jwt") as? String ?? "")
//        print(UserDefaults.standard.object(forKey: "token_jwt") as? String ?? "")
        schedulesViewModel = SchedulesViewModel(delegate: self)
        setupLayout()
        getSchedules()
    }
    
    func setupLayout() {
        noResultLabel.isHidden = true
        tableView.register(UINib(nibName: "SchedulesTableViewCell", bundle: nil), forCellReuseIdentifier: "scheduleCell")
        tableView.refreshControl = refreshControl
        tableView.tableFooterView = UIView() // Remove blank lines in tableView footer
    }
    
    func getSchedules() {
        guard let _ = schedulesViewModel else { fatalError("ViewModel not implemented")}
        spinner = self.view.showSpinnerGray()
        schedulesViewModel?.getInitialData()
    }
    
    // Handle Refresh
    @objc private func updateSchedules() {
        schedulesViewModel?.getInitialData()
    }
    
    @IBAction func changeTab(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            tabStatus = "Aberto"
        } else {
            tabStatus = "Fechado"
        }
        tableView.reloadData()
    }
}

extension SchedulesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedulesViewModel?.schedulesList.filter { $0.status == tabStatus }.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as! SchedulesTableViewCell
        cell.schedulesViewModel = schedulesViewModel // Pass viewModel to the cell
        
        if segmentedControl.selectedSegmentIndex == 0 {
            cell.indexPath = indexPath // indexPath for change status (Aberto / Fechado)
            cell.scheduleModel = schedulesViewModel?.schedulesList.filter { $0.status == tabStatus }[indexPath.row]
        } else {
            cell.indexPath = indexPath // indexPath for change status (Aberto / Fechado)
            cell.scheduleModel = schedulesViewModel?.schedulesList.filter { $0.status == "Fechado" }[indexPath.row]
        }
        return cell
    }
}

extension SchedulesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // TA TENDO UM BUG AQUI PORQUE TÁ PERDENDO A POSIÇÃO EM RELAÇÃO AS ABAS
        // QUANDO VOU NA ABA E REMOVO UM ITEM, AI DEPOIS TENTO ABRIR UMA OUTRA ABA, ELE VAI TENTAR FECHAR A POSIÇÃO QUE NÃO EXISTE MAIS.
        // EXEMPLO: ABA FECHADA TEM 2, DAI EU REABRO UMA, DE EM SEGUINDA VOLTO PRA ABA ABERTAS.
        // QUANDO EU TENTAR ABRIR UMA NOVA CELULA, ELE VAI TENTAR FECHAR A POSIÇÃO QUE EU EXCLUI ANTERIORMENTE.
        
        // Colapse last cell open
        if lastCellOpen != nil && lastCellOpen?.row != indexPath.row {
            schedulesViewModel?.expandedCell(index: lastCellOpen!.row, status: false)
            tableView.reloadRows(at: [lastCellOpen!], with: .fade)
        }
        
        // Expand/Colapse cell
        schedulesViewModel?.expandedCell(index: indexPath.row, status: !schedulesViewModel!.schedulesList[indexPath.row].expanded)
        tableView.reloadRows(at: [indexPath], with: .fade)
        //tableView.scrollToRow(at: indexPath, at: .top, animated: true) // Testando se o resultado fica legal (Depois que corrigir tudo referente as abas voltar a testar)
        lastCellOpen = indexPath // Update last cell open
    }
}

// Loading more content while scrolling
extension SchedulesViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height) {
            schedulesViewModel?.getMoreData()
        }
    }
}

extension SchedulesViewController: SchedulesViewControlerDelegate {
    func reloadTableView() {
        spinner?.removeSpinner() // Só vai ser chamado se tiver um spinner ativo. Então não tem problema ser chamado aqui sempre.
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func resultLabelIsHidden(state: Bool, message: String = "") {
        noResultLabel.isHidden = state
        noResultLabel.text = message
    }
}

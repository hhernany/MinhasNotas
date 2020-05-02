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
    
    // Variables and Constants
    var schedulesViewModel: SchedulesViewModel?
    private var spinner: UIView? = nil

    // Refresh Control
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.updateSchedules), for: .valueChanged)
        return refresh
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        schedulesViewModel = SchedulesViewModel(delegate: self)
        setupLayout()
        getSchedules()
    }
    
    func setupLayout() {
        noResultLabel.isHidden = true
        //tableView.register(UINib(nibName: "SchedulesTableViewCell", bundle: nil), forCellReuseIdentifier: "schedulesCell")
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
}

extension SchedulesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedulesViewModel?.schedulesList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "schedulesCell", for: indexPath) as! SchedulesTableViewCell
//        cell.scheduleModel = schedulesViewModel.schedulesList[indexPath.row]
//        return cell
        return UITableViewCell()
    }
}

extension SchedulesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "issueDetailSegue", sender: self)
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
    // Situações
    // 1 - Tentei obter e não achou nada. Tem que remover o spinner (Não precisa do reloadData)
    // 2 - Tentar obter e achar dados. Precisa remover o spinner.
    // 3 - Quando obter mais dados enquanto rola, não vai ter spinner (Então não precisa remover aqui)
    // 4 - Quando eu puxar um handleRefresh, ele não vai ter spinner (Então não precisa remover aqui).
    
    // Resumindo - Só vai ter um spinner aqui na primeira vez que chamar.
    // Atualizando - Depois que atualizar o status de uma pauta expandida, a tableView vai ser recarregada, mas não precisa de spinner também. Vai atualizar só localmente e dar reloadData().
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

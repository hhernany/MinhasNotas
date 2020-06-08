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
    func updateError(message: String)
    func resetLastCellStatus(tab: String)
    func controlMessageStatus() // Control when a message whe be visible in the screen (Message when dont have any result to show)
}

class SchedulesViewController: UIViewController {

    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    // Variables and Constants
    var schedulesViewModel: SchedulesViewModel?
    private var spinner: UIView? = nil
    private var lastCellOpenInOpenTab: IndexPath?
    private var lastCellOpenInCloseTab: IndexPath?
    private var tabStatus = "Aberto"
    
    // Refresh Control
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.updateSchedules), for: .valueChanged)
        return refresh
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(UserDefaults.standard.object(forKey: "token_jwt") as? String ?? "")
        schedulesViewModel = SchedulesViewModel(delegate: self)
        setupLayout()
        getSchedules()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupLayout() {
        addButton.accessibilityIdentifier = "addButton"
        noResultLabel.isHidden = true
        tableView.accessibilityIdentifier = "scheduleTableView"
        tableView.register(UINib(nibName: "SchedulesTableViewCell", bundle: nil), forCellReuseIdentifier: "scheduleCell")
        tableView.refreshControl = refreshControl
        tableView.tableFooterView = UIView() // Remove blank lines in tableView footer
    }
    
    private func getSchedules() {
        guard let _ = schedulesViewModel else { fatalError("ViewModel not implemented")}
        spinner = self.view.showSpinnerGray()
        schedulesViewModel?.getInitialData()
    }
    
    // Handle Refresh
    @objc private func updateSchedules() {
        schedulesViewModel?.getInitialData()
    }
    
    @IBAction private func changeTab(_ sender: UISegmentedControl) {
        resultLabelIsHidden(state: true)
        if sender.selectedSegmentIndex == 0 {
            tabStatus = "Aberto"
        } else {
            tabStatus = "Fechado"
        }
        controlMessageStatus()
        tableView.reloadData()
    }
    
    // Uwind segue (After create a new schedule)
    @IBAction func backToSchedulesList(_ sender: UIStoryboardSegue) {
        DispatchQueue.main.async {
            self.segmentedControl.selectedSegmentIndex = 0 // Back to first tab after create a new schedule
            self.segmentedControl.sendActions(for: UIControl.Event.valueChanged) // Send update action

            self.spinner = self.view.showSpinnerGray()
            self.schedulesViewModel?.getInitialData()
        }
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
        if tabStatus == "Aberto" {
            return schedulesViewModel?.schedulesListOpen.count ?? 0
        } else {
            return schedulesViewModel?.schedulesListClose.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if schedulesViewModel?.schedulesList.count == 0 {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as! SchedulesTableViewCell
        cell.schedulesViewModel = schedulesViewModel // Pass viewModel to the cell
        cell.viewController = self
        cell.indexPath = indexPath
        
        if tabStatus == "Aberto" {
            cell.scheduleModel = schedulesViewModel?.schedulesListOpen[indexPath.row]
        } else {
            cell.scheduleModel = schedulesViewModel?.schedulesListClose[indexPath.row]
        }
        return cell
    }
}

extension SchedulesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Colapse last cell open
        let lastCellOpen = tabStatus == "Aberto" ? lastCellOpenInOpenTab : lastCellOpenInCloseTab
        if lastCellOpen != nil && lastCellOpen?.row != indexPath.row {
            schedulesViewModel?.expandedCell(index: lastCellOpen!.row, type: tabStatus, status: false)
            tableView.reloadRows(at: [lastCellOpen!], with: .fade)
        }
        
        // Expand/Colapse cell
        var newStatus: Bool
        if tabStatus == "Aberto" {
            newStatus = !schedulesViewModel!.schedulesListOpen[indexPath.row].expanded
        } else {
            newStatus = !schedulesViewModel!.schedulesListClose[indexPath.row].expanded

        }
        schedulesViewModel?.expandedCell(index: indexPath.row, type: tabStatus, status: newStatus)
        tableView.reloadRows(at: [indexPath], with: .fade)

        // Animate when scroll to top (Nedd some more test)
//        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
//            tableView.scrollToRow(at: indexPath, at: .top, animated: false)
//        }) { (completed) in }
        
        // Update last cell open
        if tabStatus == "Aberto" {
            lastCellOpenInOpenTab = indexPath
        } else {
            lastCellOpenInCloseTab = indexPath
        }
    }
}

// Loading more content while scrolling
extension SchedulesViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height) {
            if refreshControl.isRefreshing {
                return
            }
            schedulesViewModel?.getMoreData()
        }
    }
}

extension SchedulesViewController: SchedulesViewControlerDelegate {
    func reloadTableView() {
        spinner?.removeSpinner() // Só vai ser chamado se tiver um spinner ativo. Então não tem problema ser chamado aqui sempre.
        refreshControl.endRefreshing()
        tableView.reloadData()
        controlMessageStatus()
    }
    
    func resultLabelIsHidden(state: Bool, message: String = "") {
        noResultLabel.isHidden = state
        noResultLabel.text = message
    }
    
    func updateError(message: String) {
        message.alert(self, title: "Aviso") { UIAlertAction in
            self.getSchedules()
        }
    }
    
    func resetLastCellStatus(tab: String) {
        if tab == "Aberto" {
            lastCellOpenInOpenTab = nil
        } else {
            lastCellOpenInCloseTab = nil
        }
    }
    
    func controlMessageStatus() {
        if segmentedControl.selectedSegmentIndex == 0 && schedulesViewModel?.schedulesListOpen.count == 0 {
            resultLabelIsHidden(state: false, message: "Você não possui nenhuma pauta em aberto")
        }
        if segmentedControl.selectedSegmentIndex == 1 && schedulesViewModel?.schedulesListClose.count == 0 {
            resultLabelIsHidden(state: false, message: "Você não possui nenhuma pauta fechada")
        }
    }
}

//
//  SchedulesViewController.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 01/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import UIKit

protocol SchedulesViewControlerProtocol {
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
    var schedulesPresenter: SchedulesPresenterProtocol?
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
        if schedulesPresenter == nil {
            schedulesPresenter = SchedulesPresenter(delegate: self)
        }
        setupLayout()
        getSchedules()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupLayout() {
        self.setNeedsStatusBarAppearanceUpdate()
        self.configureNavigationBar(largeTitleColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                                    backgoundColor: UIColor.init(named: "customSecondaryColor")!,
                                    tintColor: UIColor.init(named: "customNavbarButtonsColor")!,
                                    title: "Minhas Pautas",
                                    preferredLargeTitle: true)
        noResultLabel.isHidden = true
        tableView.accessibilityIdentifier = "scheduleTableView"
        tableView.register(UINib(nibName: "SchedulesTableViewCell", bundle: nil), forCellReuseIdentifier: "scheduleCell")
        tableView.refreshControl = refreshControl
        tableView.tableFooterView = UIView() // Remove blank lines in tableView footer
        addButton.accessibilityIdentifier = "addButton"
    }
    
    private func getSchedules() {
        guard let _ = schedulesPresenter else { fatalError("Presenter not implemented")}
        spinner = self.view.showSpinnerGray()
        noResultLabel.isHidden = true // Hide while getting data
        schedulesPresenter?.getInitialData()
    }
    
    // Handle Refresh
    @objc func updateSchedules() {
        schedulesPresenter?.getInitialData()
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
            self.schedulesPresenter?.getInitialData()
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
            return schedulesPresenter?.schedulesListOpen.count ?? 0
        } else {
            return schedulesPresenter?.schedulesListClose.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if schedulesPresenter?.schedulesList.count == 0 {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as! SchedulesTableViewCell
        cell.schedulesPresenter = schedulesPresenter // Pass presenter to the cell
        cell.viewController = self
        cell.indexPath = indexPath
        
        if tabStatus == "Aberto" {
            cell.scheduleModel = schedulesPresenter?.schedulesListOpen[indexPath.row]
        } else {
            cell.scheduleModel = schedulesPresenter?.schedulesListClose[indexPath.row]
        }
        return cell
    }
}

extension SchedulesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Colapse last cell open
        let lastCellOpen = tabStatus == "Aberto" ? lastCellOpenInOpenTab : lastCellOpenInCloseTab
        if lastCellOpen != nil && lastCellOpen?.row != indexPath.row {
            schedulesPresenter?.expandedCell(index: lastCellOpen!.row, type: tabStatus, status: false)
            tableView.reloadRows(at: [lastCellOpen!], with: .fade)
        }
        
        // Expand/Colapse cell
        var newStatus: Bool
        if tabStatus == "Aberto" {
            newStatus = !schedulesPresenter!.schedulesListOpen[indexPath.row].expanded
        } else {
            newStatus = !schedulesPresenter!.schedulesListClose[indexPath.row].expanded

        }
        schedulesPresenter?.expandedCell(index: indexPath.row, type: tabStatus, status: newStatus)
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Cells fade animation
        let animation: TableAnimation = .fadeIn(duration: 0.85, delay: 0.03)
        let animator = TableViewAnimator(animation: animation.getAnimation())
        animator.animate(cell: cell, at: indexPath, in: tableView)
        
        // Loading more data when scrolling
        let totalCells = tabStatus == "Aberto" ? schedulesPresenter!.schedulesListOpen.count : schedulesPresenter!.schedulesListClose.count
        if indexPath.row == totalCells - 1 {
            if refreshControl.isRefreshing {
                return
            }
            schedulesPresenter?.getMoreData()
        }
    }
}

extension SchedulesViewController: SchedulesViewControlerProtocol {
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
        if segmentedControl.selectedSegmentIndex == 0 && schedulesPresenter?.schedulesListOpen.count == 0 {
            resultLabelIsHidden(state: false, message: "Você não possui nenhuma pauta em aberto")
        }
        if segmentedControl.selectedSegmentIndex == 1 && schedulesPresenter?.schedulesListClose.count == 0 {
            resultLabelIsHidden(state: false, message: "Você não possui nenhuma pauta fechada")
        }
    }
}

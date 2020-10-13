//
//  SchedulesPresenter.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 01/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import Moya

// Add ": class"  if change struct by class
protocol SchedulesPresenterProtocol: class {
    var schedulesList: [SchedulesModel] { get set }
    var schedulesListOpen: [SchedulesModel] { get set }
    var schedulesListClose: [SchedulesModel] { get set }
    
    func getInitialData()
    func getMoreData()
    func updateTableView()
    func controlResultLabel()
    func expandedCell(index: Int, type: String, status: Bool)
    func updateScheduleStatus(index: Int, listType: String)
}

class SchedulesPresenter {
    var presenterDelegate: SchedulesViewControlerProtocol?
    var webService: SchedulesWebServiceProtocol?
    
    fileprivate var provider: MoyaProvider<SchedulesAPI>!
    var schedulesList: [SchedulesModel] = []
    var schedulesListOpen: [SchedulesModel] = []
    var schedulesListClose: [SchedulesModel] = []
    fileprivate var page = 0
    fileprivate var isLoading = false
    fileprivate var reachEndOfData = false
    
    // Dependency Injection
    init(delegate: SchedulesViewControlerProtocol?,
         webservice: SchedulesWebServiceProtocol = SchedulesWebService()) {
        presenterDelegate = delegate
        webService = webservice
    }
    
//    private func setMoyaProvider() {
//        let isTesting = AppDelegate.isUITestingEnabled
//        if isTesting {
//            provider = MoyaProvider<SchedulesAPI>(stubClosure: MoyaProvider.immediatelyStub)
//        } else {
//            provider = MoyaProvider<SchedulesAPI>()
//        }
//    }
    
    private func getData() {
        webService?.getData(page: page, completionHandler: { [weak self] (schedulesList, resultModel, error) in
            if schedulesList != nil {
                // If list came empty, then reach the end of content
                if schedulesList?.count == 0 {
                    self?.reachEndOfData = true
                    return
                }
                self?.schedulesList += schedulesList!
                self?.schedulesListOpen = self?.schedulesList.filter { $0.status == "Aberto" } ?? []
                self?.schedulesListClose = self?.schedulesList.filter { $0.status == "Fechado" } ?? []
                self?.updateTableView()
                return
            }
            if resultModel != nil || error != nil {
                self?.controlResultLabel()
            }
        })
    }
    
    private func updateStatus(data: [String:Any]) {
        webService?.updateStatus(data: data, completionHandler: { [weak self] (resultModel, error) in
            if error != nil {
                self?.presenterDelegate?.updateError(message: "Não possível atualizar o status. Tente novamente.")
            } else if resultModel?.success == false {
                self?.presenterDelegate?.updateError(message: resultModel?.message ?? "Não foi possível atualizar o status. Tente novamente.")
            }
        })
    }
}

extension SchedulesPresenter: SchedulesPresenterProtocol {
    func getInitialData() {
        schedulesList.removeAll()
        schedulesListClose.removeAll()
        schedulesListOpen.removeAll()
        //presenterDelegate?.resultLabelIsHidden(state: true, message: "")
        page = 0
        isLoading = true
        reachEndOfData = false
        getData()
    }
    
    func getMoreData() {
        // Dont make recursive call while scrolling tableView/collectionView.
        // Dont load more data if dont have more data to get
        if isLoading || reachEndOfData {
            return
        }
        isLoading = true
        page += 1
        getData()
    }
    
    func updateTableView() {
        isLoading = false
        presenterDelegate?.reloadTableView()
    }
    
    // Show message only when there are no results (when list is empty).
    func controlResultLabel() {
        isLoading = false
        if schedulesList.count == 0 {
            presenterDelegate?.reloadTableView()
            presenterDelegate?.resultLabelIsHidden(state: false, message: "Você ainda não possui nenhuma pauta cadastrada.")
        } else {
            presenterDelegate?.reloadTableView()
        }
    }
    
    func expandedCell(index: Int, type: String, status: Bool) {
        if type == "Aberto" {
            schedulesListOpen[index].expandedCell(status)
        } else {
            schedulesListClose[index].expandedCell(status)
        }
    }
    
    // Status: Aberto e Fechado
    func updateScheduleStatus(index: Int, listType: String) {
        var newStatus: String!
        var schedule: Int!
        
        if listType == "Aberto" {
            newStatus = "Fechado"
            schedule = schedulesListOpen[index].id_pauta
            
            schedulesListOpen[index].expandedCell(false) // Close cell before append
            schedulesListOpen[index].updateStatus("Fechado") // Update status
            schedulesListClose.append(schedulesListOpen[index]) // Append in list
            schedulesListOpen.remove(at: index) // Remove from old list
        } else {
            newStatus = "Aberto"
            schedule = schedulesListClose[index].id_pauta
            
            schedulesListClose[index].expandedCell(false) // Close cell before append
            schedulesListClose[index].updateStatus("Aberto") // Update status
            schedulesListOpen.append(schedulesListClose[index]) // Append in list
            schedulesListClose.remove(at: index) // Remove from old list
        }
        
        let data: [String:Any] = [
            "codg_pauta": schedule,
            "status": newStatus
        ]
        updateStatus(data: data)
        presenterDelegate?.reloadTableView()
    }
}


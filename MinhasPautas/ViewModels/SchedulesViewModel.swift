//
//  SchedulesViewModel.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 01/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
import Moya

// Add ": class"  if change struct by class
protocol SchedulesViewModelDelegate: class {
    func getInitialData()
    func getMoreData()
    func updateTableView()
    func hideResultLabel(state: Bool)
    func expandedCell(index: Int, type: String, status: Bool)
    func updateScheduleStatus(index: Int, listType: String)
}

class SchedulesViewModel {
    
    var viewModelDelegate: SchedulesViewControlerDelegate? // AQUI TEORICAMENTE TEM QUE SER WEAK - VER O VIDEO DO CAREQUINHA QUE LÁ TEM ISSO E UM COMENTARIO DO CARA.
    fileprivate let provider = MoyaProvider<SchedulesAPI>()
    fileprivate(set) var schedulesList: [SchedulesModel] = [] // ISSO AQUI VAI TER QUE MUDAR. PQ NÃO VAI SER SÓ SET, VAI PODE ALTERAR TBM. (FALEI BOBAGEM?? )
    fileprivate(set) var schedulesListOpen: [SchedulesModel] = []
    fileprivate(set) var schedulesListClose: [SchedulesModel] = []
    fileprivate var page = 0
    fileprivate var isLoading = false
    
    // Dependency Injection
    init(delegate: SchedulesViewControlerDelegate?) {
        viewModelDelegate = delegate
    }
    
    private func getData() {
        provider.request(.getData(page: page)) { [weak self] result in
            
            switch result {
            case .success(let response):
                // print(try? JSONSerialization.jsonObject(with: response.data, options: []) as! [String : Any]) // Testing
                do {
                    self?.schedulesList += try response.map(SchedulesResults<SchedulesModel>.self).items
                    self?.schedulesListOpen = self?.schedulesList.filter { $0.status == "Aberto" } ?? []
                    self?.schedulesListClose = self?.schedulesList.filter { $0.status == "Fechado" } ?? []
                    self?.updateTableView()
                } catch {
                    self?.hideResultLabel(state: true)
                    print("Erro ao mapear resultados: \(error.localizedDescription)")
                }
            case .failure:
                self?.hideResultLabel(state: true)
                print("Erro ao obter dados: \(result.error.debugDescription)")
            }
        }
    }
    
    private func updateStatus(data: [String:Any]) {
        print(data)
        provider.request(.update(data: data)) { [weak self] result in
            switch result {
            case .success(let response):
                guard let json = try? JSONSerialization.jsonObject(with: response.data, options: []) as! [String : Any] else {
                    return
                }
                if json["success"] as? Bool == false {
                    self?.updateError(message: json["message"] as? String ?? "Não foi possível realizar atualizar o status. Recarrege a tela e tente novamente.")
                    return
                }
            case .failure:
                self?.updateError(message: "Não foi possível realizar atualizar o status. Recarrege a tela e tente novamente.")
                print("Erro ao obter dados: \(result.error.debugDescription)")
            }
        }
    }
}

extension SchedulesViewModel: SchedulesViewModelDelegate {
    func getInitialData() {
        schedulesList.removeAll()
        schedulesListClose.removeAll()
        schedulesListOpen.removeAll()
        page = 0
        isLoading = true
        getData()
    }
    
    func getMoreData() {
        // Dont make recursive call while scrolling tableView/collectionView.
        if isLoading {
            return
        }
        isLoading = true
        page += 1
        getData()
    }
    
    func updateTableView() {
        isLoading = false
        viewModelDelegate?.reloadTableView()
    }
    
    // Show message only when there are no results (when list is empty).
    func hideResultLabel(state: Bool) {
        isLoading = false
        if schedulesList.count == 0 {
            viewModelDelegate?.reloadTableView()
            viewModelDelegate?.resultLabelIsHidden(state: false, message: "Você ainda não possui nenhuma pauta cadastrada.")
        } else {
            viewModelDelegate?.reloadTableView()
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
        viewModelDelegate?.reloadTableView()
    }
    
    func updateError(message: String) {
        viewModelDelegate?.updateError(message: message)
    }
}


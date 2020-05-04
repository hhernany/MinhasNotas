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
}

class SchedulesViewModel {
    
    var viewModelDelegate: SchedulesViewControlerDelegate? // AQUI TEORICAMENTE TEM QUE SER WEAK - VER O VIDEO DO CAREQUINHA QUE LÁ TEM ISSO E UM COMENTARIO DO CARA.
    fileprivate let provider = MoyaProvider<SchedulesAPI>()
    fileprivate(set) var schedulesList: [SchedulesModel] = [] // ISSO AQUI VAI TER QUE MUDAR. PQ NÃO VAI SER SÓ SET, VAI PODE ALTERAR TBM. (FALEI BOBAGEM?? )
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
                print(try? JSONSerialization.jsonObject(with: response.data, options: []) as! [String : Any])
                do {
                    self?.schedulesList += try response.map(SchedulesResults<SchedulesModel>.self).items
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
}

extension SchedulesViewModel: SchedulesViewModelDelegate {
    func getInitialData() {
        schedulesList.removeAll() // SE COMÇEAR A CRASHAR, OU VAI TER QUE DAR RELOAD, OU VAI TER QUE LIMPAR DENTRO DO .SUCCESS
        page = 0
        isLoading = true
        getData()
    }
    
    func getMoreData() {
        print("more data")
        // Dont make recursive call while scrolling tableView/collectionView.
        if isLoading {
            print("is loading está ativo ainda")
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
    
    func expandedCell(status: Bool, index: Int) {
        schedulesList[index].expandedCell(status)
    }
}


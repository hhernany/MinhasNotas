//
//  SchedulesTableViewCell.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 02/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import UIKit

class SchedulesTableViewCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailTextField: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var detailContainerView: UIView!
    
    // Variables and Constants
    var scheduleModel: SchedulesModel! {
        didSet {
            fillCell()
            setupLayout()
        }
    }
    var schedulesViewModel: SchedulesViewModelProtocol?
    var viewController: SchedulesViewControlerProtocol?
    var indexPath: IndexPath!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fillCell() {
        titleLabel.text = scheduleModel.titulo
        descriptionLabel.text = scheduleModel.descricao
        detailTextField.text = scheduleModel.detalhes
        authorLabel.text = "Autor: \(scheduleModel.nome_usuario)"
    }
    
    func setupLayout() {
        authorLabel.isHidden = scheduleModel.expanded ? false : true
        detailContainerView.isHidden = scheduleModel.expanded ? false : true
        accessoryType = scheduleModel.expanded ? .none : .disclosureIndicator

        if #available(iOS 13.0, *) {
            backgroundColor = scheduleModel.expanded ? UIColor.tertiarySystemBackground : UIColor.secondarySystemBackground
        } else {
            backgroundColor = scheduleModel.expanded ? UIColor.init(named: "customLightGray") : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        titleLabel.numberOfLines = scheduleModel.expanded ? 0 : 1
        descriptionLabel.numberOfLines = scheduleModel.expanded ? 0 : 1
        detailTextField.numberOfLines = scheduleModel.expanded ? 0 : 1

        if scheduleModel.status == "Aberto" {
            statusButton.setTitle("Encerrar", for: .normal)
            statusButton.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        } else {
            statusButton.setTitle("Reabrir", for: .normal)
            statusButton.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
    }
    
    @IBAction func didTapStatusButton(_ sender: UIButton) {
        viewController?.resetLastCellStatus(tab: scheduleModel.status)
        schedulesViewModel?.updateScheduleStatus(index: indexPath.row, listType: scheduleModel.status)
    }
}

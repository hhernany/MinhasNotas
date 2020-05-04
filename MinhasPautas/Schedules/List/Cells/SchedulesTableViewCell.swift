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
    var schedulesViewModel: SchedulesViewModel?
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
        backgroundColor = scheduleModel.expanded ? UIColor.init(named: "customLightGray") : UIColor.white
        descriptionLabel.numberOfLines = scheduleModel.expanded ? 0 : 1
        detailTextField.numberOfLines = scheduleModel.expanded ? 0 : 1

        if scheduleModel.status == "Aberto" {
            statusButton.setTitle("Encerrar", for: .normal)
        } else {
            statusButton.setTitle("Reabrir", for: .normal)
        }
    }
    
    @IBAction func didTapStatusButton(_ sender: UIButton) {
        schedulesViewModel?.updateScheduleStatus(index: indexPath.row, listType: scheduleModel.status)
    }
}

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
    @IBOutlet weak var buttonViewContainer: UIView!
    @IBOutlet weak var statusButton: UIButton!
    
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
        authorLabel.text = scheduleModel.nome_usuario
        descriptionLabel.text = scheduleModel.descricao
    }
    
    func setupLayout() {
        authorLabel.isHidden = scheduleModel.expanded ? false : true
        buttonViewContainer.isHidden = scheduleModel.expanded ? false : true

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

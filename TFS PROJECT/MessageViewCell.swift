//
//  MessageViewCell.swift
//  TFS PROJECT
//
//  Created by v.kireev on 13/03/2020.
//  Copyright © 2020 VK. All rights reserved.
//

import UIKit

class MessageViewCell: UITableViewCell, ConfigurableView {
    typealias ConfigurationModel = MessageCellModel
    
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageText: UILabel!
    
    struct MessageCellModel {
        let id: Int
        let message: String
        let date: Date
        let selfMessage: Bool
    }
    
    func configure(with model: ConfigurationModel) {
        messageText.text = model.message
    }
    
}



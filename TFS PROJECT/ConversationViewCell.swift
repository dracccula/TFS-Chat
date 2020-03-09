//
//  ConversationViewCell.swift
//  TFS PROJECT
//
//  Created by Vladislav Kireev on 01.03.2020.
//  Copyright © 2020 VK. All rights reserved.
//

import UIKit

protocol ConfigurableView {
    associatedtype ConfigurationModel
    func configure(with model: ConfigurationModel)
}

class ConversationViewCell: UITableViewCell {
     typealias ConfigurationModel = ConversationCellModel
    
    @IBOutlet var statusIndicator: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    
    struct ConversationCellModel {
        let name: String
        let message: String?
        let date: Date
        let isOnline: Bool
        let hasUnreadMessages: Bool
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        statusIndicator.layer.cornerRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with model: ConversationViewCell.ConfigurationModel) {
        nameLabel.text? = model.name
        messageLabel.text = model.message
        let dateFormatter = DateFormatter()
        switch Calendar.current.component(.day, from: model.date)  {
        case Calendar.current.component(.day, from: Date()):
            dateFormatter.dateFormat = "HH:mm"
        default:
            dateFormatter.dateFormat = "dd MMM"
        }
        let dateString = dateFormatter.string(from: model.date)
        dateLabel.text = dateString
        model.isOnline ? contentView.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 215.0/255.0, alpha: 1) : ()
        model.hasUnreadMessages ? messageLabel.font = UIFont.boldSystemFont(ofSize: 17.0) : ()
        model.message == nil ? messageLabel.text = "No messages yet" : ()
        model.message == nil ? messageLabel.font = UIFont.italicSystemFont(ofSize: 17.0) : ()
    }

}

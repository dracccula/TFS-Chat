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
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    
    struct ConversationCellModel {
        let id: Int
        let name: String
        let message: String?
        let date: Date
        let isOnline: Bool
        let hasUnreadMessages: Bool
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.gray.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
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
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle == .light {
                model.isOnline ? contentView.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 190.0/255.0, alpha: 1) : ()
            } else {
                model.isOnline ? contentView.backgroundColor = UIColor.init(red: 150.0/255.0, green: 150.0/255.0, blue: 80.0/255.0, alpha: 1) : ()
            }
        } else {
            model.isOnline ? contentView.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 190.0/255.0, alpha: 1) : ()
        }
        model.hasUnreadMessages ? messageLabel.font = UIFont.boldSystemFont(ofSize: 17.0) : ()
        model.message == nil ? messageLabel.text = "No messages yet" : ()
        model.message == nil ? messageLabel.font = UIFont.italicSystemFont(ofSize: 17.0) : ()
    }

}

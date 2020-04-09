//
//  ChannelViewCell.swift
//  TFS Chat
//
//  Created by Vladislav Kireev on 29.03.2020.
//  Copyright © 2020 VK. All rights reserved.
//

import UIKit

protocol ConfigurableView {
    associatedtype ConfigurationModel
    func configure(with model: ConfigurationModel)
}

class ChannelViewCell: UITableViewCell {
     typealias ConfigurationModel = Channel
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        profileImage.layer.borderWidth = 1
//        profileImage.layer.masksToBounds = false
//        profileImage.layer.borderColor = UIColor.gray.cgColor
//        profileImage.layer.cornerRadius = profileImage.frame.height / 2
//        profileImage.clipsToBounds = true
//    }
    
    func configure(with model: ChannelViewCell.ConfigurationModel) {
        nameLabel.text = model.name
        model.name == "" || model.name == nil ? nameLabel.text = "Untitled" : ()
        messageLabel.text = model.lastMessage
        messageLabel.font = UIFont.systemFont(ofSize: 16.0)
        model.lastMessage == "" || model.lastMessage == nil ? messageLabel.text = "No messages yet" : ()
        model.lastMessage == "" || model.lastMessage == nil ? messageLabel.font = UIFont.italicSystemFont(ofSize: 17.0) : ()
        if model.lastActivity != nil {
            let dateFormatter = DateFormatter()
            switch Calendar.current.component(.day, from: model.lastActivity!)  {
            case Calendar.current.component(.day, from: Date()):
                dateFormatter.dateFormat = "HH:mm"
            default:
                dateFormatter.dateFormat = "dd MMM"
            }
            let dateString = dateFormatter.string(from: model.lastActivity!)
            dateLabel.text = dateString
            if #available(iOS 13.0, *) {
                if traitCollection.userInterfaceStyle == .light {
                    contentView.backgroundColor = model.lastActivity! > Date().addingTimeInterval(-600) ? UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 190.0/255.0, alpha: 1) : .systemBackground
                } else {
                    contentView.backgroundColor = model.lastActivity! > Date().addingTimeInterval(-600) ? UIColor.init(red: 150.0/255.0, green: 150.0/255.0, blue: 80.0/255.0, alpha: 1) : .systemBackground
                }
            } else {
                contentView.backgroundColor = model.lastActivity! > Date().addingTimeInterval(-600) ? UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 190.0/255.0, alpha: 1) : UIColor.init(named: "systemBackground")
            }
        } else {
            dateLabel.text = ""
        }
//        model.hasUnreadMessages ? messageLabel.font = UIFont.boldSystemFont(ofSize: 17.0) : ()
    }

}

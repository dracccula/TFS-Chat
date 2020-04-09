//
//  MessageViewCell.swift
//  TFS PROJECT
//
//  Created by v.kireev on 13/03/2020.
//  Copyright © 2020 VK. All rights reserved.
//

import UIKit

class MessageViewCell: UITableViewCell, ConfigurableView {
    typealias ConfigurationModel = Message
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var trailing: NSLayoutConstraint!
    @IBOutlet weak var leading: NSLayoutConstraint!
    
    func configure(with model: ConfigurationModel) {
        senderName.text = model.senderName
        messageView.layer.cornerRadius = 10
        messageText.text = model.content
        if model.created != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let dateString = dateFormatter.string(from: model.created!)
            dateLabel.text = dateString
        } else {
            dateLabel.text = ""
        }
        switch model.senderId == "VK" {
        case true:
            messageView.backgroundColor = UIColor.systemBlue
            leading.isActive = false
            trailing.isActive = true
        case false:
            messageView.backgroundColor = .lightGray
            leading.isActive = true
            trailing.isActive = false
        }
        
//        if model.isIncoming {
//            messageView.backgroundColor = .lightGray
//            leading.isActive = true
//            trailing.isActive = false
//        } else {
//            messageView.backgroundColor = UIColor.systemBlue
//            leading.isActive = false
//            trailing.isActive = true
//        }
    }
    
}



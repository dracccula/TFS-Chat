//
//  ConversationViewCell.swift
//  TFS PROJECT
//
//  Created by Vladislav Kireev on 01.03.2020.
//  Copyright © 2020 VK. All rights reserved.
//

import UIKit

class ConversationViewCell: UITableViewCell {
    
    @IBOutlet weak var statusIndicator: UIView!
    struct ConversationCellModel {
        let name: String
        let message: String
        let date: Date
        let isOnline: Bool
        let hasUnreadMessages: Bool
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

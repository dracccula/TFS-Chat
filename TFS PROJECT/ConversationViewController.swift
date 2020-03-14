//
//  ConversationViewController.swift
//  TFS PROJECT
//
//  Created by Vladislav Kireev on 02.03.2020.
//  Copyright © 2020 VK. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var messagesTableView: UITableView!
    
    // MARK: Messages data stub
    var messageArray : [MessageCellModel] = [MessageCellModel(id: 1, message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", date: Date.init(timeIntervalSince1970: 1583589958), isIncoming: false),
        MessageCellModel(id: 2, message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ultrices lacinia urna, eget tincidunt ligula scelerisque sed.", date: Date.init(timeIntervalSince1970: 1583589958), isIncoming: false),
        MessageCellModel(id: 3, message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ultrices lacinia urna, eget tincidunt ligula scelerisque sed. Duis facilisis bibendum mauris non posuere.", date: Date.init(timeIntervalSince1970: 1583589958), isIncoming: true),
        MessageCellModel(id: 4, message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", date: Date.init(timeIntervalSince1970: 1583589958), isIncoming: true),
        MessageCellModel(id: 5, message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ultrices lacinia urna, eget tincidunt ligula scelerisque sed.", date: Date.init(timeIntervalSince1970: 1583589958), isIncoming: false),
        MessageCellModel(id: 6, message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ultrices lacinia urna, eget tincidunt ligula scelerisque sed. Duis facilisis bibendum mauris non posuere.", date: Date.init(timeIntervalSince1970: 1583589958), isIncoming: true),
        MessageCellModel(id: 7, message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", date: Date.init(timeIntervalSince1970: 1583589958), isIncoming: false),
        MessageCellModel(id: 8, message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ultrices lacinia urna, eget tincidunt ligula scelerisque sed.", date: Date.init(timeIntervalSince1970: 1583589958), isIncoming: false),
        MessageCellModel(id: 9, message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ultrices lacinia urna, eget tincidunt ligula scelerisque sed. Duis facilisis bibendum mauris non posuere.", date: Date.init(timeIntervalSince1970: 1583589958), isIncoming: true),
        MessageCellModel(id: 10, message: "Lorem", date: Date.init(timeIntervalSince1970: 1583589958), isIncoming: true),
        MessageCellModel(id: 11, message: "ipsum", date: Date.init(timeIntervalSince1970: 1583589958), isIncoming: true),
        MessageCellModel(id: 12, message: "dolor", date: Date.init(timeIntervalSince1970: 1583589958), isIncoming: false),
        MessageCellModel(id: 13, message: "sit", date: Date.init(timeIntervalSince1970: 1583589958), isIncoming: true),
        MessageCellModel(id: 14, message: "amet", date: Date.init(timeIntervalSince1970: 1583589958), isIncoming: false),
        MessageCellModel(id: 15, message: "consectetur", date: Date.init(timeIntervalSince1970: 1583589958), isIncoming: false),
        MessageCellModel(id: 16, message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", date: Date.init(timeIntervalSince1970: 1583589958), isIncoming: false),
        MessageCellModel(id: 17, message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ultrices lacinia urna, eget tincidunt ligula scelerisque sed.", date: Date.init(timeIntervalSince1970: 1583589958), isIncoming: false),
        MessageCellModel(id: 18, message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ultrices lacinia urna, eget tincidunt ligula scelerisque sed. Duis facilisis bibendum mauris non posuere.", date: Date.init(timeIntervalSince1970: 1583589958), isIncoming: true),
        MessageCellModel(id: 19, message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", date: Date.init(timeIntervalSince1970: 1583589958), isIncoming: true),
        MessageCellModel(id: 20, message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ultrices lacinia urna, eget tincidunt ligula scelerisque sed.", date: Date.init(timeIntervalSince1970: 1583589958), isIncoming: false),
        MessageCellModel(id: 21, message: "Lorem", date: Date.init(timeIntervalSince1970: 1583589958), isIncoming: true),
        MessageCellModel(id: 22, message: "ipsum", date: Date.init(timeIntervalSince1970: 1583589958), isIncoming: true),
        MessageCellModel(id: 23, message: "dolor", date: Date.init(timeIntervalSince1970: 1583589958), isIncoming: false),
        MessageCellModel(id: 24, message: "sit", date: Date.init(timeIntervalSince1970: 1583589958), isIncoming: true),]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch messageArray[indexPath.row].isIncoming {
        case true:
            let cell = messagesTableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageViewCell
            cell.configure(with: messageArray[indexPath.row])
            return cell
        case false:
            let cell = messagesTableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageViewCell
            cell.configure(with: messageArray[indexPath.row])
            return cell
        }
    }
    
    //MARK: Function that scroll to bottom
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.messagesTableView.numberOfRows(inSection:  self.messagesTableView.numberOfSections - 1) - 1,
                section: self.messagesTableView.numberOfSections - 1)
            self.messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        scrollToBottom()
    }
}

//
//  ConversationViewController.swift
//  TFS PROJECT
//
//  Created by Vladislav Kireev on 02.03.2020.
//  Copyright © 2020 VK. All rights reserved.
//

import UIKit
import Firebase

class ChannelViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBAction func sendButtonAction(_ sender: Any) {
        sendMessage()
    }
    
    var channel: Channel?
    private let spinner = Spinner()
    
    
    var messagesArray : [Message] = []
    var sortedMessagesArray : [Message] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedMessagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messagesTableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageViewCell
        cell.configure(with: sortedMessagesArray[indexPath.row])
        return cell
    }
    
    //MARK: Function that scroll to bottom
    func scrollToBottom(){
        if sortedMessagesArray.count > 0 {
            DispatchQueue.main.async {
                self.messagesTableView.reloadData()
                let indexPath = IndexPath(
                    row: self.messagesTableView.numberOfRows(inSection:  self.messagesTableView.numberOfSections - 1) - 1,
                    section: self.messagesTableView.numberOfSections - 1)
                self.messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    
    private func getMessages() {
        FirebaseService().messages(channel: channel!).addSnapshotListener { (snapshot, error) in
                self.spinner.showActivityIndicator(uiView: self.view)
                self.messagesArray.removeAll()
                self.sortedMessagesArray.removeAll()
                snapshot?.documents.forEach { data in
                    let senderID = data.data()["senderID"] as? String
                    let senderName = data.data()["senderName"] as? String
                    let content = data.data()["content"] as? String
                    let created = data.data()["created"] as? Timestamp
                    self.messagesArray.append(Message(senderId: senderID, senderName: senderName, content: content, created: created?.dateValue()))
                }
                self.sortedMessagesArray = self.sortMessages(source: self.messagesArray)
                self.messagesTableView.reloadData()
                print("self.messagesTableView.reloadData()")
                self.spinner.hideActivityIndicator(uiView: self.view)
                self.scrollToBottom()
            }
    }
    
    private func sortMessages(source: [Message]) -> [Message] {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let defaultDate = dateFormatter.date(from: "01-02-2000")
        let result = source.sorted(by: { ($0.created ?? defaultDate!)?.compare($1.created ?? defaultDate!) == .orderedAscending})
        return result
    }
    
    private func sendMessage() {
        FirebaseService().messages(channel: channel!).addDocument(data: Message(senderId: "VK", senderName: "VK", content: messageTextView.text, created: Date()).toDict)
        messageTextView.text = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMessages()
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        messageTextView.delegate = self
        Utilities().setEnableButton(button: sendButton, enable: false)
        Utilities().drawBorder(textView: messageTextView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        messagesTableView.reloadData()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if messageTextView.text.isEmpty {
            Utilities().setEnableButton(button: sendButton, enable: false)
        } else {
            Utilities().setEnableButton(button: sendButton, enable: true)
        }
    }
    
}

extension Message {
    var toDict: [String: Any] {
        return ["content": content ?? "",
                "created": Timestamp(date: created!),
                "senderID": senderId!,
                "senderName": senderName!]
         
    }
}

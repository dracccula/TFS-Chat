//
//  ConversationViewController.swift
//  TFS PROJECT
//
//  Created by Vladislav Kireev on 02.03.2020.
//  Copyright © 2020 VK. All rights reserved.
//

import UIKit
import Firebase

class ChannelViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBAction func sendButtonAction(_ sender: Any) {
        sendMessage()
        getMessages()
    }
    
    var delegate: InfoDataDelegate?
    private let spinner = SpinnerUtils()
    var channel: Channel?
    let app = UIApplication.shared.delegate as! AppDelegate
    
    private lazy var reference: CollectionReference = {
    guard let channelIdentifier = channel?.identifier else { fatalError() }
        return app.db.collection("channels").document(channelIdentifier).collection("messages")
    }()
    
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
    
//    //MARK: Function that scroll to bottom
//    func scrollToBottom(){
//        DispatchQueue.main.async {
//            let indexPath = IndexPath(
//                row: self.messagesTableView.numberOfRows(inSection:  self.messagesTableView.numberOfSections - 1) - 1,
//                section: self.messagesTableView.numberOfSections - 1)
//            self.messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
//        }
//    }
    
    private func getMessages() {
        messagesArray.removeAll()
        sortedMessagesArray.removeAll()
        DispatchQueue.main.async {
            self.spinner.showActivityIndicator(uiView: self.view)
            self.reference.addSnapshotListener { (snapshot, error) in
                snapshot?.documents.forEach { data in
                    let senderID = data.data()["senderID"] as? String
                    let senderName = data.data()["senderName"] as? String
                    let content = data.data()["content"] as? String
                    let created = data.data()["created"] as? Timestamp
//                    print("\(senderID ?? "noId"), \(senderName ?? "noName"), \(content ?? "empty"), \(created?.dateValue() ?? Date())")
                    self.messagesArray.append(Message(senderId: senderID, senderName: senderName, content: content, created: created?.dateValue()))
                }
                self.sortedMessagesArray = self.sortMessages(source: self.messagesArray)
                self.messagesTableView.reloadData()
                print("self.messagesTableView.reloadData()")
                self.spinner.hideActivityIndicator(uiView: self.view)
            }
        }
    }
    
    private func sortMessages(source: [Message]) -> [Message] {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let defaultDate = dateFormatter.date(from: "01-02-2000")
//        print(defaultDate!)
        let result = source.sorted(by: { ($0.created ?? defaultDate!)?.compare($1.created ?? defaultDate!) == .orderedAscending})
        return result
    }
    
    private func sendMessage() {
        sendButton.isEnabled = false
        reference.addDocument(data: Message(senderId: "VK", senderName: "VK", content: messageTextField.text, created: Date()).toDict)
        sendButton.isEnabled = true
        messageTextField.text = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMessages()
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        messagesTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        messagesTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.initReload()
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

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
        sendMessage(channel: channel!, messageText: messageTextView.text)
    }
    
    var channel: Channel?
    private let spinner = Spinner()
    
    var firebase : FirebaseService = FirebaseService()
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
        firebase.getMessages(channel: channel!) { (messagesArray) in
            self.spinner.showActivityIndicator(uiView: self.view)
            self.sortedMessagesArray = messagesArray
            self.messagesTableView.reloadData()
            self.spinner.hideActivityIndicator(uiView: self.view)
            self.scrollToBottom()
        }
    }
    

    
    private func sendMessage(channel: Channel, messageText: String) {
        firebase.sendMessage(channel: channel, messageText: messageText) {
        }
        self.messageTextView.text = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMessages()
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        messageTextView.delegate = self
        Utilities().setEnableButton(button: sendButton, enable: false)
        Utilities().drawBorder(textView: messageTextView)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        messagesTableView.reloadData()
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        if let keyboardRect = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = -keyboardRect.height
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
        self.view.setNeedsLayout()
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

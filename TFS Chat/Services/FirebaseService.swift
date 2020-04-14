//
//  FirebaseService.swift
//  TFS Chat
//
//  Created by Vladislav Kireev on 11.04.2020.
//  Copyright © 2020 VK. All rights reserved.
//

import Firebase

class FirebaseService : FirebaseManager {
    
    func getChannels(completion: @escaping (_ : [[Channel]]) -> Void) {
        FirebaseService().channels.addSnapshotListener { snapshot, error in
            var channelsArray : [Channel] = []
            snapshot?.documents.forEach { data in
                let identifier = data.documentID
                let name = data.data()["name"] as? String
                let lastMessage = data.data()["lastMessage"] as? String
                let lastActivity = data.data()["lastActivity"] as? Timestamp
                channelsArray.append(Channel(identifier: identifier, name: name, lastMessage: lastMessage, lastActivity: lastActivity?.dateValue()))
            }
            completion(self.getSortedChannelsArrays(source: channelsArray))
        }
    }
    
    private func getSortedChannelsArrays(source: [Channel]) -> [[Channel]]{
        var onlineChannelsArray: [Channel] = []
        var historyChannelsArray: [Channel] = []
        var sortedOnlineChannelsArray: [Channel] = []
        var sortedHistoryChannelsArray: [Channel] = []
        source.forEach { channel in
            if channel.lastActivity != nil {
                if channel.lastActivity! > Date().addingTimeInterval(Constants.lastActivityInterval) {
                    onlineChannelsArray.append(channel)
                } else {
                    historyChannelsArray.append(channel)
                }
            } else {
                historyChannelsArray.append(channel)
            }
        }
        sortedOnlineChannelsArray = sortChannels(source: onlineChannelsArray)
        sortedHistoryChannelsArray = sortChannels(source: historyChannelsArray)
        return [sortedOnlineChannelsArray, sortedHistoryChannelsArray]
    }
    
    private func sortChannels(source: [Channel]) -> [Channel]{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let defaultDate = dateFormatter.date(from: "01-02-2000")
        let result = source.sorted(by: { ($0.lastActivity ?? defaultDate!)?.compare($1.lastActivity ?? defaultDate!) == .orderedDescending})
        return result
    }
    
    func addChannel(channelName: String, completion: @escaping () -> Void) {
        let newChannel : Channel = Channel(identifier: nil, name: channelName, lastMessage: "", lastActivity: Date())
        FirebaseService().channels.addDocument(data: newChannel.toDict)
    }
    
    func getMessages(channel: Channel, completion: @escaping ([Message]) -> Void) {
        FirebaseService().messages(channel: channel).addSnapshotListener { (snapshot, error) in
            var messagesArray: [Message] = []
            snapshot?.documents.forEach { data in
                let senderID = data.data()["senderID"] as? String
                let senderName = data.data()["senderName"] as? String
                let content = data.data()["content"] as? String
                let created = data.data()["created"] as? Timestamp
                messagesArray.append(Message(senderId: senderID, senderName: senderName, content: content, created: created?.dateValue()))
            }
            completion(self.sortMessages(source: messagesArray))
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
    
    func sendMessage(channel: Channel, messageText: String, completion: @escaping () -> Void) {
        FirebaseService().messages(channel: channel).addDocument(data: Message(senderId: "VK", senderName: "VK", content: messageText, created: Date()).toDict)
    }
    
    let app = UIApplication.shared.delegate as! AppDelegate
    
    lazy var channels = app.db.collection("channels")
    
    func messages(channel: Channel) -> CollectionReference {
        let messages: CollectionReference = {
            guard let channelIdentifier = channel.identifier else { fatalError() }
            return app.db.collection("channels").document(channelIdentifier).collection("messages")
        }()
        return messages
    }
}

extension Channel {
    var toDict: [String: Any] {
        return ["identifier": identifier ?? "",
                "lastActivity": Timestamp(date: lastActivity!),
                "name": name!,
                "lastMessage": lastMessage!]
         
    }
}

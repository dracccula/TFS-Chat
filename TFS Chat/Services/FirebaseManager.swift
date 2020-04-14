//
//  FirebaseManager.swift
//  TFS Chat
//
//  Created by Vladislav Kireev on 11.04.2020.
//  Copyright © 2020 VK. All rights reserved.
//

protocol FirebaseManager {
    func getChannels(completion: @escaping (_ : [[Channel]]) -> Void)
    func addChannel(channelName: String, completion: @escaping () -> Void)
    func getMessages(channel: Channel, completion: @escaping (_ : [Message]) -> Void)
    func sendMessage(channel: Channel, messageText: String, completion: @escaping () -> Void)
}

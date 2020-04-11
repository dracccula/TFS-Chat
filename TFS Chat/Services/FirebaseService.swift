//
//  FirebaseService.swift
//  TFS Chat
//
//  Created by Vladislav Kireev on 11.04.2020.
//  Copyright © 2020 VK. All rights reserved.
//

import Firebase

class FirebaseService : FirebaseManager {
    
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

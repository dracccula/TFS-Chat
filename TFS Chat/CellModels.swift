//
//  CellModels.swift
//  TFS PROJECT
//
//  Created by Vladislav Kireev on 14.03.2020.
//  Copyright © 2020 VK. All rights reserved.
//
import Foundation

struct ConversationCellModel {
    let id: Int
    let name: String
    let message: String?
    let date: Date
    let isOnline: Bool
    let hasUnreadMessages: Bool
}

struct MessageCellModel {
    let id: Int
    let message: String
    let date: Date
    let isIncoming: Bool
}

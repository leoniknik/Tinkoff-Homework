//
//  ConversationItem.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 23.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//


import Foundation

class ConversationElement  {
    var name : String? //
    var id: String?
    var lastMessageDate: Date? //
    var online : Bool = true //
    var hasUnreadMessages : Bool = false //
    var message: String? //
    
//    var messages: [Message] = []
    
    init(id: String?, userName: String?, online: Bool, lastMessageDate: Date?, hasUnreadMessages: Bool, message: String?){
        self.id = id
        self.name = userName
        self.online = online
        self.lastMessageDate = lastMessageDate
        self.hasUnreadMessages = hasUnreadMessages
        self.message = message
    }
    
//    func addMessage(message: Message){
//        if (message.isIncoming){
//            hasUnreadMessages = true
//            lastMessageDate = message.date
//        }
//        
//        messages.append(message)
//    }
    
    
}

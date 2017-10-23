//
//  ConversationItem.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 23.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//


import Foundation

class ConversationElement  {
    var name : String = ""
    var userId: String = ""
    var lastMessageDate: Date?
    var online : Bool = true
    var hasUnreadMessages : Bool = false
    
    var messages: [Message] = []
    
    init?(withUser userId: String, userName: String?){
        self.userId = userId
        if let name = userName {
            self.name = name
        }
    }
    
    func addMessage(message: Message){
        if (message.isIncoming){
            hasUnreadMessages = true
            lastMessageDate = message.date
        }
        
        messages.append(message)
    }
    
    
}

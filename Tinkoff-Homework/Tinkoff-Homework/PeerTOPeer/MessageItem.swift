//
//  MessageItem.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 23.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation

class Message {
    var text: String
    var user: String
    var date: Date?
    var isIncoming: Bool = true
    
    private let messageEvent = "TextMessage"
    
    init?(withText text: String, user: String){
        self.text = text
        self.date = Date()
        self.user = user
    }
}

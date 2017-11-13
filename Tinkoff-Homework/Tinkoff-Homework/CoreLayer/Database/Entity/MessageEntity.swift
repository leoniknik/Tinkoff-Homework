//
//  MessageEntity.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 13.11.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation
import CoreData

extension MessageEntity {
    
    static func fetchRequestMessagesInConversation(id: String, withModel model: NSManagedObjectModel) -> NSFetchRequest<MessageEntity>? {
        let templateName = "MessagesInConversationID"
        let conditions = [
            "conversationID" : id
        ]
        
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: conditions) as? NSFetchRequest<MessageEntity> else {
            assert(false, "No template with name: \(templateName)")
            return nil
        }
        
        return fetchRequest
    }
    
    static func insertMessage(id: String, inContext context: NSManagedObjectContext) -> MessageEntity? {
        if let message = NSEntityDescription.insertNewObject(forEntityName: "MessageEntity", into: context) as? MessageEntity {
            message.messageID = id
            message.date = Date()
            return message
        }
        return nil
    }
    
}

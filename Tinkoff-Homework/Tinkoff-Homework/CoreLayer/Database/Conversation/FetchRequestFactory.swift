//
//  FetchRequestFactory.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 13.11.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation
import CoreData

// Пример "замены" или "дополнения" темплейтов
class FetchRequestsFactory {
    
    let conversationEntityName = "ConversationEntity"
    
    let model: NSManagedObjectModel
    
    init(model: NSManagedObjectModel) {
        self.model = model
    }

    func fetchRequestOnlineConversations() -> NSFetchRequest<ConversationEntity> {
        let fetchRequest = NSFetchRequest<ConversationEntity>(entityName: conversationEntityName)
        fetchRequest.predicate = NSPredicate(format: "user.isOnline == %@", NSNumber(booleanLiteral: true))
        return fetchRequest
    }
    
    func fetchRequestAllConversations() -> NSFetchRequest<ConversationEntity> {
        let fetchRequest = NSFetchRequest<ConversationEntity>(entityName: conversationEntityName)
        return fetchRequest
    }
    
    func fetchRequestMessagesWithConversationID(id: String) -> NSFetchRequest<MessageEntity>? {
        let fetchRequest = MessageEntity.fetchRequestMessagesInConversation(id: id, withModel: model)
        return fetchRequest
    }

    
}

//
//  FetchRequestFactory.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 13.11.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation
import CoreData

struct FetchRequestsFactory {
    
    let conversationEntityName = "ConversationEntity"
    
//    let model: NSManagedObjectModel?
//    
//    init(model: NSManagedObjectModel?) {
//        self.model = model
//    }
//    

    func fetchRequestOnlineConversations() -> NSFetchRequest<ConversationEntity> {
        let fetchRequest = NSFetchRequest<ConversationEntity>(entityName: conversationEntityName)
        fetchRequest.predicate = NSPredicate(format: "user.isOnline == %@", NSNumber(booleanLiteral: true))
        return fetchRequest
    }
    
    func fetchRequestAllConversations() -> NSFetchRequest<ConversationEntity> {
        let fetchRequest = NSFetchRequest<ConversationEntity>(entityName: conversationEntityName)
        return fetchRequest
    }
    
//
//    func fetchRequestConversationByID(id: String) -> NSFetchRequest<Conversation>? {
//        if let model = model {
//            return Conversation.FetchRequests.fetchRequestConversationByID(id: id, withModel: model)
//        } else {
//            assertionFailure("Model is not avilable in context")
//            return nil
//        }
//    }
//    
//    func fetchRequestUserByID(id: String) -> NSFetchRequest<User>? {
//        if let model = model {
//            return User.FetchRequests.fetchRequestUserByID(id: id, withModel: model)
//        } else {
//            assertionFailure("Model is not available in context")
//            return nil
//        }
//    }
//    
//    func fetchRequestAllUsers() -> NSFetchRequest<User>? {
//        if let model = model {
//            return User.FetchRequests.fetchRequestUsers(withModel: model)
//        } else {
//            assertionFailure("Model is not available in context")
//            return nil
//        }
//    }
//    
//    func fetchRequestMessagesByConversationID(id: String) -> NSFetchRequest<Message>? {
//        if let model = model {
//            return Message.FetchRequests.fetchRequestMessagesByConversationID(id: id, withModel: model)
//        } else {
//            assertionFailure("Model is not available in context")
//            return nil
//        }
//    }
    
}

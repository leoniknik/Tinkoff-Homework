//
//  ConversationEntity.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 13.11.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit
import CoreData

extension ConversationEntity {
    
    static let name = "ConversationEntity"
    
    static func findOrInsertConversation(with id: String, in context: NSManagedObjectContext) -> ConversationEntity? {
        
        let fetchRequest = NSFetchRequest<ConversationEntity>(entityName: ConversationEntity.name)
        fetchRequest.predicate = NSPredicate(format: "conversationID == %@", id)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "conversationID", ascending: true)]
        
        var conversation: ConversationEntity?
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple conversation")
            if let foundConversation = results.first {
                conversation = foundConversation
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        if conversation == nil {
            conversation = ConversationEntity.insertConversation(with: id, in: context)
        }
        return conversation
    }
    
    static func insertConversation(with id: String, in context: NSManagedObjectContext) -> ConversationEntity? {
        if let conversation = NSEntityDescription.insertNewObject(forEntityName: ConversationEntity.name, into: context) as? ConversationEntity {
            conversation.conversationID = id
            conversation.hasUnreadMessages = false
            return conversation
        }
        return nil
    }
    
    
    static func fetchRequestConversationByID(id: String, withModel model: NSManagedObjectModel) -> NSFetchRequest<ConversationEntity>? {
        let templateName = "ConversationWithID"
        let conditions = [
            "conversationID" : id
        ]
        
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: conditions) as? NSFetchRequest<ConversationEntity> else {
            assertionFailure("can't get template: \(templateName)")
            return nil
        }
        
        return fetchRequest
    }
}






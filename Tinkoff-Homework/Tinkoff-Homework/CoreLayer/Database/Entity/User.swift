//
//  User.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 13.11.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit
import CoreData

extension User {
    
    static func findOrInsertUser(with id: String, in context: NSManagedObjectContext) -> User? {

        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            assertionFailure("Model is not available in context")
            return nil
        }
        
        guard let fetchRequest = User.fetchRequestUserWithID(id: id, withModel: model) else {
            return nil
        }
    
        var user: User?
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple users with same id found")
            if let foundUser = results.first {
                user = foundUser
            }
        } catch {
            print("Failed to fetch user")
        }
    
        if user == nil {
            user = insertUser(with: id, in: context)
        }
    
        return user
    }
    
    static func insertUser(with id: String, in context: NSManagedObjectContext) -> User? {
        if let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User {
            user.userID = id
            return user
        }
        return nil
    }
    
    static var generatedUserIdString: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? "volodin"
    }
    
    static func fetchRequestUserWithID(id: String, withModel model: NSManagedObjectModel) -> NSFetchRequest<User>? {
        
        let templateName = "UserByIdRequest"
        let conditions = [
            "userID" : id
        ]
        
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: conditions) as? NSFetchRequest<User> else {
            print("No template with name: \(templateName)")
            return nil
        }
        
        return fetchRequest
    }
    
    static func fetchRequestUsersOnline(withModel model: NSManagedObjectModel) -> NSFetchRequest<User>? {
        
        let templateName = "UsersOnlineRequest"
        
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<User> else {
            print("No template with name: \(templateName)")
            return nil
        }
        
        return fetchRequest
    }
}


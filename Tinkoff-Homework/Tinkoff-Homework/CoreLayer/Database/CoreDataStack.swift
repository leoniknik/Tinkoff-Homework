//
//  CoreDataStack.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 05.11.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataOperationResult {
    case ok
    case error
}

class CoreDataStack {
    
    private var storeURL: URL {
        get {
            let documentDirUrl: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let url = documentDirUrl.appendingPathComponent("Store.sqlite")
            return url
        }
    }
    
    
    private let managedObjectModelName = "Chat"
    private var _managedObjectModel: NSManagedObjectModel?
    private var managedObjectModel: NSManagedObjectModel? {
        get {
            if _managedObjectModel == nil {
                guard let modelURL = Bundle.main.url(forResource: managedObjectModelName, withExtension: "momd") else {
                    return nil
                }
                
                _managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
            }
            
            return _managedObjectModel
        }
    }
    
    
    private var _persistantStoreCoordinator: NSPersistentStoreCoordinator?
    private var persistantStoreCoordinator: NSPersistentStoreCoordinator? {
        get {
            if _persistantStoreCoordinator == nil {
                guard let model = self.managedObjectModel else {
                    print("Empty managed object model")
                    return nil
                }
                
                _persistantStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
                
                do {
                   try _persistantStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
                } catch {
                    assert(false, "Error adding persistant store to coordinator: \(error)")
                }
            }
            return _persistantStoreCoordinator
        }
    }
    
    
    private var _masterContext: NSManagedObjectContext?
    private var masterContext: NSManagedObjectContext? {
        get {
            if _masterContext == nil {
                let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                guard let persistantStoreCoordinator = self.persistantStoreCoordinator else {
                    print("Empty persistant store coordinator")
                    return nil
                }
                
                context.persistentStoreCoordinator = persistantStoreCoordinator
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                
                _masterContext = context
            }
            return _masterContext
        }
    }
    
    
    private var _mainContext: NSManagedObjectContext?
    public var mainContext: NSManagedObjectContext? {
        get {
            if _mainContext == nil {
                let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
                guard let parentContext = self.masterContext else {
                    print("No master context")
                    return nil
                }
                
                context.parent = parentContext
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                _mainContext = context
            }
            
            return _mainContext
        }
    }
    
    
    private var _saveContext: NSManagedObjectContext?
    public var saveContext: NSManagedObjectContext? {
        get {
            if _saveContext == nil {
                let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                guard let parentContext = self.masterContext else {
                    print("No master context")
                    return nil
                }
                
                context.parent = parentContext
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                _saveContext = context
            }
            
            return _saveContext
        }
    }
    
    
    public func performSave(context: NSManagedObjectContext, completionHandler : ((CoreDataOperationResult) -> Void)? ) {
        
        if context.hasChanges {
            context.perform { [weak self] in
                do {
                    try context.save()
                } catch {
                    print("Context save error: \(error)")
                    completionHandler?(CoreDataOperationResult.error)
                }
                
                if let parent = context.parent {
                    self?.performSave(context: parent, completionHandler: completionHandler)
                }
                else {
                    completionHandler?(CoreDataOperationResult.ok)
                }
            }
        }
        else {
            completionHandler?(CoreDataOperationResult.ok)
        }
    }

}

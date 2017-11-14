//
//  ConversationDataProvider.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 14.11.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit
import CoreData

protocol IConversationDataProvider {
    var fetchedResultsController: NSFetchedResultsController<MessageEntity>? { get set }
}

class ConversationDataProvider: NSObject, IConversationDataProvider {
    var fetchedResultsController: NSFetchedResultsController<MessageEntity>?
    let coreDataStack: CoreDataStack
    let tableView: UITableView
    
    init(tableView: UITableView, coreDataStack: CoreDataStack, conversationID: String) {
        self.coreDataStack = coreDataStack
        self.tableView = tableView
        
        super.init()
        
        if let context = coreDataStack.mainContext {
            
            guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
                return
            }
            let fetchRequestsFactory = FetchRequestsFactory(model: model)
            guard let fetchRequest = fetchRequestsFactory.fetchRequestMessagesWithConversationID(id: conversationID) else {
                return
            }
            
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(MessageEntity.date), ascending: true)]
            fetchedResultsController = NSFetchedResultsController<MessageEntity>(fetchRequest: fetchRequest,
                                                      managedObjectContext: context,
                                                      sectionNameKeyPath: nil,
                                                      cacheName: nil)
            fetchedResultsController?.delegate = self
            
            do {
                try self.fetchedResultsController?.performFetch()
                self.tableView.reloadData()
            } catch {
                print("Error: \(error)")
            }
        }
        
    }
}

extension ConversationDataProvider: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .move, .update : break
        }
    }
}

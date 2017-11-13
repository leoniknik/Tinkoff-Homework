//
//  ConversationsListDataProvider.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 13.11.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit
import CoreData

protocol IConversationsListDataProvider {
    var fetchedResultsController: NSFetchedResultsController<ConversationEntity>? { get set }
}

protocol IConversationsListDataProviderDelegate {

}

class ConversationsListDataProvider: NSObject, IConversationsListDataProvider {
    var fetchedResultsController: NSFetchedResultsController<ConversationEntity>?
    let tableView: UITableView
    var coreDataStack: CoreDataStack
    
    init(tableView: UITableView, coreDataStack: CoreDataStack) {
        
        self.coreDataStack = coreDataStack
        self.tableView = tableView
        
        super.init()
        
        if let context = coreDataStack.mainContext {
            let fetchRequestsFactory = FetchRequestsFactory()
            let fetchRequest = fetchRequestsFactory.fetchRequestAllConversations()
        
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(ConversationEntity.lastMessage.date), ascending: false)]
            fetchedResultsController = NSFetchedResultsController<ConversationEntity>(fetchRequest: fetchRequest,
                                                           managedObjectContext: context,
                                                           sectionNameKeyPath: #keyPath(ConversationEntity.isOnline),
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


extension ConversationsListDataProvider: NSFetchedResultsControllerDelegate {
    
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
                tableView.reloadRows(at: [indexPath], with: .none)
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

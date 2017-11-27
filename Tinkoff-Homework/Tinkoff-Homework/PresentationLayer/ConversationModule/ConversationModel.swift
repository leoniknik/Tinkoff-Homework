//
//  ConversationViewControllerModel.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 31.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

struct MessageDisplay {
    var text: String
    var isIncoming: Bool
}

protocol IConversationModelDelegate: class {
    func userDidBecomeOffline()
    func userDidBecomeOnline()
}

protocol IConversationModel{
    var conversationManager: IConversationManager { get set }
    weak var delegate: IConversationModelDelegate? { get set }
    var userName: String { get set }
    var online: Bool { get set }
    func numberOfRowsIn(section: Int) -> Int
    func getConversation(indexPath: IndexPath) -> MessageDisplay //!!!
    func sendMessage(text: String)
    func setMessagesRead()
    
    func initFetchedResultsManagerFor(tableView: UITableView)
}

class ConversationModel: IConversationModel, ICommunicationManagerDelegate {
    
    var online: Bool
    
    func userDidBecome(userID: String, online: Bool) {
        self.online = online
        if conversationID == userID {
            if online {
                delegate?.userDidBecomeOnline()
            } else {
                delegate?.userDidBecomeOffline()
            }
        }
    }
    
    var conversationManager: IConversationManager
    var communicationManager: ICommunicationManager
    weak var delegate: IConversationModelDelegate?
    private var conversationID: String
    var userName: String
    
    init(communicationManager: ICommunicationManager, conversationManager: IConversationManager, conversationID: String, online: Bool) {
        self.communicationManager = communicationManager
        self.conversationManager = conversationManager
        
        self.conversationID = conversationID
        self.userName = conversationManager.getUserName(userID: self.conversationID)
        self.online = online
    }
    
    func numberOfRowsIn(section: Int) -> Int {
        guard let fetchedResultsController = conversationManager.dataProvider?.fetchedResultsController,
            let sections = fetchedResultsController.sections else {
                return 0
        }
        return sections[section].numberOfObjects
    }
    
    func getConversation(indexPath: IndexPath) -> MessageDisplay {
        if let message = conversationManager.dataProvider?.fetchedResultsController?.object(at: indexPath) {
            
            let messageDisplayModel = MessageDisplay(text: message.text ?? "", isIncoming: message.sender?.currentAppUser == nil)
            
            return messageDisplayModel
        }
        
        return MessageDisplay(text: "", isIncoming: false)
    }
    
    func sendMessage(text: String) {
        conversationManager.sendMessage(string: text, to: conversationID, completionHandler: nil)
    }
    
    func setMessagesRead() {
        communicationManager.markConversationAsRead(userID: conversationID)
    }
    
    func initFetchedResultsManagerFor(tableView: UITableView) {
        conversationManager.setupDataProvider(tableView: tableView, conversationID: conversationID)
    }
    
    
}


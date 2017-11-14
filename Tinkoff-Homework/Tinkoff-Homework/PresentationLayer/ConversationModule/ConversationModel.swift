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
    func userWentOffline()
    func setup(dataSource: [Message])
}

protocol IConversationModel{
    var conversationManager: IConversationManager { get set }
    weak var delegate: IConversationModelDelegate? { get set }
    var userName: String { get set }
    func numberOfRowsIn(section: Int) -> Int
    func getConversation(indexPath: IndexPath) -> MessageDisplay //!!!
    func sendMessage(text: String)
    func markAsRead()
    func checkIfConversationExist()
    
    func initFetchedResultsManagerFor(tableView: UITableView)
}

class ConversationModel: IConversationModel, ICommunicationManagerDelegate {
    
    var conversationManager: IConversationManager
    var communicationManager: ICommunicationManager
    weak var delegate: IConversationModelDelegate?
    private var conversationID: String
    var userName: String
    
    init(communicationManager: ICommunicationManager, conversationManager: IConversationManager, conversationID: String) {
        self.communicationManager = communicationManager
        self.conversationManager = conversationManager
        
        self.conversationID = conversationID
        self.userName = conversationManager.getUserName(userID: self.conversationID)
        
//        for message in self.conversationService.getUserConversation(withID: self.conversationID) {
//            let newMessage = MessageCellDisplayModel(text: message.text, inbox: message.incoming)
//            self.messages.append(newMessage)
//        }
    }
    
    
    
    
    func didLostUser(withID userID: String) {
        
    }
    
    func didReceive(message: Message) {
        
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
        
    }
    
    func markAsRead() {
        
    }
    
    func checkIfConversationExist() {
        
    }
    
    
    func initFetchedResultsManagerFor(tableView: UITableView) {
        conversationManager.setupDataProvider(tableView: tableView, conversationID: conversationID)
    }
    
    
    
}


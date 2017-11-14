//
//  ConversationManager.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 14.11.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

protocol IConversationManager: class {
    var communicator: ICommunicator { get set }
    weak var delegate: IConversationManagerDelegate? { set get }
    var dataProvider: ConversationDataProvider? {get set}
    func getUserName(userID: String) -> String
    func getUserConversation(withID userID: String) -> [Message]
    func sendMessage(string text: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?)
    func setupDataProvider(tableView: UITableView, conversationID: String)
}

protocol IConversationManagerDelegate: class {
    func updateMessages(message: Message)
}

class ConversationManager: IConversationManager, ConversationMessageManagerDelegate {
    ///aaa
    var communicator: ICommunicator
    var dataStorage: IConversationStorageManager
    weak var delegate: IConversationManagerDelegate?
    var dataProvider: ConversationDataProvider?
    
    init(communicator: ICommunicator, storage: IConversationStorageManager, conversationID: String) {
        self.communicator = communicator
        self.dataStorage = storage
        self.dataStorage.conversationDelegate = self
    }
    
    func getUserName(userID: String) -> String {
        return dataStorage.getUserName(userID: userID)
    }
    
    func getUserConversation(withID userID: String) -> [Message] {
        return dataStorage.getConversation(userID: userID)
    }
    
    func sendMessage(string text: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
        dataStorage.saveMessageFromMe(userID: userID, text: text)
        communicator.sendMessage(string: text, to: userID, completionHandler: completionHandler)
    }
    
    func updateConversation(message: Message) {
        delegate?.updateMessages(message: message)
    }
    
    //
    func setupDataProvider(tableView: UITableView, conversationID: String) {
        self.dataProvider = ConversationDataProvider(tableView: tableView, coreDataStack: dataStorage.coreDataStack, conversationID: conversationID)
        self.dataStorage.conversationDelegate = self
    }
}

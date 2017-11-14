//
//  CommunicationManager.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 22.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.

import UIKit

protocol ICommunicationManager { //!!!
    
//    weak var listDelegate: ICommunicationManagerDelegate? {get set}
    weak var conversationDelegate: ICommunicationManagerDelegate? {get set}
//    func getConversations() -> [ConversationElement]
    var dataStorage: IConversationStorageManager {get set}
    var dataProvider: IConversationsListDataProvider? {get set}
    func setupDataProvider(tableView: UITableView)
    var communicator: ICommunicator {get set}
    func markConversationAsRead(userID: String)
}

protocol ICommunicationManagerDelegate: class {
    func userDidBecome(userID: String, online: Bool)
}

//, ConversationStorageManagerDelegate
class CommunicationManager: ICommunicationManager, ICommunicatorDelegate{
    
    
    func markConversationAsRead(userID: String) {
        dataStorage.markMessageAsRead(conversationID: userID)
    }
    
    
    var dataProvider: IConversationsListDataProvider? //
    
    var dataStorage: IConversationStorageManager //
    
    var communicator: ICommunicator

    weak var conversationDelegate: ICommunicationManagerDelegate?
    
    init(multipeerCommunicator: ICommunicator, conversationStorage: IConversationStorageManager) {
        self.communicator = multipeerCommunicator
        self.dataStorage = conversationStorage
    }
    
    func setupDataProvider(tableView: UITableView) {
        self.dataProvider = ConversationsListDataProvider(tableView: tableView, coreDataStack: dataStorage.coreDataStack)
//        self.dataStorage.delegate = self
    }
    
    func userDidBecome(userID: String, online: Bool) {
        conversationDelegate?.userDidBecome(userID: userID, online: online)
    }
    
//    var converationList: [ConversationElement] = []
//
//    func getConversations() -> [ConversationElement] {
//        return converationList
//    }
//
    
    func send(_ message: Message, userID: String) {
    }
    
    ///
    func didFoundUser(userID: String, userName: String?) {
        dataStorage.saveConversation(userID: userID, userName: userName)
    }
    
    ///
    func didLostUser(userID: String) {
        dataStorage.deleteConversation(userID: userID)
    }
    ///
    func failedToStartBrowsingForUsers(error: Error) {
        
    }
    ///
    func failedToStartAdvertising(error: Error) {
        
    }
    
    ///
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        

        if fromUser == UIDevice.current.identifierForVendor?.uuidString ?? "volodin" {
            dataStorage.saveMessageFromMe(userID: toUser, text: text)
        }
        else {
            dataStorage.saveMessageToMe(userID: fromUser, text: text)
        }

    }
    
}

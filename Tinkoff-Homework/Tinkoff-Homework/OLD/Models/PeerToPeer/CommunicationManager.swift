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
    func getConversations() -> [ConversationElement]
    var dataStorage: IConversationStorageManager {get set}
    var dataProvider: IConversationsListDataProvider? {get set}
    func setupDataProvider(tableView: UITableView)
    var communicator: ICommunicator {get set}
}

protocol ICommunicationManagerDelegate: class {
    func didLostUser(withID userID: String)
    func didReceive(message: Message)
}

class CommunicationManager: ICommunicationManager, ICommunicatorDelegate, ConversationStorageManagerDelegate {
    
    func update() {
//        listDelegate?.updateConversationsList()
//        conversationDelegate?.updateCurrentConversation()
    }
    
    
    var dataProvider: IConversationsListDataProvider? //
    
    var dataStorage: IConversationStorageManager //
    
    var communicator: ICommunicator

//    weak var listDelegate: ICommunicationManagerDelegate?
    weak var conversationDelegate: ICommunicationManagerDelegate?
    
    init(multipeerCommunicator: ICommunicator, conversationStorage: IConversationStorageManager) {
        self.communicator = multipeerCommunicator
        self.dataStorage = conversationStorage
    }
    
    func setupDataProvider(tableView: UITableView) {
        self.dataProvider = ConversationsListDataProvider(tableView: tableView, coreDataStack: dataStorage.coreDataStack)
        self.dataStorage.delegate = self
    }
    
    func userDidBecome(userID: String, online: Bool) {
//        if let ind = converationList.index(where: {$0.userId == userID }) {
//            converationList[ind].online = online
//        
//            converationList = converationList.sorted {
//                if let date0 = $0.lastMessageDate,
//                    let date1 = $1.lastMessageDate{
//                    return date0 > date1
//                } else {
//                    return $0.name < $1.name
//                }
//            }
//            
//            DispatchQueue.main.async {
//                self.listDelegate?.updateConversationsList()
//                self.conversationDelegate?.updateCurrentConversation()
//            }
//        
//        }
    }
    
    var converationList: [ConversationElement] = []
    
    func getConversations() -> [ConversationElement] {
        return converationList
    }
    
//    func getConversationBy(userID: String) -> ConversationElement? {
//        if let ind = converationList.index(where: {$0.userId == userID }) {
//            return converationList[ind]
//        } else {
//            return nil
//        }
//    }
    
    func send(_ message: Message, userID: String) {
        
//        guard let conversation = getConversationBy(userID: userID) else {
//            return
//        }
    
//        communicator.sendMessage(string: message.text, to: con) { (success, error) in
//            guard error == nil else {
//                return
//            }
//
//            if success {
////                conversation.addMessage(message: message)
//                self.conversationDelegate?.updateConversationsList()
//                self.conversationDelegate?.updateCurrentConversation()
//            }
//            else {
//                print("Can't send message to peer")
//            }
//        }
    }
    
    ///
    func didFoundUser(userID: String, userName: String?) {
        dataStorage.saveConversation(userID: userID, userName: userName)
//        if let ind = converationList.index(where: {$0.userId == userID }) {
//            converationList[ind].online = true
//        }
//        else {
//            if let newConversation = ConversationElement.init(withUser: userID, userName: userName) {
//                converationList.append(newConversation)
//            }
//        }
//
//        converationList = converationList.sorted {
//            if let date0 = $0.lastMessageDate,
//                let date1 = $1.lastMessageDate{
//                return date0 > date1
//            } else {
//                return $0.name < $1.name
//            }
//        }
//
//        DispatchQueue.main.async {
//            self.listDelegate?.updateConversationsList()
//                self.conversationDelegate?.updateCurrentConversation()
//        }
    }
    
    ///
    func didLostUser(userID: String) {
        dataStorage.deleteConversation(userID: userID)
//        if let ind = converationList.index(where: {$0.userId == userID }) {
//            converationList[ind].online = false
//        }
//
//        converationList = converationList.sorted {
//            if let date0 = $0.lastMessageDate,
//                let date1 = $1.lastMessageDate{
//                return date0 > date1
//            } else {
//                return $0.name < $1.name
//            }
//        }
//
//        DispatchQueue.main.async {
//            self.listDelegate?.updateConversationsList()
//            self.conversationDelegate?.updateCurrentConversation()
//        }
        
    }
    ///
    func failedToStartBrowsingForUsers(error: Error) {
        
    }
    ///
    func failedToStartAdvertising(error: Error) {
        
    }
    
    ///
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        

        if fromUser == "volodin" {
            dataStorage.saveMessageFromMe(userID: toUser, text: text)
        }
        else {
            dataStorage.saveMessageToMe(userID: fromUser, text: text)
        }
//
//        if let ind = converationList.index(where: {$0.userId == rawFrom }) {
//            if let newMessage = Message.init(withText: text, user: rawFrom) {
//            newMessage.isIncoming = status
//            converationList[ind].addMessage(message: newMessage)
////            if fromUser == currentConversationId {
////                converationList[ind].hasUnreadMessages = false
////            }
//            }
//        }
//
//        DispatchQueue.main.async {
//            self.listDelegate?.updateConversationsList()
//            //if (fromUser == self.currentConversationId){
//                self.conversationDelegate?.updateCurrentConversation()
//            //}
//        }

    }
    
//    func getConversation(key: Int) -> ConversationElement {
//        return self.converationList[key]
//    }
    
    func updateConversation(message: Message) {
        
    }
    
    func conversationChanged(conversation: ConversationElement) {
        
    }
    
    func newConversationCreated(conversation: ConversationElement) {
        
    }
    
}

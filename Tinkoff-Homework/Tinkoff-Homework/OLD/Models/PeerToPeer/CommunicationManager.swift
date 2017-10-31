//
//  CommunicationManager.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 22.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.

import Foundation

protocol CommunicationManagerDelegate: class {
    func updateConversationsList()
    func updateCurrentConversation()
}

class CommunicationManager: CommunicatorDelegate {
    
    var communicator: MultipeerCommunicator

    weak var listDelegate: CommunicationManagerDelegate?
    weak var conversationDelegate: CommunicationManagerDelegate?
    
    init(multipeerCommunicator:MultipeerCommunicator) {
        self.communicator = multipeerCommunicator
    }
    
    func userDidBecome(userID: String, online: Bool) {
        if let ind = converationList.index(where: {$0.userId == userID }) {
            converationList[ind].online = online
        
            converationList = converationList.sorted {
                if let date0 = $0.lastMessageDate,
                    let date1 = $1.lastMessageDate{
                    return date0 > date1
                } else {
                    return $0.name < $1.name
                }
            }
            
            DispatchQueue.main.async {
                self.listDelegate?.updateConversationsList()
                    self.conversationDelegate?.updateCurrentConversation()
            }
        
        }
    }
    
    var converationList: [ConversationElement] = []
    
    func getConversations() -> [ConversationElement] {
        return converationList
    }
    
    func getConversationBy(userID: String) -> ConversationElement? {
        if let ind = converationList.index(where: {$0.userId == userID }) {
            return converationList[ind]
        } else {
            return nil
        }
    }
    
    func send(_ message: Message, userID: String) {
        
        guard let conversation = getConversationBy(userID: userID) else {
            return
        }
    
        communicator.sendMessage(string: message.text, to: conversation.userId) { (success, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if success {
                conversation.addMessage(message: message)
                self.conversationDelegate?.updateConversationsList()
                self.conversationDelegate?.updateCurrentConversation()
            }
            else {
                print("Can't send message to peer")
            }
        }
    }
    
//    func selectCurrentConversation(withId userId: String) {
//        currentConversationId = userId
//        if let ind = converationList.index(where: {$0.userId == userId }) {
//            converationList[ind].hasUnreadMessages = false
//        }
//
//    }
    
    // MARK: - CommunicatorDelegate
    
    func didFoundUser(userID: String, userName: String?) {
        if let ind = converationList.index(where: {$0.userId == userID }) {
            converationList[ind].online = true
        }
        else {
            let newConversation = ConversationElement.init(withUser: userID, userName: userName)!
            converationList.append(newConversation)
        }
        
        converationList = converationList.sorted {
            if let date0 = $0.lastMessageDate,
                let date1 = $1.lastMessageDate{
                return date0 > date1
            } else {
                return $0.name < $1.name
            }
        }
        
        DispatchQueue.main.async {
            self.listDelegate?.updateConversationsList()
                self.conversationDelegate?.updateCurrentConversation()
        }
    }
    
    func didLostUser(userID: String) {
        
        if let ind = converationList.index(where: {$0.userId == userID }) {
            converationList[ind].online = false
        }
        
        converationList = converationList.sorted {
            if let date0 = $0.lastMessageDate,
                let date1 = $1.lastMessageDate{
                return date0 > date1
            } else {
                return $0.name < $1.name
            }
        }
        
        DispatchQueue.main.async {
            self.listDelegate?.updateConversationsList()
            self.conversationDelegate?.updateCurrentConversation()
        }
        
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        
    }
    
    func failedToStartAdvertising(error: Error) {
        
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        
        var status = true
        var rawFrom = fromUser
        
        if fromUser == "volodin" {
            rawFrom = toUser
            status = false
        }
        
        if let ind = converationList.index(where: {$0.userId == rawFrom }) {
            let newMessage = Message.init(withText: text, user: rawFrom)!
            newMessage.isIncoming = status
            converationList[ind].addMessage(message: newMessage)
//            if fromUser == currentConversationId {
//                converationList[ind].hasUnreadMessages = false
//            }
        }
        
        DispatchQueue.main.async {
            self.listDelegate?.updateConversationsList()
            //if (fromUser == self.currentConversationId){
                self.conversationDelegate?.updateCurrentConversation()
            //}
        }
    }
    
    func getConversation(key: Int) -> ConversationElement {
        return self.converationList[key]
    }
    
}

//
//  CommunicationManager.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 22.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

//import Foundation
//import MultipeerConnectivity
//
//class ChatMessage{
//
//    init(text:String,date:Date,income:Bool) {
//        self.text = text
//        self.date = date
//        self.income = income
//        self.unRead = true
//    }
//    var text:String
//    var date:Date
//    var income:Bool
//    var unRead:Bool
//
//}
//
//class ChatDialog{
//
//    init(name:String,userID:String){
//        self.name = name
//        self.userID = userID
//        self.online = false
//        self.messages = [ChatMessage]()
//    }
//    
//    var name: String?
//    var userID: String?
//    var online: Bool
//    var messages:[ChatMessage]
//    
//}
//
//class CommunicationManager: CommunicatorDelegate{
//
//    var dialogs: Dictionary<String,ChatDialog> = Dictionary<String,ChatDialog>()
//
//    func getDialogByUserID(userID:String)->ChatDialog{
//        return getDialog(userID: userID, userName: "")
//    }
//
//    func getDialog(userID:String, userName:String)->ChatDialog{
//        if let dialog = dialogs[userID]{
//            if dialog.name == "" && userName != "" {
//                dialog.name = userName
//            }
//            return dialog
//        }
//
//        let dialog = ChatDialog(name:userName,userID:userID)
//        dialogs[userID]=dialog
//        return dialog
//    }
//
//    func didFoundUser(userID: String, userName: String?) {
//        let _ = getDialog(userID: userID, userName: userName!)
//    }
//    
//    func userDidBecome(userID:String,online:Bool){
//        let dialog = getDialogByUserID(userID: userID)
//        dialog.online = online
//
//        NotificationCenter.default.post(name: .refreshDialog, object: nil)
//        NotificationCenter.default.post(name: .refreshDialogs, object: nil)
//    }
//
//    func didLostUser(userID: String) {
//        return
//    }
//
//    func failedToStartBrowsingForUsers(error: Error) {
//        return
//    }
//    
//    func failedToStartAdvertising(error: Error) {
//        return
//    }
//    
//    func didRecieveMessage(text: String, fromUser: String, toUser: String) {
//        let message = ChatMessage(text: text,date: Date(),income: false)
//
//        let dialog:ChatDialog
//
//        if(toUser == "me"){
//            message.income = true
//            dialog = getDialogByUserID(userID: fromUser)
//        }else{
//            message.income = false
//            dialog = getDialogByUserID(userID: toUser)
//        }
//        
//        dialog.messages.append(message)
//        dialog.messages.sort{ $0.date < $1.date }
//        
//        NotificationCenter.default.post(name: .refreshDialog, object: nil)
//        NotificationCenter.default.post(name: .refreshDialogs, object: nil)
//
//    }
//
//    func getDialogMessages(userName:String)->[ChatMessage]{
//
//        for item in dialogs{
//            if item.value.name == userName{
//                return item.value.messages
//            }
//        }
//
//        return [ChatMessage]()
//
//    }
//
//    func getChatDialog(userName:String)->ChatDialog{
//
//        for item in dialogs{
//            if item.value.name == userName{
//                return item.value
//            }
//        }
//        
//        return ChatDialog(name:"", userID: "")
//
//    }
//
//    func getChatDialog(userID:String)->ChatDialog{
//        
//        return dialogs[userID]!
//
//    }
//    
//    func getChatDialogs()->[ChatDialog]{
//        var array = [ChatDialog]()
//        for item in dialogs{
//            array.append(item.value)
//        }
//        return array
//    }
//
//    func updateUnread(userID:String){
//        let dialog = dialogs[userID]
//        for message in dialog!.messages{
//            message.unRead = false
//        }
//
//    }
//}

import Foundation

protocol ConversationsManagerDelegate: class {
    func updateConversationsList()
    func updateCurrentConversation()
}

class ConversationsManager: CommunicatorDelegate {
    
    func userDidBecome(userID: String, online: Bool) {
        
    }
    
    static let shared = ConversationsManager()
    let communicator = MultipeerCommunicator()
    
    weak var listDelegate: ConversationsManagerDelegate?
    weak var conversationDelegate: ConversationsManagerDelegate?
    
    private var currentConversationId: String?
    
    var converationList: [ConversationElement] = []
    
    var currentConversation: ConversationElement? {
        get {
            if let ind = converationList.index(where: {$0.userId == currentConversationId }) {
                return converationList[ind]
            } else {
                return nil
            }
        }
    }
    
    private init() {
        communicator.delegate = self
    }
    
    func send(_ message: Message) {
        guard let conversation = currentConversation else {
            return
        }
    
        communicator.sendMessage(string: message.text, to: conversation.userId) { (success, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if success {
                if let conversation = self.currentConversation {
                    conversation.addMessage(message: message)
                    self.conversationDelegate?.updateConversationsList()
                    self.conversationDelegate?.updateCurrentConversation()
                }
            }
            else {
                print("Can't send message to peer: \(self.currentConversationId ?? "none")")
            }
        }
    }
    
    func selectCurrentConversation(withId userId: String) {
        currentConversationId = userId
        if let ind = converationList.index(where: {$0.userId == userId }) {
            converationList[ind].hasUnreadMessages = false
        }
        
    }
    
    func forgetCurrentConversation() {
        currentConversationId = nil
    }
    
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
            if (userID == self.currentConversationId){
                self.conversationDelegate?.updateCurrentConversation()
            }
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
            if (userID == self.currentConversationId){
                self.currentConversationId = nil
                self.conversationDelegate?.updateCurrentConversation()
            }
        }
        
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        
    }
    
    func failedToStartAdvertising(error: Error) {
        
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        
        if let ind = converationList.index(where: {$0.userId == fromUser }) {
            let newMessage = Message.init(withText: text, user: fromUser)!
            newMessage.isIncoming = true
            converationList[ind].addMessage(message: newMessage)
            if fromUser == currentConversationId {
                converationList[ind].hasUnreadMessages = false
            }
        }
        
        DispatchQueue.main.async {
            self.listDelegate?.updateConversationsList()
            if (fromUser == self.currentConversationId){
                self.conversationDelegate?.updateCurrentConversation()
            }
        }
    }
}

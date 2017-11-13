//
//  ConversationStorageManager.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 13.11.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

protocol ConversationStorageManagerDelegate: class {
    func conversationChanged(conversation: ConversationElement)
    func newConversationCreated(conversation: ConversationElement)
    func updateConversation(message: Message)
    
    func update()
}

protocol IConversationStorageManager {
    
    var coreDataStack: CoreDataStack {get set}
    
    
    
    weak var delegate: ConversationStorageManagerDelegate?  { get set }
//    weak var conversation: ConversationMessageStorageManagerDelegate?  { get set }
    func saveConversation(userID: String, userName: String?)
    func deleteConversation(userID: String)
    func setMessageAsRead(conversationID: String)
    func saveMessageToMe(userID: String, text: String)
    func getUserName(userID: String) -> String
    func saveMessageFromMe(userID: String, text: String)
    func setAllUsersOffline(completionHandler: @escaping () -> () )
    func getConversationsList() -> [ConversationElement]
}

class ConversationStorageManager: IConversationStorageManager {
    
    func getConversationsList() -> [ConversationElement] {
        return converationList
    }
    
    weak var delegate: ConversationStorageManagerDelegate?
    //    weak var conversation: ConversationMessageStorageManagerDelegate?
    
    private var converationList: [ConversationElement] = []
    var coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack){
        self.coreDataStack = coreDataStack
    }
    
    func saveConversation(userID: String, userName: String?) {
        
        guard let context = coreDataStack.mainContext else {
            assert(false, "Can't get context in \(#function)")
        }
        
        guard let user = User.findOrInsertUser(with: userID, in: context),
            let conversation = ConversationEntity.findOrInsertConversation(with: userID, in: context) else {
                assertionFailure("Can't find")
                return
        }
        
        user.isOnline = true
        if let name = userName {
            user.name = name
        }
        
        if user.conversation == nil {
            user.conversation = conversation
        }
        
        user.conversation?.isOnline = true // test
        
        coreDataStack.performSave(context: context, completionHandler: nil)
        DispatchQueue.main.async {
            self.delegate?.update()
        }
    }
    
    func deleteConversation(userID: String) {
        
        guard let context = coreDataStack.mainContext else {
            assert(false, "Can't get context in \(#function)")
        }
        
        guard let user = User.findOrInsertUser(with: userID, in: context),
            let conversation = ConversationEntity.findOrInsertConversation(with: userID, in: context) else {
                assertionFailure("Can't find")
                return
        }
        
        user.isOnline = false
        conversation.isOnline = false
        
        coreDataStack.performSave(context: context, completionHandler: nil)
        
        DispatchQueue.main.async {
            self.delegate?.update()
        }
    }
    
    func setMessageAsRead(conversationID: String) {
        guard let context = coreDataStack.mainContext else {
            assert(false, "Can't get context in \(#function)")
        }
        guard let conversation = ConversationEntity.findOrInsertConversation(with: conversationID, in: context) else {
            assert(false, "Can't get user \(#function)")
            return
        }
        conversation.hasUnreadMessages = false
        coreDataStack.performSave(context: context, completionHandler: nil)
    }
    
    func saveMessageToMe(userID: String, text: String) {
        saveMessage(messageText: text, fromUser: userID, toUser: self.getAppUserID())
    }
    
    func setAllUsersOffline(completionHandler: @escaping () -> ()) {
        
//        guard let context = coreDataStack.saveContext else {
//            assert(false, "Can't get context in \(#function)")
//        }
//
//        guard let appUser = AppUser.findOrInsertAppUser(in: context),
//            let appUserID = appUser.currentUser?.userID else {
//                completionHandler()
//                return
//        }
//
//        if let allUsers = User.allUsers(inContext: context) {
//            for user in allUsers {
//                guard user.userID != appUserID else { continue }
//                user.isOnline = false
//            }
//        }
//
//        stack.save(context: context, completionHandler: { success in
//            guard success else {
//                assertionFailure()
//                return
//            }
//            completionHandler()
//        })
    }
    
    func getUserName(userID: String) -> String {
        
        guard let context = coreDataStack.mainContext else {
            assert(false, "Can't get context in \(#function)")
        }
        
        guard let user = User.findOrInsertUser(with: userID, in: context) else {
            return "Noname"
        }
        return user.name ?? "Noname"
    }
    
    func saveMessageFromMe(userID: String, text: String) {
        saveMessage(messageText: text, fromUser: self.getAppUserID(), toUser: userID)
    }
    
    func getAppUserID() -> String {
        guard let context = coreDataStack.mainContext else {
            assert(false, "Can't get context in \(#function)")
        }
        guard let appUser = AppUser.findOrInsertAppUser(in: context) else {
            return UIDevice.current.identifierForVendor?.uuidString ?? "volodin"
        }
        guard let userID = appUser.currentUser?.userID else {
            return UIDevice.current.identifierForVendor?.uuidString ?? "volodin"
        }
        return userID
    }
    
    func generateMessageId() -> String? {
        let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string
    }
    
    func saveMessage(messageText: String, fromUser: String, toUser: String) {
        
        guard let context = coreDataStack.mainContext else {
            assert(false, "Can't get context in \(#function)")
        }
        
        let appUserID = getAppUserID()
        
        let recieverID: String
        if appUserID == fromUser {
            recieverID = toUser
        }
        else {
            recieverID = fromUser
        }
        
        guard let messageID = generateMessageId() else {
            return
        }
        guard let sender = User.findOrInsertUser(with: fromUser, in: context),
            let message = MessageEntity.insertMessage(id: messageID, inContext: context),
            let conversation = ConversationEntity.findOrInsertConversation(with: recieverID, in: context) else {
                assert(false, "Error in \(#function)")
                return
        }
        
        message.text = messageText
        message.sender = sender
        
        message.conversation = conversation
        message.lastMessageInConversation = conversation
        
        let hasUnreadMessagesFlag = fromUser == appUserID
        conversation.hasUnreadMessages = !hasUnreadMessagesFlag
        
        coreDataStack.performSave(context: context, completionHandler: nil)
//        delegate?.update()
    }
//


//
//    private func save(message: MessageElement, userID: String) {
//        if let ind = converationList.index(where: {$0.userID == userID}) {
//            converationList[ind].addMessage(message: message)
//
//            delegate?.conversationChanged(conversation: converationList[ind])
//            conversation?.updateConversation(withMessage: message)
//        } else {
//            print("get unknown message!!!!!!")
//        }
//    }
}

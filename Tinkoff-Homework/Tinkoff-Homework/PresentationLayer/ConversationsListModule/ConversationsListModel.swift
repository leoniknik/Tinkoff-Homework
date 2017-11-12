//
//  ConversationsListModel.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 31.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation

protocol IConversationsListModel {
    weak var delegate : IConversationsListModelDelegate? {get set}
    var conversationOnlineList: [ConversationElement] {get set}
    var conversationOfflineList: [ConversationElement] {get set}
}

protocol IConversationsListModelDelegate : class {
    func updateConversationsList()
}

class ConversationsListModel: IConversationsListModel, ICommunicationManagerDelegate {
    
    var conversationOnlineList = [ConversationElement]()
    var conversationOfflineList = [ConversationElement]()
    
    var communicationManager : ICommunicationManager
    weak var delegate : IConversationsListModelDelegate?
    
    init(communicationManager: ICommunicationManager) {
        self.communicationManager = communicationManager
    }
    
    func setupConversations(_ conversations: [ConversationElement]){
        
        conversationOnlineList.removeAll()
        conversationOfflineList.removeAll()
        
        var onWith = [ConversationElement]()
        var onWithout = [ConversationElement]()
        var offWith = [ConversationElement]()
        var offWithout = [ConversationElement]()
        
        for conversation in conversations{
            if(conversation.online){
                if(conversation.messages.count>0){
                    onWith.append(conversation)
                }else{
                    onWithout.append(conversation)
                }
            }else{
                if(conversation.messages.count>0){
                    offWith.append(conversation)
                }else{
                    offWithout.append(conversation)
                }
            }
        }
        
        onWith.sort{$0.messages.last?.date ?? Date() < $1.messages.last?.date ?? Date()}
        offWith.sort{$0.messages.last?.date ?? Date() < $1.messages.last?.date ?? Date()}
        
        onWithout.sort{$0.name<$1.name}
        offWithout.sort{$0.name<$1.name}
        
        self.conversationOnlineList = onWith
        self.conversationOnlineList.append(contentsOf: onWithout)
        
        self.conversationOfflineList = offWith
        self.conversationOfflineList.append(contentsOf: offWithout)
        
    }
    
    func updateConversationsList() {
        getConversations()
        delegate?.updateConversationsList()
    }
    
    func updateCurrentConversation() {
        
    }
    
    func getConversations() {
        let conversations = communicationManager.getConversations()
        setupConversations(conversations)
    }
}

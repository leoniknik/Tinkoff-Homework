//
//  ConversationsListModel.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 31.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation

protocol IConversationsListModel : class {
    var communicationManager : CommunicationManager {get set}
    var delegate : IConversationsListModelDelegate? {get set}
    func getConversations()
}

protocol IConversationsListModelDelegate : class {
    func setupDialogs(allConversatios: [ConversationElement])
}

class ConversationsListModel:IConversationsListModel{
    var communicationManager : CommunicationManager
    var delegate : IConversationsListModelDelegate?
    
    init() {
        self.communicationManager = rootAssembly.communicationManager
    }
    
    func getConversations() {
        delegate?.setupDialogs(allConversatios:communicationManager.getConversations())
    }
}

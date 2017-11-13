//
//  RootAssembly.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 31.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

class RootAssembly {
    
    private let communicationManager: ICommunicationManager
    
    init() {
        let multipeerCommunicator = MultipeerCommunicator()
        let manager = CommunicationManager(multipeerCommunicator: multipeerCommunicator, conversationStorage: ConversationStorageManager(coreDataStack: coreDataStack) )
        communicationManager = manager
        multipeerCommunicator.delegate = manager
    }
    
    lazy var conversationsListAssembly: ConversationsListAssembly = {
        let conversationsListAssembly = ConversationsListAssembly(rootAssembly: self, manager: communicationManager)
        return conversationsListAssembly
    }()
    
    lazy var conversationAssembly: ConversationAssembly = {
        let communicationAssembly = ConversationAssembly(manager: communicationManager)
        return communicationAssembly
    }()
    
    lazy var profileAssembly: ProfileAssembly = {
        return ProfileAssembly(coreDataStack: coreDataStack)
    }()
    
    var coreDataStack: CoreDataStack = {
        return CoreDataStack()
    }()
    
}

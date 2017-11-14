//
//  RootAssembly.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 31.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

class RootAssembly {
    
    private let communicationManager: ICommunicationManager
    private let conversationStorage: ConversationStorageManager
    
    init() {
        let multipeerCommunicator = MultipeerCommunicator()
        conversationStorage = ConversationStorageManager(coreDataStack: coreDataStack)
        let manager = CommunicationManager(multipeerCommunicator: multipeerCommunicator, conversationStorage: conversationStorage )
        communicationManager = manager
        multipeerCommunicator.delegate = manager
    }
    
    lazy var conversationsListAssembly: ConversationsListAssembly = {
        let conversationsListAssembly = ConversationsListAssembly(rootAssembly: self, manager: communicationManager)
        return conversationsListAssembly
    }()
    
    lazy var conversationAssembly: ConversationAssembly = {
        let conversationAssembly = ConversationAssembly(manager: communicationManager, dataStorage: conversationStorage)
        return conversationAssembly
    }()
    
    lazy var profileAssembly: ProfileAssembly = {
        return ProfileAssembly(coreDataStack: coreDataStack)
    }()
    
    var coreDataStack: CoreDataStack = {
        return CoreDataStack()
    }()

    
}

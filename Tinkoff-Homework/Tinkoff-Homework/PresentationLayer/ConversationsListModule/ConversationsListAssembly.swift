//
//  ConversationsListAssembly.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 31.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation

class ConversationsListAssembly {
    
    private var communicationManager: ICommunicationManager
    private var rootAssembly: RootAssembly
    
    init(rootAssembly: RootAssembly, manager: ICommunicationManager) {
        self.communicationManager = manager
        self.rootAssembly = rootAssembly
    }
    
    func conversationsListViewController() -> ConversationsListViewController {
        
        let model = ConversationsListModel(communicationManager: communicationManager)
        communicationManager.listDelegate = model
        
        let viewController = ConversationsListViewController(rootAssembly: rootAssembly, model: model)
        viewController.model = model
        model.delegate = viewController
        
        return viewController
    }
    
}

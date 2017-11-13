//
//  ConversationViewControllerAssembler.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 31.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation

class ConversationAssembly {
    
    private var communicationManager: ICommunicationManager
    
    init(manager: ICommunicationManager) {
        self.communicationManager = manager
    }
    
    func conversationViewController() -> ConversationViewController {
        
        var manager = communicationManager
        let model = ConversationModel(communicationManager: communicationManager)
        manager.conversationDelegate = model
        
        let controller = ConversationViewController(model: model)
        model.delegate = controller
        
        return controller
    }
}

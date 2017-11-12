//
//  ConversationViewControllerAssembler.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 31.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation

class ConversationAsembler{
    func conversationViewController(userName: String, userID: String, key: Int, communicationManager: ICommunicationManager) -> ConversationViewController {
        
        var manager = communicationManager
        let model = ConversationModel(userName:userName,userID:userID, key:key, communicationManager:communicationManager)
        manager.conversationDelegate = model
        
        let controller = ConversationViewController(model: model)
        model.delegate = controller
        
        return controller
    }
}

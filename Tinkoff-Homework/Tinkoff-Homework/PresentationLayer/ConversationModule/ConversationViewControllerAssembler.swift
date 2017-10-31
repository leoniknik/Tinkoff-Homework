//
//  ConversationViewControllerAssembler.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 31.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation

class ConversationAsembler{
    static func createConversationsViewController(userName:String,userID:String, key: Int)->ConversationViewController{
        let communicationManager = rootAssembly.communicationManager
        let model = ConversationModel(userName:userName,userID:userID, key:key, communicationManager:communicationManager)
        let controller = ConversationViewController(model:model)
        model.delegate = controller
        communicationManager.conversationDelegate = controller
        return controller
    }
}

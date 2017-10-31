//
//  ConversationsListAssembly.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 31.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation

class ConversationsListAssembly {
    static func conversationsListViewController()-> ConversationsListViewController{
        
        let manager = rootAssembly.communicationManager
        let model = ConversationsListModel()
        
        let viewController = ConversationsListViewController(model: model)
        viewController.model = model as ConversationsListModel
        model.delegate = viewController
        
        manager.listDelegate = viewController
        
        return viewController
    }
}

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
    var dataStorage: IConversationStorageManager
    
    init(manager: ICommunicationManager, dataStorage: IConversationStorageManager) {
        self.communicationManager = manager
        self.dataStorage = dataStorage
    }
    
    func conversationViewController(conversationID: String) -> ConversationViewController {
        
        let conversationManager = ConversationManager(communicator: communicationManager.communicator, storage: dataStorage, conversationID: conversationID)
        
        let model = ConversationModel(communicationManager: communicationManager, conversationManager: conversationManager, conversationID: conversationID)
        communicationManager.conversationDelegate = model
        
        let controller = ConversationViewController(model: model)
        model.delegate = controller
        
        return controller
    }
}


//    var dataStorage: ConversationManager

//    init(with storage: ConversationStorage) {
//        self.dataStorage = storage
//    }
//
//    func setup(inViewController vc: ConversationViewController, communicationService: ICommunicationService, conversationID: String) {
//        let model = conversationModel(communicationService: communicationService, dataStorage: dataStorage, conversationID: conversationID)
//        vc.model = model
//        model.delegate = vc
//    }
//
//    private func conversationModel(communicationService: ICommunicationService, dataStorage: ConversationStorage, conversationID: String) -> IConversationModel {
//        let service = conversationSercive(communicator: communicationService.communicator, storage: dataStorage, conversationID: conversationID)
//        let conversationModel = ConversationModel.init(communicationService: communicationService, conversationService:service, conversationID: conversationID)
//        communicationService.conversation = conversationModel
//        service.delegate = conversationModel
//
//        return conversationModel
//    }
//
//    private func conversationSercive(communicator: ICommunicator, storage: ConversationStorage, conversationID: String) -> ConversationService {
//        return ConversationService.init(communicator: communicator, storage: storage, conversationID: conversationID)
//    }

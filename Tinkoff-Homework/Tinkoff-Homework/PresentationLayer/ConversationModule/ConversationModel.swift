//
//  ConversationViewControllerModel.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 31.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation

protocol IConversationModelDelegate: class {
    func setupDialog(dialog:ConversationElement)
}

protocol IConversationModel{
    var communicationManager: ICommunicationManager {get set}

    weak var delegate: IConversationModelDelegate? {get set}
    
    func getDialog()
    func updateUnread()
    func sendMessage(string: String, to: String)
}

class ConversationModel: IConversationModel, ICommunicationManagerDelegate {
    
    func updateConversationsList() {
        
    }
    
    func updateCurrentConversation() {
        
    }
    
    
    var communicationManager: ICommunicationManager
//    var userName:String
//    var userID:String
    weak var delegate: IConversationModelDelegate?
//    var key: Int
    
    init(communicationManager: ICommunicationManager) {
        self.communicationManager = communicationManager
    }

    
//    init(userName:String,userID:String, key: Int, communicationManager: ICommunicationManager) {
//        self.userID=userID
//        self.userName=userName
//        self.communicationManager = communicationManager
//        self.key = key
//    }
    
    func getDialog(){
//        let item = communicationManager.getConversation(key: key)
//        delegate?.setupDialog(dialog: item)
    }
    
    func updateUnread(){
//        let item = communicationManager.getConversation(key: key)
//        item.hasUnreadMessages = false
    }
    
    func sendMessage(string: String, to: String){
//        communicationManager.multipeerCommunicator.sendMessage(string: string, to: to, completionHandler: nil) не
        
        
//        communicationManager.communicator.sendMessage(string: string, to: to, completionHandler: nil)
    }
    
    
}


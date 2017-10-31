//
//  ConversationViewControllerModel.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 31.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation

protocol ConversationModelDelegate{
    func setupDialog(dialog:ConversationElement)
}

protocol IConversationModel{
    var communicationManager:CommunicatorDelegate {get set}
    var userName:String {get set}
    var userID:String {get set}
    var delegate:ConversationModelDelegate? {get set}
    var key: Int {get set}
    
    func getDialog()
    func updateUnread()
    func sendMessage(string: String, to: String)
}

class ConversationModel:IConversationModel{
    
    var communicationManager:CommunicatorDelegate
    var userName:String
    var userID:String
    var delegate:ConversationModelDelegate?
    var key: Int
    
    init(userName:String,userID:String, key: Int, communicationManager:CommunicatorDelegate) {
        self.userID=userID
        self.userName=userName
        self.communicationManager = communicationManager
        self.key = key
    }
    
    func getDialog(){
        let item = communicationManager.getConversation(key: key)
        delegate?.setupDialog(dialog: item)
    }
    
    func updateUnread(){
        let item = communicationManager.getConversation(key: key)
        item.hasUnreadMessages = false
    }
    
    func sendMessage(string: String, to: String){
//        communicationManager.multipeerCommunicator.sendMessage(string: string, to: to, completionHandler: nil)
        communicationManager.communicator.sendMessage(string: string, to: to, completionHandler: nil)
    }
    
    
}


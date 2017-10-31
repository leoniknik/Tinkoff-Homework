//
//  CommunicatorDelegate.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 22.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation

protocol CommunicatorDelegate : class{
    
    func didFoundUser(userID: String, userName:String?)
    func didLostUser(userID: String)
    func userDidBecome(userID:String,online:Bool)
    
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error:Error)
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String)

}

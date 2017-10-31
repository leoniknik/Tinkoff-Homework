//
//  RootAssembly.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 31.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

let rootAssembly = RootAssembly()

class RootAssembly{
    
    let communicationManager: CommunicationManager
    
    init() {
        let multipeerCommunicator = MultipeerCommunicator()
        self.communicationManager = CommunicationManager(multipeerCommunicator:multipeerCommunicator)
        multipeerCommunicator.delegate = self.communicationManager
    }
    
}

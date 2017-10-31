//
//  Communicator.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 31.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation

protocol ICommunicator {
    func sendMessage(string: String, to userID: String, completionHandler: ((_ sucsess:Bool, _ error: Error?)->())?)
    weak var delegate : CommunicatorDelegate? {get set}
    var online: Bool {get set}
}

//
//  GCDTaskManager.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 31.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation
import UIKit

protocol IProfileStorage {
    
    weak var delegate: IProfileStorageDelegate? {get set}
    func saveProfile(profile: IProfileProtocol)
    func readProfile()
    
}

protocol IProfileStorageDelegate: class {
    func receiveProfile(profile: IProfileProtocol)
    func showErrorAlert()
    func showSucsessAlert()
}


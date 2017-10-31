//
//  GCDTaskManager.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 31.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation
import UIKit

protocol TaskManager {
    var delegate:TaskManagerDelegate? {get set}
    func saveProfile(profile:Profile)
    func readProfile()
}

protocol TaskManagerDelegate{
    func startAnimate()
    func stopAnimate()
    func showErrorAlert(string:String,gcdMode:Bool)
    func showSucsessAlert()
    func receiveProfile(profile:Profile)
}


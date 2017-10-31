//
//  OperationTaskManager.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 16.10.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class OperationTaskManager : AlertManager, TaskManager {
    
    let operationQueue = OperationQueue()
    
    func saveProfile(controller:ProfileViewController) {
        controller.activityIndicator.startAnimating()
        let saveOperation = SaveProfileOperation(profile: controller.profile)
        saveOperation.completionBlock = {
            if let result = saveOperation.result {
                DispatchQueue.main.async() {
                    self.showErrorAlert(error: result, controller: controller, operationTaskManager: self)
                }
            } else {
                DispatchQueue.main.async() {
                    controller.activityIndicator.stopAnimating()
                    self.showSucsessAlert(controller: controller)
                }
            }
            
        }
        operationQueue.addOperation(saveOperation)
        
    }
    
    func readProfile(controller:ProfileViewController) {
        controller.activityIndicator.startAnimating()
        let readOperation = ReadProfileOperation()
        readOperation.completionBlock = {
            guard let profile = readOperation.profile else {
                controller.activityIndicator.stopAnimating()
                return
            }
            DispatchQueue.main.async() {
                controller.profile = profile
                controller.loadDataFromProfile()
                controller.activityIndicator.stopAnimating()
            }
            
        }
        operationQueue.addOperation(readOperation)
    }
    
}

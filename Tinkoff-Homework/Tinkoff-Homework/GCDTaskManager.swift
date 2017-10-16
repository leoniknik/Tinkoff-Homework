//
//  GCDTaskManager.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 16.10.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class GCDTaskManager : AlertManager, TaskManager {
    func saveProfile(controller:ProfileViewController) {
        controller.activityIndicator.startAnimating()
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        queue.async() {
            //let result = controller.profile.saveProfile()
            sleep(5)
            if let result = controller.profile.saveProfile(){
                DispatchQueue.main.async() {
                    self.showErrorAlert(error: result, controller: controller, operationTaskManager: nil)
                }
            }else{
                DispatchQueue.main.async() {
                    controller.activityIndicator.stopAnimating()
                    self.showSucsessAlert(controller: controller)
                }
            }
            
        }
    }
    
    func readProfile(controller:ProfileViewController) {
        controller.activityIndicator.startAnimating()
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async() {
            let profile = Profile.getProfile()
            sleep(5)
            DispatchQueue.main.async() {
                controller.profile = profile
                controller.loadDataFromProfile()
                controller.activityIndicator.stopAnimating()
            }
        }
    }
}

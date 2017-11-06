//
//  GCD.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 31.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation

class GCDTaskManager: IProfileStorage, IProfileLoaderProtocol {
    
    weak var delegate: IProfileStorageDelegate?
    
    func saveProfile(profile: IProfileProtocol) {
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        queue.async() {
            if self.saveProfileToFile(profile: profile) != nil{
                DispatchQueue.main.async() {
                    self.delegate?.showErrorAlert()
                }
            }else{
                DispatchQueue.main.async() {
                    self.delegate?.showSucsessAlert()
                }
            }
        }
    }
    
    func readProfile() {
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async() {
            guard let profile = self.readProfileFromFile() else {
                self.delegate?.showErrorAlert()
                return
            }
            DispatchQueue.main.async() {
                self.delegate?.receiveProfile(profile: profile)
            }
        }
    }
    
}

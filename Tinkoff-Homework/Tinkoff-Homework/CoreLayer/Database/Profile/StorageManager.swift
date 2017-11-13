//
//  StorageManager.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 05.11.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit
import CoreData

class StorageManager: IProfileStorage {
    
    weak var delegate: IProfileStorageDelegate?
    
    let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack){
        self.coreDataStack = coreDataStack
    }
    
    func saveProfile(profile: IProfileProtocol) {
        guard let context = coreDataStack.saveContext else {
            delegate?.showErrorAlert()
            return
        }

        guard let appUser = AppUser.findOrInsertAppUser(in: context) else {
            delegate?.showErrorAlert()
            return
        }
        guard let user = appUser.currentUser else {
            delegate?.showErrorAlert()
            return
        }
        
        profile.syncProfile()
        
        user.name = profile.name
        user.info = profile.info
        if let avatar = profile.getAvatarWithDataFormat() {
            user.avatar = avatar
        }
        
        context.perform {
            self.coreDataStack.performSave(context: context) { (result) in
                DispatchQueue.main.async {
                    if result == CoreDataOperationResult.ok {
                        self.delegate?.showSucsessAlert()
                    }
                    else {
                        self.delegate?.showErrorAlert()
                    }
                }
            }
        }
    }
    
    func readProfile() {
        guard let context = coreDataStack.mainContext else {
            DispatchQueue.main.async {
                self.delegate?.showErrorAlert()
            }
            return
        }
        
        context.perform {
            
            guard let appUser = AppUser.findOrInsertAppUser(in: context) else {
                DispatchQueue.main.async {
                    self.delegate?.showErrorAlert()
                }
                return
            }
            guard let user = appUser.currentUser else {
                DispatchQueue.main.async {
                    self.delegate?.showErrorAlert()
                }
                return
            }
            
            var avatar: UIImage?
            if let image = user.avatar {
                avatar = UIImage(data: image as Data)
            }
            
            let defaultProfile = Profile.getDefaultProfile()
            let profile = Profile(name: user.name ?? defaultProfile.name, info: user.info ?? defaultProfile.info, avatar: avatar ?? defaultProfile.avatar, needSave: false)
            
            DispatchQueue.main.async {
                self.delegate?.receiveProfile(profile: profile)
            }
        }
    }

}






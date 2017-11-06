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

extension User {
    
    static func findOrInsertAppUser(with id: String, in context: NSManagedObjectContext) -> User? {
        if let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User {
            user.userID = id
            return user
        }
        
        return nil
    }
    
    static var generatedUserIdString: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? "volodin"
    }
}

extension AppUser {
    
    static func findOrInsertAppUser(in context: NSManagedObjectContext) -> AppUser? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            assertionFailure("Model is not available in context")
            return nil
        }
        var appUser: AppUser?
        guard let fetchRequest = AppUser.fetchRequest(withModel: model) else {
            return nil
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple AppUsers found")
            if let foundUser = results.first {
                appUser = foundUser
            }
        } catch {
            print("Failed to fetch AppUser: \(error.localizedDescription)")
        }
        
        if appUser == nil {
            appUser = AppUser.insertAppUser(in: context)
        }
        
        return appUser
    }
    
    static func insertAppUser(in context: NSManagedObjectContext) -> AppUser? {
        if let appUser = NSEntityDescription.insertNewObject(forEntityName: "AppUser", into: context) as? AppUser {
            if appUser.currentUser == nil {
                let currentUser = User.findOrInsertAppUser(with: User.generatedUserIdString, in: context)
                currentUser?.name = "volodin"
                appUser.currentUser = currentUser
            }
            return appUser
        }
        
        return nil
    }
    
    static func fetchRequest(withModel model: NSManagedObjectModel) -> NSFetchRequest<AppUser>? {
        let templateName = "AppUserRequest"
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<AppUser> else {
            assertionFailure("No template with name: \(templateName)")
            return nil
        }
        
        return fetchRequest
    }
    
    
}


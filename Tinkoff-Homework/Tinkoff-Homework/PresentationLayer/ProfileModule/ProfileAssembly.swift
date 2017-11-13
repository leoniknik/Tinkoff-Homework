//
//  ProfileAssembly.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 31.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation

class ProfileAssembly {
    
    private var coreDataStack: CoreDataStack
    private var rootAssembly: RootAssembly
    
    init(rootAssembly: RootAssembly, coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.rootAssembly = rootAssembly
    }
    
    func profileViewController() -> ProfileViewController {
        var profileService = self.profileService()
        let model = ProfileModel(profileService: profileService)
        profileService.delegate = model
        let controller = ProfileViewController(model: model)
        model.delegate = controller
        return controller
    }

    private func profileService() -> IProfileService {
        var gcdTaskManager = self.gcdTaskManager()
        var operationTaskManager = self.operationTaskManager()
        var storageManager = self.storageManager()
        
        let profileService = ProfileService(gcdTaskManager: gcdTaskManager, operationTaskManager: operationTaskManager, storageManager: storageManager)
        
        gcdTaskManager.delegate = profileService
        operationTaskManager.delegate = profileService
        storageManager.delegate = profileService
        
        return profileService
    }

    private func storageManager() -> IProfileStorage {
        return StorageManager(coreDataStack: coreDataStack)
    }
    
    private func gcdTaskManager() -> IProfileStorage {
        return GCDTaskManager()
    }

    private func operationTaskManager() -> IProfileStorage {
        return OperationTaskManager()
    }
    
}


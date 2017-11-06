//
//  ProfileManager.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 31.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

protocol IProfileService {

    weak var delegate: IProfileServiceDelegate? {get set}
    var profileManager: ProfileManagerType {get set}
    
    func getDefaultProfile() -> IProfileProtocol
    func read()
    func save(profile: IProfileProtocol)
}

protocol IProfileServiceDelegate: class {
    func receiveProfile(profile: IProfileProtocol)
    func showErrorAlert()
    func showSuccessAlert()
}

class ProfileService: IProfileService, IProfileStorageDelegate {
    
    private let gcdTaskManager: IProfileStorage
    private let operationTaskManager: IProfileStorage
    private let storageManager: IProfileStorage
    
    weak var delegate: IProfileServiceDelegate?
    
    var profileManager: ProfileManagerType
    
    init(gcdTaskManager: IProfileStorage, operationTaskManager: IProfileStorage, storageManager: IProfileStorage) {
        self.gcdTaskManager = gcdTaskManager
        self.operationTaskManager = operationTaskManager
        self.storageManager = storageManager
        self.profileManager = .CoreDataManager
    }
    
    func getDefaultProfile() -> IProfileProtocol {
        return Profile.getDefaultProfile()
    }
    
    func read() {
        switch profileManager {
        case .CoreDataManager:
            storageManager.readProfile()
        case .GCDManager:
            gcdTaskManager.readProfile()
        case .OperationManager:
            operationTaskManager.readProfile()
        }
    }

    func save(profile: IProfileProtocol) {
        switch profileManager {
        case .CoreDataManager:
            storageManager.saveProfile(profile: profile)
        case .GCDManager:
            gcdTaskManager.saveProfile(profile: profile)
        case .OperationManager:
            operationTaskManager.saveProfile(profile: profile)
        }
    }
    
    func receiveProfile(profile: IProfileProtocol) {
        delegate?.receiveProfile(profile: profile)
    }
    
    func showErrorAlert() {
        delegate?.showErrorAlert()
    }
    
    func showSucsessAlert() {
        delegate?.showSuccessAlert()
    }
}

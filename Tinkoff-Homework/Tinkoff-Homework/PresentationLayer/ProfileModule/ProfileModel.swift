//
//  ProfileViewControllerModel.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 31.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

protocol IProfileModel {
    var profile: IProfileProtocol {get set}
    weak var delegate: IProfileModelDelegate? {get set}
    var profileService: IProfileService {get set}
    var profileManager: ProfileManagerType {get set}
    func readProfile()
    func saveProfile()
}

protocol IProfileModelDelegate: class {
    func update()
    func showErrorAlert()
    func showSuccessAlert()
}

enum ProfileManagerType {
    case CoreDataManager
    case GCDManager
    case OperationManager
}

class ProfileModel : IProfileModel, IProfileServiceDelegate {

    var profile: IProfileProtocol
    
    var profileService: IProfileService
    
    weak var delegate: IProfileModelDelegate?
    
    var profileManager: ProfileManagerType {
        didSet {
            profileService.profileManager = profileManager
        }
    }
    
    init(profileService: IProfileService) {
        self.profileService = profileService
        self.profileManager = .CoreDataManager
        self.profile = profileService.getDefaultProfile()
    }

    func saveProfile() {
        profileService.save(profile: profile)
    }
    
    func readProfile() {
        profileService.read()
    }

    func showErrorAlert() {
        delegate?.showErrorAlert()
    }

    func showSuccessAlert() {
        delegate?.showSuccessAlert()
    }

    func receiveProfile(profile: IProfileProtocol) {
        self.profile = profile
        delegate?.update()
    }

}

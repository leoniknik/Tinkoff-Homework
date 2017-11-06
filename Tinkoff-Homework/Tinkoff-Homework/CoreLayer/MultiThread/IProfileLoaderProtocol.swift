//
//  IProfileLoaderProtocol.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 05.11.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

protocol IProfileLoaderProtocol {
    func readProfileFromFile() -> IProfileProtocol?
    func saveProfileToFile(profile: IProfileProtocol) -> String?
}

extension IProfileLoaderProtocol {
    
    func readProfileFromFile() -> IProfileProtocol? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("profile.prf")
        if let simpleData:Data = try? Data(contentsOf: fileURL) {
            let decodedData = NSKeyedUnarchiver.unarchiveObject(with: simpleData)
            if let profile = decodedData as? Profile{
                return profile
            }
        }
        return nil
    }
    
    func saveProfileToFile(profile: IProfileProtocol) -> String? {

        profile.syncProfile()
        
        if let fileURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("profile.prf") {
            do {
                let data = NSKeyedArchiver.archivedData(withRootObject: profile)
                try data.write(to: fileURL)
                return nil
            } catch let error {
                print(error.localizedDescription)
                return error.localizedDescription
            }
        }
        return "can't get path"
    }
}

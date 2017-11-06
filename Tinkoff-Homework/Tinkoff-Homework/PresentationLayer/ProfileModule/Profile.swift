//
//  Profile.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 05.11.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

protocol IProfileProtocol : class {
    var name: String {get set}
    var newName: String {get set}
    var info: String {get set}
    var newInfo: String {get set}
    var avatar: UIImage {get set}
    var newAvatar: UIImage {get set}
    var needSave: Bool {get set}
    func getAvatarWithDataFormat() -> Data?
    func syncProfile()
    static func getDefaultProfile() -> IProfileProtocol
}

class Profile : NSObject, NSCoding, IProfileProtocol{
    
    var newName: String{
        didSet{
            needSave = (newName != name)
        }
    }
    
    var name: String
    
    var newInfo: String{
        didSet{
            needSave = (newInfo != info)
        }
    }
    var info: String
    
    var newAvatar: UIImage{
        didSet{
            needSave = (imageToBase64ImageString(image: avatar) != imageToBase64ImageString(image: newAvatar))
        }
    }
    
    var avatar: UIImage
    
    var needSave: Bool
    
    static let jpegCompressionQuality: CGFloat = 1
    
    init(name: String, info: String, avatar : UIImage, needSave : Bool) {
        self.name = name
        self.newName = name
        self.info = info
        self.newInfo = info
        self.avatar = avatar
        self.newAvatar = avatar
        self.needSave = needSave
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init(
            name: (aDecoder.decodeObject(forKey: "name") as? String) ?? "name",
            info: (aDecoder.decodeObject(forKey: "info") as? String) ?? "info",
            avatar: Profile.base64ImageStringToUIImage(base64String: (aDecoder.decodeObject(forKey: "avatar") as? String) ?? "avatar"),
            needSave: false
        )
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(info, forKey: "info")
        aCoder.encode(imageToBase64ImageString(image: avatar), forKey: "avatar")
    }
    
    static func base64ImageStringToUIImage(base64String:String) -> UIImage {
        let dataDecoded : Data = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters) ?? Data()
        return UIImage(data: dataDecoded) ?? UIImage()
    }
    
    func imageToBase64ImageString(image:UIImage) -> String {
        return (UIImageJPEGRepresentation(image, Profile.jpegCompressionQuality)?.base64EncodedString()) ?? "string"
    }
    
    func getAvatarWithDataFormat() -> Data? {
        return UIImageJPEGRepresentation(avatar, Profile.jpegCompressionQuality)
    }
    
    func syncProfile() {
        needSave = false
        avatar = newAvatar
        name = newName
        info = newInfo
    }
    
    static func getDefaultProfile() -> IProfileProtocol {
        return Profile(name: "",info: "",avatar: UIImage.init(named: "placeholder-user") ?? UIImage(),needSave: false)
    }
}

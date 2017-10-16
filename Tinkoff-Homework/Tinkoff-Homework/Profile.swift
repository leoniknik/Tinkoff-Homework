//
//  Profile.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 16.10.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

protocol ProfileProtocol : class{
    var name: String {get set}
    var info: String {get set}
    var avatar: UIImage {get set}
    var needSave: Bool {get set}
}

class Profile : NSObject, NSCoding, ProfileProtocol{
    
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
    
    public static func getProfile()->Profile{
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("profile.prf")
        if let simpleData:Data = try? Data(contentsOf: fileURL) {
            let decodedData = NSKeyedUnarchiver.unarchiveObject(with: simpleData)
            if let profile = decodedData as? Profile{
                return profile
            }
        }
        return Profile(name: "",info: "",avatar: UIImage.init(named: "placeholder-user")!,needSave: false)
    }
    
    static func getEmptyProfile()->Profile{
        return Profile(name: "",info: "",avatar: UIImage.init(named: "placeholder-user")!,needSave: false)
    }
    
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
            name: aDecoder.decodeObject(forKey: "name") as! String,
            info: aDecoder.decodeObject(forKey: "info") as! String,
            avatar: Profile.base64ImageStringToUIImage(base64String: aDecoder.decodeObject(forKey: "avatar") as! String),
            needSave: false
        )
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(info, forKey: "info")
        aCoder.encode(imageToBase64ImageString(image: avatar), forKey: "avatar")
    }
    
    static func base64ImageStringToUIImage(base64String:String)->UIImage{
        let dataDecoded : Data = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters)!
        return UIImage(data: dataDecoded)!
    }
    
    func imageToBase64ImageString(image:UIImage)->String{
        let jpegCompressionQuality: CGFloat = 1
        return (UIImageJPEGRepresentation(image, jpegCompressionQuality)?.base64EncodedString())!
    }
    
    func saveProfile()->String?{
        self.needSave = false
        
        avatar = newAvatar
        name = newName
        info = newInfo
        
        if let fileURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("profile.prf"){
            do {
                let data = NSKeyedArchiver.archivedData(withRootObject: self)
                try data.write(to: fileURL)
                if( Int(arc4random_uniform(2))==1){
                    return nil
                    
                }else{
                    return "generated error"
                    
                }
            } catch let error {
                print(error.localizedDescription)
                return error.localizedDescription
            }
        }
        return "can't get path"
    }
}


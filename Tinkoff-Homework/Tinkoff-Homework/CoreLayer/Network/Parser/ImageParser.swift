//
//  ImageParser.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 21.11.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

struct ImageModel {
    var image: UIImage
}

class ImageParser: Parser<ImageModel> {
    
    override func parse(data: Data) -> ImageModel? {
        
        if let image = UIImage(data: data) {
            return ImageModel(image: image)
        }
        
        return nil
    }
}

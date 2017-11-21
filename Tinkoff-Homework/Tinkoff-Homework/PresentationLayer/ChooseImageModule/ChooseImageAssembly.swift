//
//  ChooseImageAssembly.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 20.11.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation

class ChooseImageAssembly {
    
    func chooseImageViewController(presenter: ProfileViewController) -> ChooseImageViewController {
        let requestSender = RequestSender()
        
        let imageService = ImageService(requestSender: requestSender)
        let model = ChooseImageModel(imageService: imageService)
//        imageService.delegate = model
        
        let viewcontroller = ChooseImageViewController(model: model, presenter: presenter)
        model.delegate = viewcontroller
        return viewcontroller
    }
    
}

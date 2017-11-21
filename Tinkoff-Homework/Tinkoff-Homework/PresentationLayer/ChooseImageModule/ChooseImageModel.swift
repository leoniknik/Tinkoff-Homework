//
//  ChooseImageModel.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 20.11.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

protocol IChooseImageModel {
    
    weak var delegate: IChooseImageModelDelegate? {get set}
    
    func getImages()
    func getImage(forItem: Int, completion: @escaping (UIImage) -> ())
    func getNumberOfItems() -> Int
}

protocol IChooseImageModelDelegate: class {
    func update()
}

class ChooseImageModel: IChooseImageModel {
    
    weak var delegate: IChooseImageModelDelegate?
    
    var service: IImageServiceProtocol
    var urls = [ListOfImagesModel]()
    let portion: Int = 50
    
    init(imageService: IImageServiceProtocol) {
        self.service = imageService
    }
    
    func getImages() {
        service.getImagesListFor(portion: getNextPortion(), completion: {[weak self] (urls) in
            self?.urls.append(contentsOf: urls)
            self?.delegate?.update()
        })
    }
    
    func getNextPortion() -> Int {
        return urls.count / portion + 1
    }

//    func updateUrlsList(urls: [String]) {
//        self.urls.append(contentsOf: urls)
//    }
    
    func getImage(forItem item: Int, completion: @escaping (UIImage) -> ()) {
        let url = urls[item].url
        service.getImage(forUrl: url, completion: { (image) in
            guard let image = image else {
                completion(UIImage(named: "placeholder-user") ?? UIImage())
                return
            }
            completion(image.image)
        })
    }
    
    func getNumberOfItems() -> Int {
        return urls.count
    }

}

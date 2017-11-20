//
//  ImageService.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 21.11.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

protocol IImageServiceProtocol {
    weak var delegate: IImageServiceDelegate? {get set}
    func getImagesListFor(portion: Int)
    func getImage(forUrl url: String, completion: @escaping (UIImage?) -> ())
}

protocol IImageServiceDelegate: class {
    func updateUrlsList(urls: [String])
}

class ImageService: IImageServiceProtocol {
    
    var requestSender: IRequestSender
    
    weak var delegate: IImageServiceDelegate?
    
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    func getImage(forUrl url: String, completion: @escaping (UIImage?) -> ()) {
        
    }
    
    func getImagesListFor(portion: Int) {
        
    }
    
    func defaultOnResult<T>(result: Result<T>, completion: @escaping (T) -> ()) {
        switch result {
        case .success(let result):
            completion(result)
        case .error(let error):
            print(error)
        }
    }
}

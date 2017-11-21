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
    func getImagesListFor(portion: Int, completion: @escaping ([ListOfImagesModel]) -> ())
    func getImage(forUrl url: String, completion: @escaping (ImageModel?) -> ())
}

protocol IImageServiceDelegate: class {
    func updateUrlsList(urls: [ListOfImagesModel])
}

class ImageService: IImageServiceProtocol {
    
    var requestSender: IRequestSender
    
    weak var delegate: IImageServiceDelegate?
    
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    func getImage(forUrl url: String, completion: @escaping (ImageModel?) -> ()) {
        let requestConfig = RequestsConfigFactory.imageConfig(url: url)
        
        requestSender.send(config: requestConfig) { (result) in
            self.defaultOnResult(result: result, completion: completion)
        }
    }
    
    func getImagesListFor(portion: Int, completion: @escaping ([ListOfImagesModel]) -> ()) {
        let requestConfig = RequestsConfigFactory.flowersImagesListConfig(page: portion)
        
        requestSender.send(config: requestConfig, completionHandler: { (result) in
            self.defaultOnResult(result: result, completion: completion)
        })
        
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

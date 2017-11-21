//
//  ImageRequest.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 21.11.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation

class ImageRequest: IRequest {
    
    private var url: String
    
    // MARK: - IRequest
    
    var urlRequest: URLRequest? {
        if let url = URL(string: url) {
            return URLRequest(url: url)
        }
        
        return nil
    }
    
    // MARK: - Initialization
    
    init(url: String) {
        self.url = url
    }
    
}

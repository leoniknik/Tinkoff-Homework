//
//  ListOfImagesRequest.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 21.11.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation

class ListOfImagesRequest: IRequest {
    fileprivate var command: String {
        assertionFailure("❌ Should use a subclass of AppleRSSRequest ")
        return ""
    }
    
    private var limitString: String {
        return "&per_page=\(limit)/"
    }
    
    private var secretKeyString: String {
        return "?key=\(secretKey)"
    }
    
    private var page: Int
    private var baseUrl: String = "https://pixabay.com/api/"
    private let secretKey = "7117719-91c3d0c5185ee76f6be1a411d"
    private var limit: Int
    private var requestFormat: String = "json"
    
    // MARK: - IRequest
    var urlRequest: URLRequest? {
        
        var pageParam: String
        
        if page < 2 {
            pageParam = ""
        }
        else {
            pageParam = "&page=\(page)"
        }
        
        let urlString: String = baseUrl + secretKeyString + command + limitString + pageParam
        
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }

        return nil
    }
    
    // MARK: - Initialization
    init(limit: Int = 50, page: Int) {
        self.limit = limit
        self.page = page
    }
}

class FlowersImageListRequest: ListOfImagesRequest {
    override var command: String { return "&q=yellow+flowers&image_type=photo&pretty=true" }
}

//
//  RequestSender.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 21.11.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation

struct RequestConfig<Model> {
    let request: IRequest
    let parser: Parser<Model>
}

enum Result<T> {
    case success(T)
    case error(String)
}

protocol IRequestSender {
    func send<Model>(config: RequestConfig<Model>, completionHandler: @escaping (Result<Model>) -> Void)
}

class RequestSender: IRequestSender {
    
    let session = URLSession.shared

    func send<Model>(config: RequestConfig<Model>, completionHandler: @escaping (Result<Model>) -> Void) {
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(Result.error("ulr can't be parsed to URL"))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                completionHandler(Result.error(error.localizedDescription))
                return
            }
            
            guard let data = data, let parseModel: Model = config.parser.parse(data: data) else {
                completionHandler(Result.error("data can't be parsed"))
                return
            }
            
            completionHandler(Result.success(parseModel))
        }
        
        task.resume()
    }
}

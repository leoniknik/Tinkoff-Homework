//
//  RequestsFactory.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 21.11.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

struct RequestsConfigFactory {
    static func flowersImagesListConfig(page: Int) -> RequestConfig<[ListOfImagesModel]> {
        return RequestConfig<[ListOfImagesModel]>(request: FlowersImageListRequest(page: page), parser: ListOfImagesParser())
    }
    
    static func imageConfig(url: String) -> RequestConfig<ImageModel> {
        return RequestConfig<ImageModel>(request: ImageRequest(url: url), parser: ImageParser())
    }
}

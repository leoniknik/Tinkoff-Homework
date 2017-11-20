//
//  RequestsFactory.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 21.11.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

struct RequestsFactory {
    static func flowersImagesList(page: Int) -> RequestConfig<[UIImage]> { //!!!!
        return RequestConfig<[ImageListModel]>(request: CosmosImageListRequest(pageNumber: page), parser: ImageListParser())
    }
}

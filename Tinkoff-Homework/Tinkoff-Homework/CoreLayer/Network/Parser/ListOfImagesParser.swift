//
//  ListOfImagesParser.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 21.11.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

struct ListOfImagesModel {
    let url: String
    var image: UIImage?
}

class ListOfImagesParser: Parser<[ListOfImagesModel]> {
    override func parse(data: Data) -> [ListOfImagesModel]? {
        do {
            
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
                return nil
            }
            print(json)
            
            guard let hits = json["hits"] as? [[String: AnyObject]] else {
                return nil
            }
            print(hits)
            var urls: [ListOfImagesModel] = []
            
            for hit in hits {
                if let url = hit["webformatURL"] as? String {
                    print(url)
                    urls.append(ListOfImagesModel(url: url, image: nil))
                }
            }
            
            return urls
        } catch {
            print("Error: \(error.localizedDescription)")
            return nil
        }
    }
}

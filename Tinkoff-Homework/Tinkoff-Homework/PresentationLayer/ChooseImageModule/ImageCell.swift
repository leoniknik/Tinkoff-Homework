//
//  ImageCell.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 20.11.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

protocol ImageCellConfiguration: class {
    var image: UIImage? {get set}
}

class ImageCell: UICollectionViewCell, ImageCellConfiguration {
    
    var image: UIImage? {
        didSet (value) {
            imageView.image = value
        }
    }

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

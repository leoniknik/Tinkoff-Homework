//
//  MessageCell.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 31.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell,MessageCellConfiguration {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var message : String?{
        didSet{
            messageLabel.text = message
        }
        
    }
}

protocol MessageCellConfiguration: class {
    var message: String? {get set}
}

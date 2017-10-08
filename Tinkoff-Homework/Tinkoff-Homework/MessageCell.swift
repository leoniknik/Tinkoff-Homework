//
//  MessageCell.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 08.10.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell, MessageCellConfiguration {

    @IBOutlet weak var messageLabel: UILabel!
    
    var message: String? {
        set {
            messageLabel.text = newValue
        }
        get {
            return messageLabel.text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

protocol MessageCellConfiguration: class {
    var message: String? {get set}
}

//
//  ConversationCell.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 08.10.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell, ConversationCellConfiguration {
    
    var name: String? {
        set {
            nameLabel.text = newValue
        }
        get {
            return nameLabel.text
        }
    }
    
    var message: String? {
        set {
            if let value = newValue {
                messageLabel.text = value
                messageLabel.font = UIFont.systemFont(ofSize: 13)
            }
            else {
                messageLabel.text = "No messages yet"
                messageLabel.font = UIFont.italicSystemFont(ofSize: 13)
            }
        }
        get {
            if messageLabel.text == "No messages yet" {
                return nil
            }
            else {
                return messageLabel.text
            }
        }
    }
    
    var date: Date? {
        set {
            if let value = newValue {
                let dateFormatter = DateFormatter()
                let calendar = NSCalendar.autoupdatingCurrent
                if !calendar.isDateInToday(value) {
                    dateFormatter.dateFormat = "dd MMM"
                }
                else {
                    dateFormatter.dateFormat = "HH:MM"
                }
                dateLabel.text = dateFormatter.string(from: value)
            }
            else {
                dateLabel.text = ""
            }
        }
        get {
            return nil
        }
    }
    
    var online: Bool = false {
        didSet {
            if online {
                self.backgroundColor = UIColor(red: 1, green: 1, blue: 200/255, alpha: 1)
            }
            else {
                self.backgroundColor = UIColor.white
            }
        }
    }
    
    var hasUnreadMessages: Bool = false {
        didSet {
            if hasUnreadMessages {
                messageLabel.font = UIFont.boldSystemFont(ofSize: 13)
            }
        }
    }
        
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

protocol ConversationCellConfiguration: class {
    
    var name: String? {get set}
    var message: String? {get set}
    var date: Date? {get set}
    var online: Bool {get set}
    var hasUnreadMessages: Bool {get set}
    
}

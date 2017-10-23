//
//  ConversationViewController.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 08.10.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ConversationsManagerDelegate{

    let conversationManager = ConversationsManager.shared
    var messages : [Message] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
//        messageTextField.delegate = self
        conversationManager.conversationDelegate = self
//        conversationManager.listDelegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
//        NotificationCenter.default.addObserver(self, selector: #selector(refreshDialog), name: .refreshDialog, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.messages = communicationManager!.getDialogMessages(userName: userName!)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        if let conversation = conversationManager.currentConversation {
            navigationItem.title = conversation.name
            messages = conversation.messages
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        conversationManager.forgetCurrentConversation()
    }
    
//    @objc func refreshDialog(_ notification: NSNotification){
//        let dialog = communicationManager!.getChatDialog(userName: userName!)
//        self.messages = dialog.messages
//        DispatchQueue.main.async {
//            self.sendMessageButton.isEnabled = dialog.online
//            self.tableView.reloadData()
//        }
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        if (message.isIncoming) {
            let cell = tableView.dequeueReusableCell(withIdentifier:
                "MessageInCell", for: indexPath) as! MessageCellConfiguration
            cell.message = message.text
            return cell as! UITableViewCell

        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageOutCell", for: indexPath) as! MessageCellConfiguration
            cell.message = message.text
            return cell as! UITableViewCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func updateConversationsList() {
        checkUserOnline()
    }
    
    func updateCurrentConversation() {
        checkUserOnline()
        if let conversation = conversationManager.currentConversation {
            messages = conversation.messages
        }
        tableView.reloadData()

    }
    
    func checkUserOnline() {
        if (conversationManager.currentConversation == nil){
            sendMessageButton.isEnabled = false
        } else {
            sendMessageButton.isEnabled = true
        }
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        messageTextField.resignFirstResponder()
        
        if let str = messageTextField.text {
            if str.count > 0 {
                let message = Message.init(withText: messageTextField.text!, user: UUID().uuidString)
                message?.isIncoming = false
                conversationManager.send(message!)
                messageTextField.text = ""
            }
        }
    }
    
    
    
}

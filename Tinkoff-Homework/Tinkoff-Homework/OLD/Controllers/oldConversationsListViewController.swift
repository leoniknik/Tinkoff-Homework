//
//  ConversationsListViewController.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 07.10.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

//class oldConversationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ConversationsManagerDelegate {
//    
//    func updateCurrentConversation() {
//        print()
//    }
//    
//
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var profileBarItem: UIBarButtonItem!
//    
//    let conversationManager = ConversationsManager.shared
//    
//    var conversationOnlineList = [ConversationElement]()
//    var conversationOfflineList = [ConversationElement]()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.delegate = self
//        tableView.dataSource = self
//        conversationManager.listDelegate = self
////        NotificationCenter.default.addObserver(self, selector: #selector(refreshDialogs), name: .refreshDialog, object: nil)
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        setupUI()
//        tableView.reloadData()
//    }
//    
//    func setupUI() {
//        if let image = UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal) {
//            profileBarItem.image = image
//        }
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return conversationOnlineList.count
//        }
//        else {
//            return conversationOfflineList.count
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell") as! ConversationCellConfiguration
//        let conversation: ConversationElement
//        if indexPath.section == 0 {
//            conversation = conversationOnlineList[indexPath.row]
//        }
//        else {
//            conversation = conversationOfflineList[indexPath.row]
//        }
//        
//        if let message = conversation.messages.last {
//            cell.message = message.text
//        } else {
//            cell.message = "No messages yet"
//        }
//        
//        cell.name = conversation.name
//        cell.date = conversation.lastMessageDate
//        cell.online = conversation.online
//        cell.hasUnreadMessages = conversation.hasUnreadMessages
//        
//        return cell as! UITableViewCell
//        
//    }
//    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            return "Online"
//        }
//        else {
//            return "History"
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 79
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        
//        let conversation = conversationManager.converationList[indexPath.row]
//        conversation.hasUnreadMessages = false
//        performSegue(withIdentifier: "toChat", sender: nil)
//        tableView.deselectRow(at: indexPath, animated: false)
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "toChat" {
//            let destination = segue.destination
//            if let index = tableView.indexPathForSelectedRow {
//                let conversation = conversationManager.converationList[index.row]
//                conversation.hasUnreadMessages = false
//                destination.navigationItem.title = conversation.name
//                (destination as? ConversationViewController)?.userID = conversation.userId
//            }
//        }
//
//    }
//    
//    func updateConversationsList() {
//        getDialogs()
//        tableView.reloadData()
//    }
//    
//    func getDialogs(){
//        
//        conversationOnlineList.removeAll()
//        conversationOfflineList.removeAll()
//        
//        let allDialogs = conversationManager.converationList
//        
//        var onWith = [ConversationElement]()
//        var onWithout = [ConversationElement]()
//        var offWith = [ConversationElement]()
//        var offWithout = [ConversationElement]()
//        
//        for dialog in allDialogs{
//            if(dialog.online){
//                if(dialog.messages.count>0){
//                    onWith.append(dialog)
//                }else{
//                    onWithout.append(dialog)
//                }
//            }else{
//                if(dialog.messages.count>0){
//                    offWith.append(dialog)
//                }else{
//                    offWithout.append(dialog)
//                }
//            }
//        }
//        
//        
//        onWith.sort{$0.messages.last!.date! < $1.messages.last!.date!}
//        offWith.sort{$0.messages.last!.date! < $1.messages.last!.date!}
//        
//        onWithout.sort{$0.name<$1.name}
//        offWithout.sort{$0.name<$1.name}
//        
//        self.conversationOnlineList = onWith
//        self.conversationOnlineList.append(contentsOf: onWithout)
//        
//        self.conversationOfflineList = offWith
//        self.conversationOfflineList.append(contentsOf: offWithout)
//        
//    }
//    
//}


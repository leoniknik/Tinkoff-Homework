//
//  ConversationViewController.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 31.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CommunicationManagerDelegate, IConversationsListModelDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    
    var model : IConversationsListModel
    
    
    init(model: IConversationsListModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    
    var conversationOnlineList = [ConversationElement]()
    var conversationOfflineList = [ConversationElement]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationItem()
//        navigationController.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(Add:)] autorelease];
    }
    
    func setupNavigationItem() {
        
        let profileButton: UIBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goToProfile))
        
        self.navigationItem.rightBarButtonItem = profileButton
        if let image = UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal) {
            profileButton.image = image
        }
        
    }

    @objc func goToProfile() {
        self.present(ProfileViewControllerAssembler.createProfileViewControllerAssembler(), animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        setupUI()
        tableView.reloadData()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ConversationCell", bundle: nil), forCellReuseIdentifier: "ConversationCell")
    }
    
    func updateCurrentConversation() {
        print()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return conversationOnlineList.count
        }
        else {
            return conversationOfflineList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell") as! ConversationCellConfiguration
        let conversation: ConversationElement
        if indexPath.section == 0 {
            conversation = conversationOnlineList[indexPath.row]
        }
        else {
            conversation = conversationOfflineList[indexPath.row]
        }
        
        if let message = conversation.messages.last {
            cell.message = message.text
        } else {
            cell.message = "No messages yet"
        }
        
        cell.name = conversation.name
        cell.date = conversation.lastMessageDate
        cell.online = conversation.online
        cell.hasUnreadMessages = conversation.hasUnreadMessages
        
        return cell as! UITableViewCell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Online"
        }
        else {
            return "History"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 79
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if let index = tableView.indexPathForSelectedRow {
            let conversation = model.communicationManager.converationList[index.row]
            conversation.hasUnreadMessages = false
            let controller = ConversationAsembler.createConversationsViewController(userName: conversation.name, userID: conversation.userId, key: index.row)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func updateConversationsList() {
        model.getConversations()
        tableView.reloadData()
    }
    
    func setupDialogs(allConversatios allDialogs: [ConversationElement]){
        
        conversationOnlineList.removeAll()
        conversationOfflineList.removeAll()
        
        var onWith = [ConversationElement]()
        var onWithout = [ConversationElement]()
        var offWith = [ConversationElement]()
        var offWithout = [ConversationElement]()
        
        for dialog in allDialogs{
            if(dialog.online){
                if(dialog.messages.count>0){
                    onWith.append(dialog)
                }else{
                    onWithout.append(dialog)
                }
            }else{
                if(dialog.messages.count>0){
                    offWith.append(dialog)
                }else{
                    offWithout.append(dialog)
                }
            }
        }
        
        onWith.sort{$0.messages.last?.date ?? Date() < $1.messages.last?.date ?? Date()}
        offWith.sort{$0.messages.last?.date ?? Date() < $1.messages.last?.date ?? Date()}
        
        onWithout.sort{$0.name<$1.name}
        offWithout.sort{$0.name<$1.name}
        
        self.conversationOnlineList = onWith
        self.conversationOnlineList.append(contentsOf: onWithout)
        
        self.conversationOfflineList = offWith
        self.conversationOfflineList.append(contentsOf: offWithout)
        
    }
    
    
}


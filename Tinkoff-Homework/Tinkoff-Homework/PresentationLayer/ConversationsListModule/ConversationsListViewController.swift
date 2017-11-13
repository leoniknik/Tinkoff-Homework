//
//  ConversationViewController.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 31.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, IConversationsListModelDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var rootAssembly: RootAssembly
    var model : IConversationsListModel
    
    init(rootAssembly: RootAssembly, model: IConversationsListModel) {
        self.model = model
        self.rootAssembly = rootAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateConversationsList()
    }
    
    func setupNavigationItem() {
        
        let profileButton: UIBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goToProfile))
        
        self.navigationItem.rightBarButtonItem = profileButton
        if let image = UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal) {
            profileButton.image = image
        }
        
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ConversationCell", bundle: nil), forCellReuseIdentifier: "ConversationCell")
    }

    @objc func goToProfile() {
        let assembly = rootAssembly.profileAssembly
        let controller = assembly.profileViewController()
        self.present(controller, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return model.conversationOnlineList.count
        }
        else {
            return model.conversationOfflineList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell") as! ConversationCellConfiguration
        let conversation: ConversationElement
        if indexPath.section == 0 {
            conversation = model.conversationOnlineList[indexPath.row]
        }
        else {
            conversation = model.conversationOfflineList[indexPath.row]
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
    
//        if let index = tableView.indexPathForSelectedRow {
//            let conversation = model.communicationManager.converationList[index.row]
//            conversation.hasUnreadMessages = false
//            let controller = ConversationAsembler.createConversationsViewController(userName: conversation.name, userID: conversation.userId, key: index.row)
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
//        
//        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func updateConversationsList() {
        tableView.reloadData()
    }
    
    
}


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
        tableView.reloadData()
    }
    
    func setupNavigationItem() {
        
        let profileButton: UIBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goToProfile))
        
        self.navigationItem.rightBarButtonItem = profileButton
        if let image = UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal) {
            profileButton.image = image
        }
        
    }
    
    func setupTableView() {
        model.initFetchedResultsManagerFor(tableView: tableView)
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
        return model.numberOfSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(model.numberOfRowsIn(section: section))
        return model.numberOfRowsIn(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell") as! ConversationCellConfiguration
        
        if let conversation = model.getConversation(indexPath: indexPath) {

        if let message = conversation.message {
            cell.message = message
        } else {
            cell.message = "No messages yet"
        }
        
        cell.name = conversation.name
        cell.date = conversation.lastMessageDate
        print(conversation.online)
        cell.online = conversation.online
        cell.hasUnreadMessages = conversation.hasUnreadMessages
            
        }
        
        return cell as! UITableViewCell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.getNameForSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 79
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if let index = tableView.indexPathForSelectedRow {
            if let conversation = model.getConversation(indexPath: index),
                let id = conversation.id {
//               rootAssembly.conversationModule.setup(inViewController: conversationVC, communicationService: communicationService, conversationID: id)
                rootAssembly
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func updateConversationsList() {

    }
    
    
}


//
//  ConversationViewController.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 31.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, IConversationModelDelegate {
    
    func userWentOffline() {
        
    }
    
    func setup(dataSource: [Message]) {
        
    }
    
//    var messages:[Message] = [Message]()
    
    var model: IConversationModel
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var messageText: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    init(model: IConversationModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = model.userName
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setupTableView() {
        model.initFetchedResultsManagerFor(tableView: table)
        self.table.register(UINib.init(nibName: "IncomeMessageCell", bundle: nil), forCellReuseIdentifier: "IncomeMessageCell")
        self.table.register(UINib.init(nibName: "OutcomeMessageCell", bundle: nil), forCellReuseIdentifier: "OutcomeMessageCell")
        self.table.delegate = self
        self.table.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfRowsIn(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = model.getConversation(indexPath: indexPath)
        
        var cellIdentifier: String
        if message.isIncoming {
            cellIdentifier = "IncomeMessageCell"
        }
        else {
            cellIdentifier = "OutcomeMessageCell"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MessageCellConfiguration
        
        cell.message = message.text
        
        return cell as? UITableViewCell ?? UITableViewCell()
        
    }

    

    @IBAction func send(_ sender: Any) {
        if let message = messageText.text {
            model.sendMessage(text: message)
            self.messageText.text = ""
        }
    }
    
}




//
//  ConversationViewController.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 31.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, IConversationModelDelegate {
    
    func updateConversationsList() {
        model.getDialog()
    }
    
    func updateCurrentConversation() {
        model.getDialog()
    }
    
//    
//    func update() {
//        model.getDialog()
//    }
   
    
    var messages:[Message] = [Message]()
    
    var model:IConversationModel
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var sendButton: UIButton!
    
    init(model:IConversationModel) {
        self.model=model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var messageText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = model.userName
        self.table.register(UINib.init(nibName: "IncomeMessageCell", bundle: nil), forCellReuseIdentifier: "IncomeMessageCell")
        self.table.register(UINib.init(nibName: "OutcomeMessageCell", bundle: nil), forCellReuseIdentifier: "OutcomeMessageCell")
        self.table.delegate = self
        self.table.dataSource = self
        //NotificationCenter.default.addObserver(self, selector: #selector(refreshDialogNot), name: .refreshDialog, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.getDialog()
    }
    
    func setupDialog(dialog:ConversationElement){
                DispatchQueue.main.async {
//                    self.messages = dialog.message
                    self.sendButton.isEnabled = dialog.online
                    self.table.reloadData()
                }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        model.updateUnread()
//        model.communicationManager.convListDelegate?.update()
        //NotificationCenter.default.post(name: .refreshDialogs, object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        if(message.isIncoming){
            let cell = table.dequeueReusableCell(withIdentifier: "IncomeMessageCell", for: indexPath) as? MessageCell
            
            if let cell = cell {
                cell.message = message.text
                return cell
            }
            else {
                return UITableViewCell()
            }
            
        }else{
            let cell = table.dequeueReusableCell(withIdentifier: "OutcomeMessageCell", for: indexPath) as? MessageCell
            
            if let cell = cell {
                cell.message = message.text
                return cell
            }
            else {
                return UITableViewCell()
            }
        }
        
    }
    
    @IBAction func send(_ sender: Any) {
        if let text = messageText.text {
//            model.sendMessage(string: text, to: model.userID)
        }

    }
    
    
}




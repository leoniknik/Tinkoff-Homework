//
//  ConversationViewController.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 31.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, IConversationModelDelegate {
    
    var model: IConversationModel
    var textFieldHasMessage: Bool = false
    
    @IBOutlet weak var downConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var messageText: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
    
    init(model: IConversationModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageText.delegate = self
        setupTitle()
        setupTableView()
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: nil, using: self.keyboardWillShow)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil, using: self.keyboardWillHide)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        model.setMessagesRead()
        if model.online {
            userDidBecomeOnline()
        }
        else {
            userDidBecomeOffline()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setupTitle() {
        titleLabel.text = model.userName
        navigationItem.titleView = titleLabel
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    func keyboardWillShow(notification: Notification) -> Void {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            downConstraint.constant = keyboardHeight
            
            scrollView.contentOffset.y = 300
        }
    }
    
    func keyboardWillHide(notification: Notification) -> Void {
        scrollView.contentOffset.y = 0
        downConstraint.constant = 0
    }
    
    
    func setupTableView() {
        model.initFetchedResultsManagerFor(tableView: table)
        self.table.register(UINib(nibName: "IncomeMessageCell", bundle: nil), forCellReuseIdentifier: "IncomeMessageCell")
        self.table.register(UINib(nibName: "OutcomeMessageCell", bundle: nil), forCellReuseIdentifier: "OutcomeMessageCell")
        self.table.delegate = self
        self.table.dataSource = self
        table.separatorStyle = .none
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfRowsIn(section: section)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
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
            if !message.isEmpty {
                model.sendMessage(text: message)
                self.messageText.text = ""
            }
        }
        messageText.resignFirstResponder()
    }
    
    
    func userDidBecomeOffline() {
        DispatchQueue.main.async { [weak self] in
            self?.messageText.isEnabled = false
            self?.updateButtonState()
            self?.titleLabel.setOnline(online: false)
        }
    }
    
    func userDidBecomeOnline() {
        DispatchQueue.main.async { [weak self] in
            self?.messageText.isEnabled = true
            self?.updateButtonState()
            self?.titleLabel.setOnline(online: true)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
            
            if txtAfterUpdate.isEmpty {
                textFieldHasMessage = false
            } else {
                textFieldHasMessage = true
            }
            updateButtonState()
        }
        return true
    }
    
    func updateButtonState() {
        let buttonIsEnabled = model.online && textFieldHasMessage;
        if buttonIsEnabled != sendButton.isEnabled {
            sendButton.isEnabled = buttonIsEnabled
        }
    }
    
}


extension UILabel {
    
    func setOnline(online: Bool) {
        
        let scale: CGFloat
        let titleColor: UIColor
        
        if online {
            scale = 1.1
            titleColor = .green
        }
        else {
            scale = 1.0
            titleColor = .black
        }
        
        UIView.transition(with: self, duration: 1.0, options: .transitionCrossDissolve, animations: {
            self.textColor = titleColor
        }, completion: nil)
        
        UIView.animate(withDuration: 1.0) {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
}

class SendButton: UIButton {
    
    override var isEnabled: Bool {
        didSet {
            let color : CGColor = isEnabled ? UIColor.green.cgColor :  UIColor.red.cgColor
            layer.backgroundColor = color
            let scale = CABasicAnimation(keyPath: "transform.scale")
            scale.duration = 0.5
            scale.fromValue = 1.0
            scale.toValue = 1.15
            scale.autoreverses = true
            layer.add(scale, forKey: "sendButton")
        }
    }
    
}




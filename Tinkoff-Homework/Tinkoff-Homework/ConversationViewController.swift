//
//  ConversationViewController.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 08.10.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageOutCell", for: indexPath) as! MessageCell
        switch indexPath.row {
        case 0:
            cell.message = "Б"
        case 1:
            cell.message = "Блокчейн — выстроенная по опре"
        case 2:
            cell.message = "Блок транзакций это специальная структура для записи группы транзакций в системе Биткойн и аналогичных ей. Транзакция считается завершённой и достоверной, когда проверены её формат и подписи, и когда сама транзакция объединена в группу с несколькими другими и записана в специальную структуру — блок)"
        case 3:
            cell.message = "a"
        case 4:
            cell.message = "a"
        case 5:
            cell.message = "a"
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MessageCell
        print(cell.contentView.frame.width)
        print(cell.messageLabel.frame.width)
    }

}

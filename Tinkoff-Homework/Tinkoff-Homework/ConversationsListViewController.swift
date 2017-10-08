//
//  ConversationsListViewController.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 07.10.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileBarItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    func setupUI() {
        if let image = UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal) {
            profileBarItem.image = image
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! ConversationCell
        //потом переделаю, чтобы данные брались, например, из массива, но для макета чата сойдет
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell.name = "Саша"
                cell.message = "Привет"
                cell.date = Date()
                cell.online = true
                cell.hasUnreadMessages = false
            case 1:
                cell.name = "Маша"
                cell.message = nil
                cell.date = nil
                cell.online = true
                cell.hasUnreadMessages = false
            case 2:
                cell.name = "Настя"
                cell.message = "GitHub - крупнейший веб-сервис для хостинга IT-проектов и их совместной разработки. Основан на системе контроля версий Git и разработан на Ruby on Rails и Erlang компанией GitHub, Inc."
                cell.date = Date()
                cell.online = true
                cell.hasUnreadMessages = false
            case 3:
                cell.name = "Катя"
                cell.message = "Docker — программное обеспечение для автоматизации развёртывания и управления приложениями в среде виртуализации на уровне операционной системы."
                cell.date = Calendar.current.date(byAdding: .hour, value: -5, to: Date())
                cell.online = true
                cell.hasUnreadMessages = true
            case 4:
                cell.name = "Лиза"
                cell.message = "Как дела?"
                cell.date = Calendar.current.date(byAdding: .day, value: -1, to: Date())
                cell.online = true
                cell.hasUnreadMessages = true
            case 5:
                cell.name = "Аня"
                cell.message = "Во сколько нам завтра в универ?"
                cell.date = Calendar.current.date(byAdding: .day, value: -2, to: Date())
                cell.online = true
                cell.hasUnreadMessages = false
            case 6:
                cell.name = "Алина"
                cell.message = "Tornado is a Python web framework and asynchronous networking library, originally developed at FriendFeed."
                cell.date = Calendar.current.date(byAdding: .day, value: -30, to: Date())
                cell.online = true
                cell.hasUnreadMessages = false
            case 7:
                cell.name = "Кристина"
                cell.message = nil
                cell.date = nil
                cell.online = true
                cell.hasUnreadMessages = false
            case 8:
                cell.name = "Вика"
                cell.message = "Vapor is the most used web framework for Swift. It provides a beautifully expressive and easy to use foundation for your next website, API, or cloud project."
                cell.date = Calendar.current.date(byAdding: .hour, value: -2, to: Date())
                cell.online = true
                cell.hasUnreadMessages = true
            case 9:
                cell.name = "Юля"
                cell.message = nil
                cell.date = nil
                cell.online = true
                cell.hasUnreadMessages = false
            default:
                return UITableViewCell()
            }
        }
        else {
            //потом переделаю, чтобы данные брались из массива, но для макета чата сойдет
            switch indexPath.row {
            case 0:
                cell.name = "Максим"
                cell.message = "Server-side Swift. The Perfect core toolset and framework for Swift Developers."
                cell.date = Date()
                cell.online = false
                cell.hasUnreadMessages = false
            case 1:
                cell.name = "Игорь"
                cell.message = "Realm is a mobile platform and a replacement for SQLite & Core Data. Build offline-first, reactive mobile experiences using simple data sync."
                cell.date = Date()
                cell.online = false
                cell.hasUnreadMessages = true
            case 2:
                cell.name = "Артем"
                cell.message = "Core Data is an object graph and persistence framework provided by Apple in the macOS and iOS operating systems."
                cell.date = Date()
                cell.online = false
                cell.hasUnreadMessages = false
            case 3:
                cell.name = "Леша"
                cell.message = "SQLite is a self-contained, high-reliability, embedded, full-featured, public- domain, SQL database engine."
                cell.date = Date()
                cell.online = false
                cell.hasUnreadMessages = true
            case 4:
                cell.name = "Кирилл"
                cell.message = nil
                cell.date = nil
                cell.online = false
                cell.hasUnreadMessages = false
            case 5:
                cell.name = "Влад"
                cell.message = "Heroku is a platform as a service (PaaS) that enables developers to build, run, and operate applications entirely in the cloud."
                cell.date = Date()
                cell.online = false
                cell.hasUnreadMessages = true
            case 6:
                cell.name = "Вася"
                cell.message = nil
                cell.date = nil
                cell.online = false
                cell.hasUnreadMessages = false
            case 7:
                cell.name = "Никита"
                cell.message = "IBM Bluemix is a cloud platform as a service (PaaS) developed by IBM."
                cell.date = Date()
                cell.online = false
                cell.hasUnreadMessages = true
            case 8:
                cell.name = "Илья"
                cell.message = "Hibernate ORM enables developers to more easily write applications whose data outlives the application process."
                cell.date = Date()
                cell.online = false
                cell.hasUnreadMessages = false
            case 9:
                cell.name = "Олег"
                cell.message = "Oracle Corporation is an American multinational computer technology corporation, headquartered in Redwood Shores, California."
                cell.date = Date()
                cell.online = false
                cell.hasUnreadMessages = true
            default:
                return UITableViewCell()
            }
        }
        
        return cell
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
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! ConversationCell
        performSegue(withIdentifier: "toChat", sender: cell.name)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChat" {
            guard let destinationController = segue.destination as? ConversationViewController else { return
            }
            guard let title = sender as? String else { return }
            destinationController.title = title
        }
    }

}

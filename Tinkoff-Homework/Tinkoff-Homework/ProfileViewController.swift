//
//  ViewController.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 24.09.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var changeProfileImageButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeViewsCircular()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func makeViewsCircular() {
        let radius = changeProfileImageButton.frame.size.width/2
        
        changeProfileImageButton.layer.cornerRadius = radius
        changeProfileImageButton.clipsToBounds = true
        
        profileImage.layer.cornerRadius = radius
        profileImage.clipsToBounds = true
    }
    
    @IBAction func changeProfileImage(_ sender: Any) {
        print("Выбери изображение профиля")
        
    }
    

}


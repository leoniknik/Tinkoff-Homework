//
//  ViewController.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 24.09.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var changeProfileImageButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let button = editButton {
            print(button.frame)
        }
        else {
            print("Произошла ошибка, так как button еще не прогружен, так как не был еще вызван loadView")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(editButton.frame)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //frame отличается, так как к кнопке были применены констреинты, и кнопка перерисовалась для другого экрана
        print(editButton.frame)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupUI() {
        let radius = changeProfileImageButton.frame.size.width/2
        
        changeProfileImageButton.layer.cornerRadius = radius
        changeProfileImageButton.clipsToBounds = true
        
        profileImage.layer.cornerRadius = radius
        profileImage.clipsToBounds = true
        
        let offsetConstant = CGFloat(20)
        changeProfileImageButton.imageEdgeInsets = UIEdgeInsetsMake(offsetConstant, offsetConstant, offsetConstant, offsetConstant)
        
        editButton.layer.borderColor = UIColor.black.cgColor
        editButton.layer.borderWidth = 2
        editButton.layer.cornerRadius = 12
        editButton.clipsToBounds = true
    }
    
    @IBAction func changeProfileImage(_ sender: Any) {
        print("Выбери изображение профиля")
        
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Отмена", style: .cancel) { action -> Void in
        }
        
        
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Сделать фото", style: .default) { action -> Void in
            self.openCamera()
        }
        
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Выбрать из галереи", style: .default) { action -> Void in
            self.openPhotoLibrary()
        }
        
        actionSheetController.addAction(choosePictureAction)
        actionSheetController.addAction(cancelAction)
        actionSheetController.addAction(takePictureAction)

        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage.image = image
        }
        dismiss(animated:true, completion: nil)
    }
    
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}


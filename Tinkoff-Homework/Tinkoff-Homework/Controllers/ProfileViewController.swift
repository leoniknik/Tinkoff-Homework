//
//  ViewController.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 24.09.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var GCDbutton: UIButton!
    @IBOutlet weak var OperationButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var profile:Profile = Profile.getEmptyProfile()
    var operationTaskManager:OperationTaskManager = OperationTaskManager()
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var changeProfileImageButton: UIButton!
    @IBOutlet weak var bottomConstraintForScrollView: NSLayoutConstraint!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        if let button = editButton {
//            print(button.frame)
//        }
//        else {
//            print("Произошла ошибка, так как button еще не прогружен, так как не был еще вызван loadView")
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(editButton.frame)
        descriptionTextView.delegate = self
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: nil, using: self.keyboardWillShow)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil, using: self.keyboardWillHide)

        activityIndicator.hidesWhenStopped = true
        loadDataFromProfile()
        
        setupButton(button: GCDbutton)
        setupButton(button: OperationButton)
        setupView(view: descriptionTextView, radius: 10)
        setupView(view: activityIndicator, radius: Float(activityIndicator.bounds.size.width/2.0))
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        operationTaskManager.readProfile(controller: self)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification: Notification) -> Void {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            bottomConstraintForScrollView.constant = keyboardHeight
            
            scrollView.contentOffset.y = 300
            
        }
    }
    
    func keyboardWillHide(notification: Notification) -> Void {
        bottomConstraintForScrollView.constant = 0
    }
    
    func setupButton(button : UIButton){
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = CGFloat(10)
        button.clipsToBounds = true
    }
    
    func setupView(view : UIView,radius : Float){
        view.layer.cornerRadius = CGFloat(radius)
        view.clipsToBounds = true
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
//        print(editButton.frame)
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
        
//        editButton.layer.borderColor = UIColor.black.cgColor
//        editButton.layer.borderWidth = 2
//        editButton.layer.cornerRadius = 12
//        editButton.clipsToBounds = true
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
            profile.newAvatar = image
            setSaveButtonsAvalibleState()
        }
        dismiss(animated:true, completion: nil)
    }
    
    //dz4
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func GCDSaveAction(_ sender: UIButton) {
         GCDTaskManager().saveProfile(controller: self)
    }
    
    @IBAction func OperationSaveAction(_ sender: UIButton) {
        operationTaskManager.saveProfile(controller: self)
    }
    
    @IBAction func nameChanged(_ sender: UITextField) {
        profile.newName = nameTextField.text!
        setSaveButtonsAvalibleState()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        profile.newInfo = descriptionTextView.text!
        setSaveButtonsAvalibleState()
    }
    
    func loadDataFromProfile(){
        profileImage.image = profile.avatar
        nameTextField.text = profile.name
        descriptionTextView.text = profile.info
        setSaveButtonsAvalibleState()
    }
    
    func setSaveButtonsAvalibleState(){
        if(profile.needSave){
            GCDbutton.isEnabled = true
            OperationButton.isEnabled = true
        }
        else{
            GCDbutton.isEnabled = false
            OperationButton.isEnabled = false
        }
    }
    
}


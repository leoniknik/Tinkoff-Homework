//
//  ProfileViewController.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 31.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate,UITextViewDelegate,TaskManagerDelegate,ProfileViewControllerModelDelegate {
    
    func startAnimate() {
        self.activityStartAnimate()
    }
    
    func stopAnimate() {
        self.activityStopAnimate()
    }
    
    func update(){
        loadDataFromProfile()
    }
    
    func receiveProfile(profile: Profile) {
        model.profile=profile
        self.loadDataFromProfile()
    }
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var downConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var infoTextView: UITextView!
    
    @IBOutlet weak var gcdButton: UIButton!
    
    @IBOutlet weak var operationButton: UIButton!
    
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var makePhotoButton: UIButton!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var picker:UIImagePickerController?=UIImagePickerController()
    
   
    
    var model:IProfileViewControllerModel
    
    init(model:IProfileViewControllerModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        set delegates
        picker!.delegate = self
        nameTextField.delegate = self
        infoTextView.delegate = self
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: nil, using: self.keyboardWillShow)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil, using: self.keyboardWillHide)
        
        
        

        photoImageView.layer.cornerRadius = 50
        makePhotoButton.layer.cornerRadius = 50
        let offsetConstant = CGFloat(20)
        makePhotoButton.imageEdgeInsets = UIEdgeInsetsMake(offsetConstant, offsetConstant, offsetConstant, offsetConstant)
        photoImageView.clipsToBounds = true
        makePhotoButton.clipsToBounds = true
        
        activity.hidesWhenStopped = true
 
        loadDataFromProfile()
        
        setupButton(button: gcdButton)
        setupButton(button: operationButton)
        setupView(view: infoTextView, radius: 10)
        setupView(view: activity, radius: Float(activity.bounds.size.width/2.0))
        
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        model.gcdManager.readProfile()
    }
    
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
        downConstraint.constant = 0
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
    
    
    
    @IBAction func getProfileImage(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: "Выбери источник картинки", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Камера", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openCamera()
        })
        
        let saveAction = UIAlertAction(title: "Галерея", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openGallary()
        })
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func openGallary()
    {
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(picker!, animated: true, completion: nil)
    }
    
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker!.allowsEditing = false
            picker!.sourceType = UIImagePickerControllerSourceType.camera
            picker!.cameraCaptureMode = .photo
            present(picker!, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Нет камеры", message: "На этом устройстве нет камеры", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        model.profile.newAvatar = image
        photoImageView.image = image
        setSaveButtonsAvalibleState()
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadDataFromProfile(){
        photoImageView.image = model.profile.avatar
        nameTextField.text = model.profile.name
        infoTextView.text = model.profile.info
        setSaveButtonsAvalibleState()
    }
    
    func setSaveButtonsAvalibleState(){
        if(model.profile.needSave){
            gcdButton.isEnabled = true
            operationButton.isEnabled = true
            gcdButton.backgroundColor = .green
            operationButton.backgroundColor = .green
        }
        else{
            gcdButton.isEnabled = false
            operationButton.isEnabled = false
            gcdButton.backgroundColor = .red
            operationButton.backgroundColor = .red
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        model.profile.newInfo = infoTextView.text!
        setSaveButtonsAvalibleState()
    }
    
    @IBAction func nameChanged(_ sender: Any) {
        model.profile.newName = nameTextField.text!
        setSaveButtonsAvalibleState()
    }
    
    

    
    
    
    @IBAction func gcdSaveAction(_ sender: Any) {
        self.model.gcdSave()
    }
    
    @IBAction func operationSaveAction(_ sender: Any) {
        self.model.operationSave()
    }
    
    func activityStartAnimate(){
        activity.isHidden=false
        activity.startAnimating()
        activity.hidesWhenStopped = true
    }
    func activityStopAnimate(){
        activity.isHidden=true
        activity.hidesWhenStopped = true
        activity.stopAnimating()
    }
    
    
    func showSucsessAlert(){
        let optionMenu = UIAlertController(title: "Даные сохранены", message: nil, preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            DispatchQueue.main.async() {
               self.loadDataFromProfile()
            optionMenu.dismiss(animated: true, completion: nil)
            }})
        
        optionMenu.addAction(okAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func showErrorAlert(string:String, gcdMode:Bool){
        let optionMenu = UIAlertController(title: "Ошибка", message: string, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            DispatchQueue.main.async() {
                self.activityStopAnimate()
                self.model.gcdManager.readProfile()
                
            }
            optionMenu.dismiss(animated: true, completion: nil)
            
        })
        
        let againAction = UIAlertAction(title: "Повторить", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if gcdMode {
                self.model.gcdSave()
            }
            else{
                self.model.operationSave()
            }
        })
        
        optionMenu.addAction(cancelAction)
        optionMenu.addAction(againAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
}




//
//  ChooseImageViewController.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 20.11.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class ChooseImageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, IChooseImageModelDelegate {

    private let numberOfColomns: CGFloat = 3
    private let inset: CGFloat = 10.0
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model: IChooseImageModel
    
    init(model: IChooseImageModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectioView()
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        model.getImages()
    }
    
    func setupCollectioView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: 
            nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insetWidth = inset * (numberOfColomns + 1)
        let availableWidth = view.frame.width - insetWidth
        let width = availableWidth / numberOfColomns
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number = model.getNumberOfItems()
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell {
            cell.imageView.image = UIImage(named: "placeholder-user") ?? UIImage()
            
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.model.getImage(forItem: indexPath.item, completion: { (image) in
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                })
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func update() {
        DispatchQueue.main.async { [weak self] in
            self?.spinner.stopAnimating()
            self?.collectionView.reloadData()
        }
    }
    
    
    
}

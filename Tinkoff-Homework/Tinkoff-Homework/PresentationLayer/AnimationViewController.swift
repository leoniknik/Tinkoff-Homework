//
//  AnimationViewController.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 27.11.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class AnimationViewController: UIViewController {
    
    private var timer: Timer?
    private var currentPoint = CGPoint.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(reconizer:)))
        gestureRecognizer.minimumPressDuration = 0.2
        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func longPressGesture(reconizer: UILongPressGestureRecognizer) {
        
        currentPoint = reconizer.location(in: self.view)
        
        if reconizer.state == .began {
            tinkoffAnimation()
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(tinkoffAnimation), userInfo: nil, repeats: true)
        } else if reconizer.state == .ended{
            timer?.invalidate()
        }
    }
    
    @objc func tinkoffAnimation() {
        
        let delay : CFTimeInterval = 0.3
        let offsetX = CGFloat(Int(arc4random_uniform(100)) - 50)
        let offsetY = CGFloat(Int(arc4random_uniform(100)) - 50)
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tinkoff")
        imageView.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
        imageView.center = self.currentPoint
        self.view.addSubview(imageView)

        let firstAnimation = CABasicAnimation(keyPath: "position")
        firstAnimation.fromValue = imageView.layer.position
        let newPosition = CGPoint(x: imageView.layer.position.x + offsetX, y: imageView.layer.position.y + offsetY)
        firstAnimation.toValue = newPosition
        firstAnimation.duration = delay
        imageView.layer.add(firstAnimation, forKey: "firstAnimation")
        imageView.layer.position = newPosition
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            imageView.removeFromSuperview()
        }
        let secondAnimation = CABasicAnimation(keyPath: "opacity")
        secondAnimation.fromValue = 1
        secondAnimation.toValue = 0
        secondAnimation.duration = delay + 1
        imageView.layer.opacity = 0
        imageView.layer.add(secondAnimation, forKey: "secondAnimation")
        CATransaction.commit()
    }
    
}

//extension Int
//{
//    static func random(range: Range<Int> ) -> Int
//    {
//        var offset = 0
//
//        if range.startIndex < 0   // allow negative ranges
//        {
//            offset = abs(range.startIndex)
//        }
//
//        let mini = UInt32(range.startIndex + offset)
//        let maxi = UInt32(range.endIndex   + offset)
//
//        return Int(mini + arc4random_uniform(maxi - mini)) - offset
//    }
//}



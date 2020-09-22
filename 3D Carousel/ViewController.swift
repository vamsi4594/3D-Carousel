//
//  ViewController.swift
//  3D Carousel
//
//  Created by THANIKANTI VAMSI KRISHNA on 1/24/20.
//  Copyright © 2020 THANIKANTI VAMSI KRISHNA. All rights reserved.
//

import UIKit

func degreeToRadians (deg:CGFloat) -> CGFloat
{
    return (deg * CGFloat.pi)/180
}

class ViewController: UIViewController {
    
    let transformLayer = CATransformLayer()
    var currentAngle:CGFloat = 0
    var currentOffSet:CGFloat = 0
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        transformLayer.frame = self.view.bounds
        view.layer.addSublayer(transformLayer)
        
        for i in 1...8
        {
            addImageCard(name: "\(i)")
        }
        
        turnCarousel()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.performPanAction(recognizer:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
    }
    func addImageCard(name: String)
    {
        let imageCardSize = CGSize(width: 150, height: 300 )
        let imageLayer = CALayer()
        imageLayer.frame = CGRect(x: view.frame.size.width / 2 - imageCardSize.width / 2, y: view.frame.size.height / 2 - imageCardSize.height / 2, width: imageCardSize.width, height: imageCardSize.height)
        imageLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        guard let imageCardImage = UIImage(named: name)?.cgImage else {return}
        
        imageLayer.contents = imageCardImage
        imageLayer.contentsGravity = .resizeAspectFill
        imageLayer.masksToBounds = true
        imageLayer.isDoubleSided = true
        imageLayer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor
        imageLayer.borderWidth = 5
        imageLayer.cornerRadius = 10
        
        transformLayer.addSublayer(imageLayer)
    }
    
    func turnCarousel()
    {
        guard let transformSubLayer = transformLayer.sublayers else{return}
        let segmentForImageCard = CGFloat(360 / transformSubLayer.count)
        var angleOffSet = currentAngle
        
        for layer in transformSubLayer
        {
            var transform = CATransform3DIdentity
            transform.m34 = -1 / 500
            
            transform = CATransform3DRotate(transform, degreeToRadians(deg: angleOffSet), 0, 1, 0)
            transform = CATransform3DTranslate(transform, 0, 0, 200)
            
            CATransaction.setAnimationDuration(0)
            
            layer.transform = transform
            
            angleOffSet += segmentForImageCard
            
            
        }
    }
    
    @objc func performPanAction (recognizer: UIPanGestureRecognizer)
    {
        if recognizer.state == .began
        {
            currentOffSet = 0
        }
        let xOffset = recognizer.translation(in: self.view).x
        let xDiff = xOffset * 0.6 - currentOffSet
        
        currentOffSet += xDiff
        currentAngle += xDiff
        
        turnCarousel()
    }


}


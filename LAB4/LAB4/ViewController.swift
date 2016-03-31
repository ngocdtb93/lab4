//
//  ViewController.swift
//  LAB4
//
//  Created by Ngoc Do on 3/30/16.
//  Copyright © 2016 com.appable. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var arrowImage: UIImageView!
    var newlyCreatedFace:UIImageView!
    var originImageCenter:CGPoint!
    
    @IBAction func panFaceGesture(panGestureRecognizer: UIPanGestureRecognizer) {
        let point = panGestureRecognizer.locationInView(parentView)
        

        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            originImageCenter = point
            
            var imageView = panGestureRecognizer.view as! UIImageView
            
            // Create a new image view that has the same image as the one currently panning
            if(newlyCreatedFace == nil){
                newlyCreatedFace = UIImageView(image: imageView.image)
                newlyCreatedFace.userInteractionEnabled = true
            }
            
            // Add the new face to the tray's parent view.
            view.addSubview(newlyCreatedFace)
            
            // Initialize the position of the new face.
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += parentView.frame.origin.y
            
            //pan
            let panGesture = UIPanGestureRecognizer()
            panGesture.addTarget(self, action: #selector(ViewController.panFaceGesture(_:)))
            
            //scale
            
            let pinchGesture = UIPinchGestureRecognizer()
            pinchGesture.addTarget(self, action: #selector(ViewController.onPinchGesture(_:)))
            
            newlyCreatedFace.addGestureRecognizer(pinchGesture)
            
            //rotate
            let rotateGesture = UIRotationGestureRecognizer()
            rotateGesture.addTarget(self, action: #selector(ViewController.onRotateGesture(_:)))
            
            newlyCreatedFace.addGestureRecognizer(rotateGesture)
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            let trayChanged = panGestureRecognizer.locationInView(self.view)
            print(trayChanged.y)
            newlyCreatedFace.frame.origin = trayChanged
            
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            let faceEnded = panGestureRecognizer.locationInView(self.view)
            if(faceEnded.y > 342){
                newlyCreatedFace.center = originImageCenter
            }
        }
    }
    
    @IBOutlet weak var firstFace: UIImageView!
    
    
    var trayOriginalCenter: CGPoint!
    @IBOutlet weak var parentView: UIView!
    
    
    @IBAction func onTrayPanGesture(panGestureRecognizer: UIPanGestureRecognizer) {
        
        let point = panGestureRecognizer.locationInView(self.view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            //print("Gesture began at: \(point)")
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            
            let trayChanged = panGestureRecognizer.locationInView(self.view)
            
//            print("changed: \(panGestureRecognizer)")
            parentView.center.y = trayChanged.y
            //print("Gesture changed at: \(point)")
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { 
                let velocity = panGestureRecognizer.velocityInView(self.view)
                if( velocity.y >= 0){
                    self.parentView.frame.origin.y = self.view.frame.height - 35
                    self.arrowImage.transform = CGAffineTransformMakeRotation(CGFloat(180 * M_PI / 180))
                }else{
                    self.arrowImage.transform = CGAffineTransformMakeRotation(CGFloat(2 * M_PI / 180))
                    self.parentView.center.y = self.trayOriginalCenter.y
                }

                }, completion: nil)
            
        }
    }
    
     @IBAction func onPinchGesture(pinchGestureRecognizer: UIPinchGestureRecognizer) {
        self.newlyCreatedFace.transform = CGAffineTransformScale(self.view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale)
        //pinchGestureRecognizer.scale = 1
    }
    
    @IBAction func onRotateGesture(rotateGestureRecognizer: UIRotationGestureRecognizer) {
        self.newlyCreatedFace.transform = CGAffineTransformRotate(self.view.transform, rotateGestureRecognizer.rotation)
        //pinchGestureRecognizer.scale = 1
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        trayOriginalCenter = self.parentView.center
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


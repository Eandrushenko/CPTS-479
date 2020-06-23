//
//  ViewController.swift
//  FoodApp
//
//  Created by Elijah Andrushenko on 3/10/20.
//  Copyright © 2020 Elijah Andrushenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var ResultText: UILabel!
    @IBOutlet weak var ResultImage: UIImageView!
    
    var smileGestureRecognizer = SmileGestureRecognizer(target: self, action: #selector (handleSmile))
    var frownGestureRecognizer = FrownGestureRecognizer(target: self, action: #selector (handleFrown))
    
    @IBAction func tapDetected(_ sender: UIGestureRecognizer) {
        let point = sender.location(in: self.view)
        let x = Int(point.x)
        let y = Int(point.y)
        print("tap detected at (\(x), \(y))")
    }
    
    @objc func handleSmile(_ sender: SmileGestureRecognizer) {
        if sender.state == .ended {
            print("Smile Detected")
            ResultImage.image = UIImage(named: "smile.png")
            ResultText.text = "Tastes Good!"
            ResultImage.isHidden = false
            ResultText.isHidden = false
        }
        else if sender.state == .began {
            ResultImage.isHidden = true
            ResultText.isHidden = true
        }
    }
    
    @objc func handleFrown(_ sender: FrownGestureRecognizer) {
        if sender.state == .ended {
            print("Frown Detected")
            ResultImage.image = UIImage(named: "frown.png")
            ResultText.text = "Tastes Bad!"
            ResultImage.isHidden = false
            ResultText.isHidden = false
        }
    }
    
    @IBAction func ClearClicked(_ sender: Any) {
        ResultImage.isHidden = true
        ResultText.isHidden = true
        smileGestureRecognizer.clearBoxes()
        frownGestureRecognizer.clearBoxes()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is SmileGestureRecognizer {
            if otherGestureRecognizer is FrownGestureRecognizer {
                return true
            }
        }
        return false
    }
 
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIButton {
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ResultImage.image = UIImage(named: "smile.png")
        ResultText.text = " "
        ResultImage.isHidden = true
        ResultText.isHidden = true
        
        smileGestureRecognizer = SmileGestureRecognizer(target: self, action: #selector (handleSmile))
        smileGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(smileGestureRecognizer)
        
        frownGestureRecognizer = FrownGestureRecognizer(target: self, action: #selector (handleFrown))
        frownGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(frownGestureRecognizer)
    }
}


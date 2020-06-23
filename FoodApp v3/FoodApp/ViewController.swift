//
//  ViewController.swift
//  FoodApp
//
//  Created by Elijah Andrushenko on 1/28/20.
//  Copyright © 2020 Elijah Andrushenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MyTimerDelegate {
    func timeChanged(time: Int) {
        print(String(time))
    }
    
    func timesUp() {
        print("Done")
        myTimer?.reset()
        if (number == 1) {
            FoodImage.image = UIImage(named: "pizza.png")
            FoodNumber.text = "My #2 favorite food is..."
            FoodName.text = "Pizza!"
            number += 1
        }
        else if (number == 2) {
            FoodImage.image = UIImage(named: "burger.jpg")
            FoodNumber.text = "My #3 favorite food is..."
            FoodName.text = "Burger!"
            number += 1
        }
        else if (number == 3) {
            FoodImage.image = UIImage(named: "cake.jpg")
            FoodNumber.text = "My #1 favorite food is..."
            FoodName.text = "Cake!"
            number = 1
        }
        else {
            print("ERROR: timesUp()")
        }
    }
    
    var number: Int = 1
    var time: Int = 5
    @IBOutlet weak var FoodNumber: UILabel!
    @IBOutlet weak var FoodImage: UIImageView!
    @IBOutlet weak var FoodName: UILabel!
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var StopButton: UIButton!
    @IBOutlet weak var TimerDisplay: UILabel!
    @IBOutlet weak var TimerSlider: UISlider!
    
    var myTimer: MyTimer?
    
    @IBAction func SlideAction(_ sender: UISlider) {
        time = Int(sender.value)
        TimerDisplay.text = "Delay: " + String(time) + "s"
        myTimer?.setInitialTime(time)
    }
    
    @IBAction func StartClick(_ sender: Any) {
        StartButton.isEnabled = false
        StopButton.isEnabled = true
        myTimer?.start()
    }
    
    @IBAction func StopClick(_ sender: Any) {
        StopButton.isEnabled = false
        StartButton.isEnabled = true
        myTimer?.stop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        FoodImage.image = UIImage(named: "cake.jpg")
        FoodNumber.text = "My #1 favorite food is..."
        FoodName.text = "Cake!"
        TimerDisplay.text = "Delay: 5s"
        TimerSlider.value = 5
        StopButton.isEnabled = false
        StartButton.isEnabled = true
        print("View Did Load")
        myTimer = MyTimer()
        myTimer?.delegate = self
        myTimer?.setInitialTime(time)
    }


}


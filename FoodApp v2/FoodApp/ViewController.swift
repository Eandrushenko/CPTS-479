//
//  ViewController.swift
//  FoodApp
//
//  Created by Elijah Andrushenko on 1/28/20.
//  Copyright © 2020 Elijah Andrushenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var number: Int = 1
    @IBOutlet weak var FoodNumber: UILabel!
    @IBOutlet weak var FoodImage: UIImageView!
    @IBOutlet weak var FoodName: UILabel!
    
    @IBAction func NextClick(_ sender: Any) {
        if (number == 1){
            FoodImage.image = UIImage(named: "pizza.png")
            FoodNumber.text = "My #2 favorite food is..."
            FoodName.text = "Pizza!"
            number += 1
        } else if (number == 2) {
            FoodImage.image = UIImage(named: "burger.jpg")
            FoodNumber.text = "My #3 favorite food is..."
            FoodName.text = "Burgers!"
            number += 1
        } else if (number == 3) {
            FoodImage.image = UIImage(named: "cake.jpg")
            FoodNumber.text = "My #1 favorite food is..."
            FoodName.text = "Cake!"
            number = 1
        } else {
            print("Error in Function: NextClick")
        }

        print("Button Clicked")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        FoodImage.image = UIImage(named: "cake.jpg")
        FoodNumber.text = "My #1 favorite food is..."
        FoodName.text = "Cake!"
        print("View Did Load")
    }


}


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
    var foods = ["Cake!", "Pizza!", "Burgers!"]
    @IBOutlet weak var FoodNumber: UILabel!
    @IBOutlet weak var FoodImage: UIImageView!
    @IBOutlet weak var FoodName: UILabel!
    
    @IBAction func NextClick(_ sender: Any) {
        if (number >= foods.count) {
            number = 0
        }
        if (number == 0){
            FoodImage.image = UIImage(named: "cake.jpg")
            FoodNumber.text = "My #\(number+1) favorite food is..."
            FoodName.text = foods[number]
            number += 1
        } else if (number == 1) {
            FoodImage.image = UIImage(named: "pizza.png")
            FoodNumber.text = "My #\(number+1) favorite food is..."
            FoodName.text = foods[number]
            number += 1
        } else if (number == 2) {
            FoodImage.image = UIImage(named: "burger.jpg")
            FoodNumber.text = "My #\(number+1) favorite food is..."
            FoodName.text = foods[number]
            number += 1
        } else if (number > 2) {
            FoodImage.image = UIImage(named: "Foods.jpg")
            FoodNumber.text = "My #\(number+1) favorite food is..."
            FoodName.text = foods[number]
            number += 1
        } else {
            print("Error in Function: NextClick")
        }

        print("Button Clicked")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "VCtoAddFoodVC") {
            let FoodVC = segue.destination as! AddFoodViewController
            FoodVC.FoodCount = foods.count + 1
        }
    }
    
    @IBAction func unwindFromAddFood(sender: UIStoryboardSegue) {
        print("Cancel Clicked")
    }
    
    @IBAction func unwindFromAddFoodSave(sender: UIStoryboardSegue) {
        let AddFoodVC = sender.source as! AddFoodViewController
        if (AddFoodVC.AddFoodKeyBoard.text! == "") {
            print("Blank Text therefore nothing was added")
        } else {
        foods.append(AddFoodVC.AddFoodKeyBoard.text!)
        print(AddFoodVC.AddFoodKeyBoard.text! + " was added To the list")
        }
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


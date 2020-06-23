//
//  AddFoodViewController.swift
//  FoodApp
//
//  Created by Elijah Andrushenko on 2/12/20.
//  Copyright © 2020 Elijah Andrushenko. All rights reserved.
//

import UIKit

class AddFoodViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var AddFoodText: UILabel!
    @IBOutlet weak var AddFoodKeyBoard: UITextField!
    var FoodCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.AddFoodKeyBoard.delegate = self
        AddFoodText.text = "Enter name of food #\(FoodCount)"
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print(textField.text!)
        if (textField.text! == ""){
            print("Awesome")
        }
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

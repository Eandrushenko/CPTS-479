//
//  AddFoodViewController.swift
//  FoodApp
//
//  Created by Elijah Andrushenko on 3/25/20.
//  Copyright © 2020 Elijah Andrushenko. All rights reserved.
//

import UIKit

class AddFoodViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var AddFoodKeyBoard: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.AddFoodKeyBoard.delegate = self

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print(textField.text!)
        if (textField.text == ""){
            print("Blank Text Field")
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

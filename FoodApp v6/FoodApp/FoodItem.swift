//
//  FoodItem.swift
//  FoodApp
//
//  Created by Elijah Andrushenko on 2/19/20.
//  Copyright © 2020 Elijah Andrushenko. All rights reserved.
//

import Foundation

class FoodItem {
    var name : String = UserDefaults.standard.string(forKey: "Foodname")!
    var image : String = "Foods.jpg"
    var cals : String = "100"
    var ID: Int = 0
    
}

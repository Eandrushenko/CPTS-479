//
//  RecipeViewController.swift
//  FoodApp
//
//  Created by Elijah Andrushenko on 3/25/20.
//  Copyright © 2020 Elijah Andrushenko. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RecipeViewController: UIViewController {
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var RecipeLabel: UILabel!
    
    var Recipefood : String = ""
    var APIKey : String = "bca26eee8dc84416b3b6719085d31f92"
    var foodURLString : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodURLString = "https://api.spoonacular.com/recipes/search?query=\(Recipefood)&apiKey=\(APIKey)"
        getFood()
    }
    
    func getFood() {
        if let urlStr = foodURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let url = URL(string: urlStr) {
                let dataTask = URLSession.shared.dataTask(with: url, completionHandler: handleFoodResponse)
                dataTask.resume()
            }
        }
    }
    
    func handleFoodResponse (data: Data?, response: URLResponse?, error: Error?) {
        // 1. Check for error in request (e.g. no network connection)
        if let err = error {
            print("1. error: \(err.localizedDescription)")
            DispatchQueue.main.async {
                self.RecipeLabel.text = "No Recipes Found"
                self.foodImageView.isHidden = true
                }
            return
        }
        // 2. Check for improperly-formatted response
        guard let httpResponse = response as? HTTPURLResponse else {
            print("2. error: improperly-formatted response")
            DispatchQueue.main.async {
                self.RecipeLabel.text = "No Recipes Found"
                self.foodImageView.isHidden = true
                }
            return
        }
        let statusCode = httpResponse.statusCode
        // 3. Check for HTTP error
        guard statusCode == 200 else {
            let msg = HTTPURLResponse.localizedString(forStatusCode: statusCode)
            print("3. HTTP \(statusCode) error: \(msg)")
            DispatchQueue.main.async {
                self.RecipeLabel.text = "No Recipes Found"
                self.foodImageView.isHidden = true
                }
            return
        }
        // 4. Check for no data
        guard let somedata = data else {
            print("4. error: no data")
            DispatchQueue.main.async {
                self.RecipeLabel.text = "No Recipes Found"
                self.foodImageView.isHidden = true
                }
            return
        }
        // 5. Check for properly-formatted JSON data
        guard let jsonObj = try? JSONSerialization.jsonObject(with: somedata),
            let jsonDict1 = jsonObj as? [String: Any],
            let base = jsonDict1["baseUri"] as? String,
            let foodArray = jsonDict1["results"] as? [Any],
            foodArray.count > 0,
            let jsonDict2 = foodArray[0] as? [String: Any],
            let titleStr = jsonDict2["title"] as? String,
            let urlToImage = jsonDict2["image"] as? String else {
        print("5. error: invalid JSON data")
        DispatchQueue.main.async {
            self.RecipeLabel.text = "No Recipes Found"
            self.foodImageView.isHidden = true
            }
        return
        }
        // 6. Everything seems okay
        let foodimage = "\(base)\(urlToImage)"
        print(foodimage)
        self.loadFoodImage(foodimage)
        DispatchQueue.main.async {
            self.RecipeLabel.text = titleStr
        }
        
    }
    
    func loadFoodImage(_ urlString: String) {
        // URL comes from API response; definitely needs some sadfety checks
        if let urlStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let url = URL(string: urlStr) {
                let dataTask = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) -> Void in if let imageData = data {
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        self.foodImageView.image = image
                    }
                    }
                })
                dataTask.resume()
            }
            }
        }
    
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



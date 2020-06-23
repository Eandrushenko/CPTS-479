//
//  TableViewController.swift
//  FoodApp
//
//  Created by Elijah Andrushenko on 2/19/20.
//  Copyright © 2020 Elijah Andrushenko. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var FoodItemArray = [FoodItem]()
    var SortedFoodItemArray: [FoodItem] = []
    var FoodItem1 = FoodItem()
    var FoodItem2 = FoodItem()
    var FoodItem3 = FoodItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 58
        FoodItem1.name = "Cake"
        FoodItem1.image = "cake.jpg"
        FoodItem1.cals = "400"
        
        FoodItem2.name = "Pizza"
        FoodItem2.image = "pizza.png"
        FoodItem2.cals = "300"
        
        FoodItem3.name = "Burger"
        FoodItem3.image = "burger.jpg"
        FoodItem3.cals = "500"
        
        FoodItemArray.append(FoodItem1)
        FoodItemArray.append(FoodItem2)
        FoodItemArray.append(FoodItem3)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        processItems()
        tableView.reloadData()
    }
    
    func reassignIndex() {
        var i : Int = 0
        while (i < FoodItemArray.count) {
            FoodItemArray[i].ID = i
            i += 1
        }
    }
    
    func processItems() {
        reassignIndex()
        if UserDefaults.standard.bool(forKey: "sortItems") {
            SortedFoodItemArray = FoodItemArray.sorted(by: {$0.name < $1.name})
        }
        else {
            SortedFoodItemArray = FoodItemArray
        }
    }
    
    @IBAction func AddButtonClick(_ sender: Any) {
        FoodItemArray.append(FoodItem())
        processItems()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return SortedFoodItemArray.count
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)

        // Configure the cell...
        let indexRow = indexPath.row
        cell.textLabel?.text = foodItems[indexRow]

        return cell
    }
    */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as! FoodCell

        // Configure the cell...
        let indexRow = indexPath.row
        let fooditem = SortedFoodItemArray[indexRow]
        cell.FoodName.text = fooditem.name
        cell.FoodImage.image = UIImage(named: fooditem.image)
        cell.FoodCalories.text = fooditem.cals + " cals"
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let row = indexPath.row
            //var i : Int = 0
            for items in FoodItemArray{
                if (items.ID == SortedFoodItemArray[row].ID) {
                    FoodItemArray.remove(at: items.ID)
                }
            }
            SortedFoodItemArray.remove(at: row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            reassignIndex()
       // } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
       }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

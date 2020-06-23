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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FoodCell
        let indexRow = indexPath.row
        let fooditem = FoodItemArray[indexRow]
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings(completionHandler: { (settings) in if settings.alertSetting == .enabled {
            DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Food Notification", message: "Do you want to schedule a notification for \(fooditem.name)?", preferredStyle: .alert)
                    let noAction = UIAlertAction(title: "No", style: .default, handler: { (action) in
                    })
                    let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                        cell.FoodName.textColor = UIColor.red
                        fooditem.notif = true
                        self.scheduleNotification(foodname: fooditem.name, ID: fooditem.id)
                    })
                
                    alert.addAction(noAction)
                    alert.addAction(yesAction)
                    
                    self.present(alert, animated: true, completion: nil)
            }
            } else {
            print("Notifications Disabled")
            }
        })
    }
    
    func scheduleNotification(foodname : String, ID : String) {
        let content = UNMutableNotificationContent()
        content.title = "Food Alert"
        content.body = "Time to eat \(foodname)."
        content.userInfo["message"] = ID
        
        //Configure trigger for 5 seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        
        //Create Request
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        //Schedule request
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: { (error) in if let err = error {
            print(err.localizedDescription)
            }
            
        })
        
    }
    
    func handleNotification(_ response: UNNotificationResponse) {
        let message = response.notification.request.content.userInfo["message"] as! String
        print("received notification message: \(message)")
        for items in FoodItemArray{
            if (items.id == message) {
                items.notif = false
                tableView.reloadData()
            }
        }
    }
    
    @IBAction func AddButtonClick(_ sender: Any) {
        FoodItemArray.append(FoodItem())
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return FoodItemArray.count
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
        let fooditem = FoodItemArray[indexRow]
        cell.FoodName.text = fooditem.name
        cell.FoodImage.image = UIImage(named: fooditem.image)
        cell.FoodCalories.text = fooditem.cals + " cals"
        if (fooditem.notif == true) {
            cell.FoodName.textColor = UIColor.red
        } else {
            cell.FoodName.textColor = UIColor.black
        }
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
            FoodItemArray.remove(at: row)
            tableView.deleteRows(at: [indexPath], with: .fade)
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

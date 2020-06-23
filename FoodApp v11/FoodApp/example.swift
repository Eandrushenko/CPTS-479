//
//  TableViewController.swift
//  FoodApp
//
//  Created by Elijah Andrushenko on 4/15/20.
//  Copyright © 2020 Elijah Andrushenko. All rights reserved.
//

import UIKit
import CoreData

class example: UITableViewController {
    
    
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    
    var playerObjs: [NSManagedObject] = []
    
    @IBAction func addTapped(_ sender: Any) {
        let names = ["Mario", "Luigi", "Yoshi", "Princess Peach", "Bowser"]
        let name = names.randomElement()
        let health = Int.random(in: 1...200)
        let player = addPlayer(name: name!, health: health)
        playerObjs.append(player)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        removePlayersByName("Bowser")
        playerObjs = getPlayers()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return playerObjs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath)

        // Configure the cell...
        let row = indexPath.row
        let player = playerObjs[row]
        cell.textLabel?.text = player.value(forKey: "name") as? String
        let health = player.value(forKey: "health") as? Int
        cell.detailTextLabel?.text = "Health = \(health!)"

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
            let player = playerObjs[row]
            playerObjs.remove(at: row)
            removePlayer(player)
            tableView.deleteRows(at: [indexPath], with: .fade)
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
    func addPlayer(name: String, health: Int) -> NSManagedObject {
        let player = NSEntityDescription.insertNewObject(forEntityName: "Player", into: self.managedObjectContext)
        player.setValue(name, forKey: "name")
        player.setValue(health, forKey: "health")
        appDelegate.saveContext() // In AppDelegate.swift
        
        return player
    }
    
    func getPlayers() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Player")
        var players: [NSManagedObject] = []
        do {
            players = try self.managedObjectContext.fetch(fetchRequest)
        } catch {
            print("getPlayers error: \(error)")
        }
        return players
    }
    
    func printPlayer(_ player: NSManagedObject) {
        let name = player.value(forKey: "name") as? String
        let health = player.value(forKey: "health") as? Int
        print("Player: name = \(name!), health = \(health!)")
    }
    
    func removePlayersByName(_ name: String) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Player")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        var players: [NSManagedObject]!
        do {
            players = try self.managedObjectContext.fetch(fetchRequest)
        } catch {
            print("removePlayersByName error: \(error)")
        }
        for player in players {
            managedObjectContext.delete(player)
        }
        appDelegate.saveContext()
    }
    
    func removePlayer(_ player: NSManagedObject) {
        managedObjectContext.delete(player)
        appDelegate.saveContext()
    }
    
    
}

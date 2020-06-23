//
//  RecipeViewController.swift
//  FoodApp
//
//  Created by Elijah Andrushenko on 5/1/20.
//  Copyright © 2020 Elijah Andrushenko. All rights reserved.
//

import UIKit
import CoreLocation

class StatsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    var AllStates : [String] = ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]
    
    var AllAbbreviations : [String] = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
    
    var ABString : String = ""
    let locationManager = CLLocationManager()
    
    var i : Int = 0
    var CaseSwitch : Int = 0
    
    var counties : [String] = []
    var statistic : [String] = []
    var dates : [String] = []
    
    @IBOutlet weak var StateText: UILabel!
    @IBOutlet weak var InfectedButton: UIButton!
    @IBOutlet weak var DeathsButton: UIButton!
    @IBOutlet weak var DateText: UILabel!
    
        let headers = [
            "x-rapidapi-host": "coronavirus-monitor.p.rapidapi.com",
            "x-rapidapi-key": "6fa86cee98msh1094425f7f2f657p187932jsnb6cb8cc9d52d"
        ]

        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            
            StateTable.delegate = self
            StateTable.dataSource = self
            
            StateText.text = AllStates[i]
            getStateInfected(STATE: AllStates[i])
            
        }
    
    func LocationServices() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
        func FindState() {
            var STATE : String = ""
            if let lastLocation = self.locationManager.location {
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
                    if error == nil {
                        let firstLocation = placemarks?[0]
                        STATE = ((firstLocation?.administrativeArea)! as String)
                        //print(STATE)
                        self.ABString = STATE
                    }
                    else {
                        print("ERROR: Geocoding Issues")
                    }
                })
            }
            else {
                print("ERROR: No Location Was Available")
            }
        }
    
    
    @IBAction func MyStateClick(_ sender: Any) {
        var cur : Int = 0
        LocationServices()
        FindState()
        while (cur < AllAbbreviations.count) {
            if ABString == AllAbbreviations[cur] {
                //print(AllStates[cur])
                i = cur
                StateText.text = AllStates[i]
                DispatchQueue.main.async {
                    if (self.CaseSwitch == 0) {
                        self.getStateInfected(STATE: self.AllStates[self.i])
                    } else {
                        self.getStateDeaths(STATE: self.AllStates[self.i])
                    }
                }
                return
            }
            cur = cur + 1
            }
        let alert = UIAlertController(title: "Location Error", message: "Your location could not be found or your location is outside of the 50 States.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    @IBAction func ChangeStateClick(_ sender: Any) {
        i = i + 1
        if (i >= AllStates.count) {
            i = 0
        }
        StateText.text = AllStates[i]
        DispatchQueue.main.async {
            if (self.CaseSwitch == 0) {
            self.getStateInfected(STATE: self.AllStates[self.i])
            } else {
                self.getStateDeaths(STATE: self.AllStates[self.i])
            }
        }
    }
    
    @IBAction func InfectedClick(_ sender: Any) {
        InfectedButton.isEnabled = false
        DeathsButton.isEnabled = true
        
        CaseSwitch = 0
        
        getStateInfected(STATE: AllStates[i])
    }
    
    @IBAction func DeathsClick(_ sender: Any) {
        InfectedButton.isEnabled = true
        DeathsButton.isEnabled = false
        
        CaseSwitch = 1
        
        getStateDeaths(STATE: AllStates[i])
    }
    
        
    func getStateDeaths(STATE: String) {
        let linkState = STATE.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
            let url = URL(string: "https://coronavirus-monitor.p.rapidapi.com/coronavirus/johns_hopkins_latest_usa_statistic_by_state.php?state=\(linkState)")
            guard let requestUrl = url else { fatalError() }
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                if let response = response as? HTTPURLResponse {
                    print("Response HTTP Status code: \(response.statusCode)")
                    if response.statusCode != 200 {
                        return
                    }
                }
                do {
                    let somedata = data
                    let jsonObj = try JSONSerialization.jsonObject(with: somedata!)
                    let jsonDict1 = jsonObj as? [String: Any]
                    let StateArray = jsonDict1!["usa_deaths"] as? [Any]
                    var i = 0
                    
                    self.counties.removeAll()
                    self.statistic.removeAll()
                    self.dates.removeAll()
                    DispatchQueue.main.sync {
                    while (i < StateArray!.count) {
                        let jsonDict2 = StateArray![i] as? [String: Any]
                        
                        var countyName = jsonDict2!["state_name"] as? String
                        let deathCases = jsonDict2!["death_cases"] as? String
                        let recordDate = jsonDict2!["record_date"] as? String
                        
                        let wordToRemove = " " + STATE
                        if let range = countyName!.range(of: wordToRemove) {
                            countyName!.removeSubrange(range)
                        }
                        //print("county: \(countyName!) deaths: \(deathCases!) date: \(String(describing: recordDate!))" )
                        
                        self.counties.append(countyName!)
                        self.statistic.append(deathCases!)
                        self.dates.append(recordDate!)
                        
                        i = i + 1
                    }
                        
                        if (self.statistic.count == 0) {
                            self.counties.append("No Data Available")
                            self.statistic.append("X")
                            self.dates.append("N/A")
                        }
                    self.DateText.text = "\(STATE) Statistics Last Updated: \(self.dates[0])"
                    self.StateTable.reloadData()
                    }
                } catch let error as NSError {
                           print(error.localizedDescription)
                 }
            }
            task.resume()
    }
    
    func getStateInfected(STATE: String) {
            let linkState = STATE.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
            let url = URL(string: "https://coronavirus-monitor.p.rapidapi.com/coronavirus/johns_hopkins_latest_usa_statistic_by_state.php?state=\(linkState)")
            guard let requestUrl = url else { fatalError() }
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                if let response = response as? HTTPURLResponse {
                    print("Response HTTP Status code: \(response.statusCode)")
                    if response.statusCode != 200 {
                        return
                    }
                }

                do {
                    let somedata = data
                    let jsonObj = try JSONSerialization.jsonObject(with: somedata!)
                    let jsonDict1 = jsonObj as? [String: Any]
                    //print(jsonDict1!)
                    let StateArray = jsonDict1!["usa_cases_by_state"] as? [Any]
                    var i = 0
                    
                    self.counties.removeAll()
                    self.statistic.removeAll()
                    self.dates.removeAll()
                    DispatchQueue.main.sync {
                    while (i < StateArray!.count) {
                        let jsonDict2 = StateArray![i] as? [String: Any]
                        
                        var countyName = jsonDict2!["state_name"] as? String
                        let deathCases = jsonDict2!["cases_number"] as? String
                        let recordDate = jsonDict2!["record_date"] as? String
                        
                        let wordToRemove = " " + STATE
                        if let range = countyName!.range(of: wordToRemove) {
                            countyName!.removeSubrange(range)
                        }
                        //print("county: \(countyName!) cases: \(deathCases!) date: \(String(describing: recordDate!))" )
                        
                        self.counties.append(countyName!)
                        self.statistic.append(deathCases!)
                        self.dates.append(recordDate!)
                        
                        i = i + 1
                    }
                    
                    self.counties.remove(at: 0)
                    self.statistic.remove(at: 0)
                    self.dates.remove(at: 0)
                    
                        if (self.statistic.count == 0) {
                            self.counties.append("No Data Available")
                            self.statistic.append("X")
                            self.dates.append("N/A")
                        }
                    self.DateText.text = "\(STATE) Statistics Last Updated: \(self.dates[0])"
                    self.StateTable.reloadData()
                    }
                    
                } catch let error as NSError {
                           print(error.localizedDescription)
                 }
            }
            task.resume()
    }
    
    @IBOutlet weak var StateTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return counties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "statecell", for: indexPath)
        
        if (CaseSwitch == 0) {
            if (statistic[indexPath.row] == "X") {
                cell.textLabel?.text = counties[indexPath.row]
                cell.detailTextLabel?.text = " "
            } else {
                cell.textLabel?.text = counties[indexPath.row]
                cell.detailTextLabel?.text = "\(statistic[indexPath.row]) Infected"
            }
        } else {
            if (statistic[indexPath.row] == "1") {
                cell.textLabel?.text = counties[indexPath.row]
                cell.detailTextLabel?.text = "\(statistic[indexPath.row]) Death"
            } else if (statistic[indexPath.row] == "X") {
                cell.textLabel?.text = counties[indexPath.row]
                cell.detailTextLabel?.text = " "
            } else {
                cell.textLabel?.text = counties[indexPath.row]
                cell.detailTextLabel?.text = "\(statistic[indexPath.row]) Deaths"
            }
        }

        return cell
    }
    
            
}

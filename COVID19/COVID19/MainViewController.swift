//
//  ViewController.swift
//  COVID19
//
//  Created by Elijah Andrushenko on 5/1/20.
//  Copyright © 2020 Elijah Andrushenko. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var CoronaMap: UIImageView!
    @IBOutlet weak var MapText: UILabel!
    
    @IBOutlet weak var TotalCasesText: UILabel!
    @IBOutlet weak var TotalDeathsText: UILabel!
    @IBOutlet weak var ActiveCasesText: UILabel!
    @IBOutlet weak var NewCasesText: UILabel!
    @IBOutlet weak var NewDeathsText: UILabel!
    @IBOutlet weak var TotalRecoveredText: UILabel!
    @IBOutlet weak var SCCText: UILabel!
    @IBOutlet weak var Cases1MText: UILabel!
    @IBOutlet weak var Deaths1MText: UILabel!
    @IBOutlet weak var DateText: UILabel!
    
    
    
    let headers = [
        "x-rapidapi-host": "coronavirus-monitor.p.rapidapi.com",
        "x-rapidapi-key": "6fa86cee98msh1094425f7f2f657p187932jsnb6cb8cc9d52d"
    ]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        CoronaMap.image = UIImage(named: "CV19.png")
        MapText.text = "Image Last Updated: 2020/05/04 Obtained From: foreignpolicy.com"
        getWorlddata()
        
    }
    
    func getWorlddata() {
            let url = URL(string: "https://coronavirus-monitor.p.rapidapi.com/coronavirus/worldstat.php")
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
                    //print(jsonObj)
                    let jsonDict = jsonObj as? [String: Any]
                    DispatchQueue.main.sync {
                        let TC = jsonDict!["total_cases"] as? String
                        let TD = jsonDict!["total_deaths"] as? String
                        let AC = jsonDict!["active_cases"] as? String
                        let NC = jsonDict!["new_cases"] as? String
                        let ND = jsonDict!["new_deaths"] as? String
                        let TR = jsonDict!["total_recovered"] as? String
                        let SCC = jsonDict!["serious_critical"] as? String
                        let C1 = jsonDict!["total_cases_per_1m_population"] as? String
                        let D1 = jsonDict!["deaths_per_1m_population"] as? String
                        let Date = jsonDict!["statistic_taken_at"] as? String
                        
                        self.TotalCasesText.text = "Total Cases: \(TC!)"
                        self.TotalDeathsText.text = "Total Deaths: \(TD!)"
                        self.ActiveCasesText.text = "Active Cases: \(AC!)"
                        self.NewCasesText.text = "New Cases: \(NC!)"
                        self.NewDeathsText.text = "New Deaths: \(ND!)"
                        self.TotalRecoveredText.text = "Total Recovered: \(TR!)"
                        self.SCCText.text = "Serious/Critical Condition: \(SCC!)"
                        self.Cases1MText.text = "Cases per 1 Million Population: \(C1!)"
                        self.Deaths1MText.text = "Deaths per 1 Million Population \(D1!)"
                        self.DateText.text = "World Statistics Last Updated: \(Date!)"
                        
                        
                    }
                } catch let error as NSError {
                          print(error.localizedDescription)
                }
            }
            task.resume()
    }
}

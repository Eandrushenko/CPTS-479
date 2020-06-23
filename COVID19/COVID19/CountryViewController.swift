//
//  CountryViewController.swift
//  COVID19
//
//  Created by Elijah Andrushenko on 5/4/20.
//  Copyright © 2020 Elijah Andrushenko. All rights reserved.
//

import UIKit

class CountryViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchBar: UITextField!
    
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
    
    @IBOutlet weak var NationTitle: UILabel!
    
    @IBOutlet weak var FlagImage: UIImageView!
    
    
    
    @IBAction func SearchButton(_ sender: Any) {
        var country = searchBar.text!
        let lower = country.lowercased()
        if (lower == "united states" || lower == "united states of america" || lower == "america") {
            country = "usa"
        } else if (lower == "united arab emirates") {
            country = "uae"
        } else if (lower == "united kingdom" || lower == "britain") {
            country = "uk"
        }
        print(country)
        if (country != "") {
            getCountrydata(Country: country)
        }
    
    }
    
    let headers = [
        "x-rapidapi-host": "coronavirus-monitor.p.rapidapi.com",
        "x-rapidapi-key": "6fa86cee98msh1094425f7f2f657p187932jsnb6cb8cc9d52d"
    ]
    
    var Country : String = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        
        self.errormessage(word: " ")
        TotalCasesText.isHidden = true
        
    }
    
    func errormessage(word : String) {
        TotalCasesText.text = "Could not find data on \"\(word)\""
        TotalCasesText.isHidden = false
        TotalDeathsText.isHidden = true
        ActiveCasesText.isHidden = true
        NewCasesText.isHidden = true
        NewDeathsText.isHidden = true
        TotalRecoveredText.isHidden = true
        SCCText.isHidden = true
        Cases1MText.isHidden = true
        Deaths1MText.isHidden = true
        DateText.isHidden = true
        NationTitle.isHidden = true
        FlagImage.isHidden = true
    }
    
    func success() {
        TotalCasesText.isHidden = false
        TotalDeathsText.isHidden = false
        ActiveCasesText.isHidden = false
        NewCasesText.isHidden = false
        NewDeathsText.isHidden = false
        TotalRecoveredText.isHidden = false
        SCCText.isHidden = false
        Cases1MText.isHidden = false
        Deaths1MText.isHidden = false
        DateText.isHidden = false
        NationTitle.isHidden = false
        FlagImage.isHidden = false
    }
    
    func flagfinder(country: String) {
        let lower = country.lowercased()
        FlagImage.image = UIImage(named: "Flags/\(lower).png")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        var country = searchBar.text!
        let lower = country.lowercased()
        if (lower == "united states" || lower == "united states of america" || lower == "america") {
            country = "usa"
        } else if (lower == "united arab emirates") {
            country = "uae"
        } else if (lower == "united kingdom" || lower == "britain") {
            country = "uk"
        }
        print(country)
        if (country != "") {
            getCountrydata(Country: country)
        }
        return true
    }
    
    func getCountrydata(Country: String) {
        let urlStr = "https://coronavirus-monitor.p.rapidapi.com/coronavirus/latest_stat_by_country.php?country=\(Country)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let url = URL(string: urlStr)
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
                        DispatchQueue.main.async {
                            self.errormessage(word: Country)
                        }
                        return
                    }
                }
                do {
                    let somedata = data
                    let jsonObj = try JSONSerialization.jsonObject(with: somedata!)
                    let jsonDict = jsonObj as? [String: Any]
                    let NationArray = jsonDict!["latest_stat_by_country"] as? [Any]
                    let jsonDict2 = NationArray![0] as? [String: Any]
                    //print(jsonDict!)
                    DispatchQueue.main.sync {
                        let TC = jsonDict2!["total_cases"] as? String
                        let TD = jsonDict2!["total_deaths"] as? String
                        let AC = jsonDict2!["active_cases"] as? String
                        let NC = jsonDict2!["new_cases"] as? String
                        let ND = jsonDict2!["new_deaths"] as? String
                        let TR = jsonDict2!["total_recovered"] as? String
                        let SCC = jsonDict2!["serious_critical"] as? String
                        let C1 = jsonDict2!["total_cases_per1m"] as? String
                        let D1 = jsonDict2!["deaths_per1m"] as? String
                        let Date = jsonDict2!["record_date"] as? String
                        let CN = jsonDict2!["country_name"] as? String
                        
                        if (TC != nil) {
                            self.TotalCasesText.text = "Total Cases: \(TC!)"
                        } else {
                            self.TotalCasesText.text = "Total Cases: N/A"
                        }
                        if (TD != nil) {
                            self.TotalDeathsText.text = "Total Deaths: \(TD!)"
                        } else {
                            self.TotalDeathsText.text = "Total Deaths: N/A"
                        }
                        
                        if (AC != nil) {
                            self.ActiveCasesText.text = "Active Cases: \(AC!)"
                        } else {
                            self.ActiveCasesText.text = "Active Cases: N/A"
                        }
                        
                        if (NC != nil) {
                            self.NewCasesText.text = "New Cases: \(NC!)"
                        } else {
                            self.NewCasesText.text = "New Cases: N/A"
                        }
                        
                        if (ND != nil) {
                            self.NewDeathsText.text = "New Deaths: \(ND!)"
                        } else {
                            self.NewDeathsText.text = "New Deaths: N/A"
                        }
                        
                        if (TR != nil) {
                            self.TotalRecoveredText.text = "Total Recovered: \(TR!)"
                        } else {
                            self.TotalRecoveredText.text = "Total Recovered: N/A"
                        }
                        
                        if (SCC != nil) {
                            self.SCCText.text = "Serious/Critical Condition: \(SCC!)"
                        } else {
                            self.SCCText.text = "Serious/Critical Condition: N/A"
                        }
                        
                        if (C1 != nil) {
                            self.Cases1MText.text = "Cases per 1 Million Population: \(C1!)"
                        } else {
                            self.Cases1MText.text = "Cases per 1 Million Population: N/A"
                        }
                        
                        if (D1 != nil) {
                            self.Deaths1MText.text = "Deaths per 1 Million Population: \(D1!)"
                        } else {
                            self.Deaths1MText.text = "Deaths per 1 Million Population: N/A"
                        }
                        
                        if (Date != nil) {
                            self.DateText.text = "World Statistics Last Updated: \(Date!)"
                        } else {
                            self.DateText.text = "World Statistics Last Updated: N/A"
                        }
                        
                        if (CN != nil) {
                            self.NationTitle.text = CN!
                        } else {
                            self.NationTitle.text = "N/A"
                        }
                        
                        self.flagfinder(country: Country)
                        self.success()
                    }
                } catch let error as NSError {
                          print(error.localizedDescription)
                          DispatchQueue.main.async {
                              self.errormessage(word: Country)
                          }
                }
            }
            task.resume()
    }

}

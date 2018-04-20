//
//  CurrenciesViewController.swift
//  ExchangeMate
//
//  Created by Ross Maniaci on 4/14/18.
//  Copyright © 2018 Ross Maniaci. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CurrenciesViewController: UITableViewController {
    var currencyArray = [Currency]() // Declare an array of Currency structures.
    
    // Use viewDidLoad in this case because it is assumed that the API key is used on the Developer Plan for this application.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Clean up the navigation bar for consistency.
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.title = "ExchangeMate"
        
        // API key assumed to be constant.
        let appId = "c59e6006363347f9962ed7e969680ba7"
        fetchCurrencyData(appId: appId)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Resets the title to ExchangeMate when coming from the Conversion View Controller.
    override func viewWillAppear(_ animated: Bool) {
        self.title = "ExchangeMate"
        super .viewWillAppear(animated)
    }
    
    // Alamofire replaces NSURLSession and SwiftyJSON replaces NSJSONSerialization for purposes of efficiency.
    func fetchCurrencyData(appId: String) {
        Alamofire.request("https://openexchangerates.org/api/latest.json?app_id=\(appId)").responseJSON { (responseData) -> Void in
            if ((responseData.result.value) != nil) {
                let swiftyJSON = JSON(responseData.result.value!)
                
                // Retrieve the Unix timestamp and convert it to formatted date.
                let timestamp = swiftyJSON["timestamp"].double
                let date = Date(timeIntervalSince1970: timestamp!)
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
                dateFormatter.dateFormat = "MM/dd/yyyy"
                let dateString = dateFormatter.string(from: date)
                
                // Retrieve currency names and exchange rates.
                let ratesJSON = JSON(swiftyJSON["rates"])
                var jsonArray = [Currency]()
                
                for (key, value) in ratesJSON {
                    let aCurrency = Currency(name: key, dateString:dateString, exchangeRate: value.doubleValue)
                    jsonArray.append(aCurrency)
                }
                
                self.currencyArray = jsonArray.sorted(by: { $0.name < $1.name })
                
                if self.currencyArray.count > 0 {
                    self.tableView.reloadData()
                }
            }
                
            else { // Alert user when unable to connect to server.
                let alertController = UIAlertController(title: "Error", message:
                    "Unable to connect to server", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> CustomCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        self.tableView.rowHeight = 84
        let aCurrency = currencyArray[indexPath.row]
        cell.configure(name: aCurrency.name, dateString: aCurrency.dateString, exchangeString: ((String)(aCurrency.exchangeRate)))
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Equivalent of didSelectRowAtIndexPath.
        let selectedIndex = self.tableView.indexPath(for: sender as! CustomCell)
        let aCurrency = currencyArray[(selectedIndex?.row)!]
        
        // Pass selected currency to Conversion View Controller.
        let conversionController = segue.destination as! ConversionViewController
        conversionController.currency = aCurrency
    }
}

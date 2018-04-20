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
    var nameArray = [String]() // Declare an array of type String to easily sort currency names in alphabetical order.
    var exchangeDictionary = [String: Double]() // Declare an array of type Dictionary to provide currency values for keys.
    var dateString: String! // The date is constant between cells so it does not need to be in an array or dictionary.
    
    // Use viewDidLoad in this case because it is assumed that the API key is used on the Developer Plan for this application.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Clean up the navigation bar.
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
    }
    
    func fetchCurrencyData(appId: String) {
        // Alamofire replaces NSURLSession and SwiftyJSON replaces NSJSONSerialization for purposes of efficiency.
        Alamofire.request("https://openexchangerates.org/api/latest.json?app_id=\(appId)").responseJSON { (responseData) -> Void in
            if ((responseData.result.value) != nil) {
                let swiftyJSON = JSON(responseData.result.value!)
                
                // Retrieve the Unix timestamp and convert it to formatted date.
                let timestamp = swiftyJSON["timestamp"].double
                let date = Date(timeIntervalSince1970: timestamp!)
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
                dateFormatter.dateFormat = "MM/dd/yyyy"
                self.dateString = dateFormatter.string(from: date)
                
                // Retrieve currency names and exchange rates.
                let ratesJSON = JSON(swiftyJSON["rates"])
                for (key, value) in ratesJSON {
                    self.exchangeDictionary[key] = value.doubleValue
                }
                
                // Sort the array of currencies by dictionary key in alphabetical order.
                let jsonArray = [String](self.exchangeDictionary.keys)
                self.nameArray = jsonArray.sorted(by: <)
                
                // Reload tableView with currency names and rates.
                if self.nameArray.count > 0 {
                    self.tableView.reloadData()
                }
            }
                
            else { // Alert user when unable to connect to server
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
        return nameArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        // Configure the CustomCell.
        self.tableView.rowHeight = 84
        let name = nameArray[indexPath.row]
        let exchangeRate = (exchangeDictionary[name])
        cell.configure(name: name, dateString: dateString, exchangeString: ((String)(exchangeRate!)))
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // Equivalent of didSelectRowAtIndexPath.
        let selectedIndex = self.tableView.indexPath(for: sender as! CustomCell)
        let name = nameArray[(selectedIndex?.row)!]
        let exchangeRate = (exchangeDictionary[name])
        let conversionController = segue.destination as! ConversionViewController
        
        // Pass name and exchange rate to Conversion View Controller.
        conversionController.name = name
        conversionController.exchangeRate = exchangeRate!
    }
}

// Declare name, date, and exchange rate labels for custom UITableViewCell.
class CustomCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel! // Name of currency
    @IBOutlet weak var dateLabel: UILabel! // Date exchange rates fetched from API.
    @IBOutlet weak var exchangeLabel: UILabel! // Exchange rate of currency
    
    // Configure the CustomCell.
    func configure (name: String, dateString: String, exchangeString: String) {
        nameLabel?.text = name
        dateLabel?.text = dateString // Date is constant regardless of currency because it is retrieved from timestamp.
        exchangeLabel.text = exchangeString
    }
}

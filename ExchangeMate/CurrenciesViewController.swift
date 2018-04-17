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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Using viewWillAppear allows for the latest currency rates to be displayed every time CurrenciesViewController appears.
    override func viewWillAppear(_ animated: Bool) {
        let appId = "c59e6006363347f9962ed7e969680ba7" // API key assumed to be constant.
        
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
                
                let jsonArray = [String](self.exchangeDictionary.keys)
                self.nameArray = jsonArray.sorted(by: <)
                
                // Sort the array of currencies by dictionary key in alphabetical order.
                
                
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
        
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

        // Create single object arrays corresponding to the dictionary key and value.
        // let cellDictionary = currencyArray[indexPath.row]
        // let namesArray = [String](cellDictionary.keys)
        // let exchangesArray = [Double](cellDictionary.values)
        
        // Configure the CustomCell.
        self.tableView.rowHeight = 84
        let name = nameArray[indexPath.row]
        cell.nameLabel?.text = name
        cell.dateLabel?.text = dateString // Date is constant regardless of currency because it is retrieved from timestamp.
        // cell.exchangeLabel.text = (String)(exchangesArray[0])
        let exchangeRate = (exchangeDictionary[name])
        cell.exchangeLabel.text = (String)(exchangeRate!)
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // Equivalent of didSelectRowAtIndexPath
        let selectedIndex = self.tableView.indexPath(for: sender as! CustomCell)
        let name = nameArray[(selectedIndex?.row)!]
        let exchangeRate = (exchangeDictionary[name])
        let conversionController = segue.destination as! ConversionViewController
        conversionController.name = name
        conversionController.exchangeRate = exchangeRate!
        // conversionController.cellDictionary = cellDictionary // Pass the Dictionary object to the ConversionViewController
    }
}

// Declare name, date, and exchange rate labels for custom UITableViewCell.
class CustomCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var exchangeLabel: UILabel!
}

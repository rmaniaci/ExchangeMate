//
//  ConversionViewController.swift
//  ExchangeMate
//
//  Created by Ross Maniaci on 4/14/18.
//  Copyright © 2018 Ross Maniaci. All rights reserved.
//

// Conversion View Controller text field
// Test calculation
// UI Tests
// GitHub

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    var name: String!
    var exchangeRate: Double!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var exchangeLabel: UILabel!
    @IBOutlet weak var conversionField: UITextField!
    @IBOutlet weak var conversionLabel: UILabel!
    @IBOutlet weak var conversionButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Clean up the navigation bar.
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.topItem!.title = ""
        self.title = name
        
        // Populate the name and the exchange labels.
        nameLabel.text = name
        exchangeLabel.text = (String)(exchangeRate)
        
        // Initialize the conversion text field.
        self.conversionField.delegate = self
        self.conversionField.text = ""
        self.conversionField.keyboardType = UIKeyboardType.decimalPad
        conversionButton.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Require conversionField to allow a maximum of two decimal places as part of currency format.
    func textField(_ conversionField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Capture the text in the field.
        let newText = (conversionField.text! as NSString).replacingCharacters(in: range, with: string)
        let regex = try! NSRegularExpression(pattern: "\\..{3,}", options: [])
        let matches = regex.matches(in: newText, options:[], range:NSMakeRange(0, newText.count))
        guard matches.count == 0
            else { return false }
        
        switch string {
        // Digits so nothing needs to be done here.
        case "0","1","2","3","4","5","6","7","8","9":
            return true
        
        // Decimal point so limit to two places.
        case ".":
            let array = conversionField.text?.map { String($0) }
            var decimalCount = 0
            
            for character in array! {
                if character == "." {
                    decimalCount += 1
                }
            }
            
            if decimalCount == 1 {
                return false
            }
            
            else {
                return true
            }
            
        default:
            let array = string.map { String($0) }
            if array.count == 0 {
                return true
            }
            
            return false
        }
    }
    
    // Convert dollar input to displayed currency based on the exchange rate.
    @IBAction func conversion(sender: UIButton) {
        if (self.conversionField.text != "") {
            let currency = Double(conversionField.text!)
            
            // Clear the conversion text field.
            conversionField.text = ""
            conversionField .resignFirstResponder()
            
            // Multiply the amount to be converted by the exchange rate and display it in the conversion label.
            let exchange = Double(exchangeLabel.text!)
            let conversion = String(format: "%.2f", (currency! * exchange!))
            
            // Limit the conversion label to 18 digits including the decimal place for readability purposes.
            if conversion.count <= 18 {
                conversionLabel.text = conversion
            }
            
            else {
                let alertController = UIAlertController(title: "Error", message:
                    "Please enter a smaller dollar amount", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

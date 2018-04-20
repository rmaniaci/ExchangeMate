//
//  CustomCell.swift
//  ExchangeMate
//
//  Created by Ross Maniaci on 4/14/18.
//  Copyright © 2018 Ross Maniaci. All rights reserved.
//

import UIKit

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

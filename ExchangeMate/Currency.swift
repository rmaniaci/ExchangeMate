//
//  Currency.swift
//  ExchangeMate
//
//  Created by Ross Maniaci on 4/14/18.
//  Copyright © 2018 Ross Maniaci. All rights reserved.
//

import UIKit

// A simple structure that represents a currency based on names and exchange rates fetched from the OpenExchange API.
struct Currency {
    let name: String
    let dateString: String
    let exchangeRate: Double
}

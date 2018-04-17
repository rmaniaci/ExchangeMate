# ExchangeMate

## Synopsis

ExchangeMate is a simple iPhone app written in Swift that displays the latest currency rates based on the price of USD from the [Open Exchange API](https://docs.openexchangerates.org/docs). The app fetches the latest exchange rate data and displays it in a table along with the corresponding currency symbol and today's date.

The user then selects a currency from the table and opens up a second screen showing the details about that specific currency. The user can then input an amount in US dollars and convert the US dollars amount to that of the selected currency.

## Compile and Run

This program was developed with iOS version 11.3, Xcode version 9.3, and Swift 4.

Cocoapods is used for dependency management.
Alamofire is used for HTTP networking.
SwiftyJSON is used for JSON networking.

Be sure to open the .xcworkspace rather than the .xcodeproj in order to compile and run the project.

Fill in the appID variable with your own API key.

## License

MIT license as described in the LICENSE file.

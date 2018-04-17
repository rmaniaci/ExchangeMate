# ExchangeMate

## Synopsis

ExchangeMate is a simple iPhone app written in Swift that displays the latest currency rates based on the price of USD from the [Open Exchange API](https://docs.openexchangerates.org/docs). The app fetches the latest exchange rate data and displays it in a table along with the corresponding currency symbol and today's date.

The user then selects a currency from the table and opens up a second screen showing the details about that specific currency. The user can then input an amount in US dollars and convert the US dollars amount to that of the selected currency.

## Compile and Run

This program was developed with iOS version 11.3, Xcode version 9.3, and Swift 4.

First navigate to the RMSpellChecker folder inside the RMSpellChecker project.

```
/path/to/the/files/RMSpellChecker/RMSpellChecker
```

Compile the program using Clang by entering the following command.

```
$ clang -fobjc-arc -framework Foundation main.m RMSpellChecker.m -o RMSpellChecker
```

To run the program using the given format (echo and pipe) enter the following command.

```
$ echo 'misspelledword' | ./RMSpellChecker
correctlyspelledword
```

If the program cannot find a correctly spelled suggestion, it will return "NO SUGGESTION".

## Tests

This program was tested with developed with iOS version 11.3, Xcode version 9.3, and Swift 4.

First navigate to the RMSpellChecker project.

```
/path/to/the/files/RMSpellChecker/
```

To run unit tests from the command line using the xctest framework, enter the following command:

```
$ xcodebuild test -project RMSpellChecker.xcodeproj -scheme RMSpellChecker -destination 'platform=OS X,arch=x86_64'
```

## License

MIT license as described in the LICENSE file.

# WallapopMarvel #

## Setup ##

Run `bin/setup`

This will:

- Install the gem dependencies
- Install the Carthage dependencies
- Install homebrew and SwiftGen (I'm using SwiftGen for image and localization statics)

## API Keys ##

The project expects a keys.plist to exist in the project. It's not included in this repo. In order to make this project work you should create that keys.plist with keys:

- marvelPrivateAPIKey
- marvelPublicAPIKey

## Testing ##

Run `bin/test`

This will run the tests from the command line, and pipe the result through
[XCPretty][].

[XCPretty]: https://github.com/supermarin/xcpretty

## 3rd Party libraries used ##

- ReactiveCocoa - I ❤️ FRP
- Reusable - Because using strings as cell identifiers is ugly as hell
- Moya - I love the idea of using an enum for API and it works really well
- Gloss - My choice for json parsing on swift
- Moya-Gloss - Moya&Gloss helpers
- Kingfisher - Cell and cover images set to an UIImageView
- CryptoSwift - To calculate marvel hash

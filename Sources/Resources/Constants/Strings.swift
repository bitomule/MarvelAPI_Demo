// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
enum L10n {
  /// Marvelpop
  case comicsCoversTitle
  /// Ups. We can't found that
  case notFoundBody
  /// Not found
  case notFoundTitle
}
// swiftlint:enable type_body_length

extension L10n: CustomStringConvertible {
  var description: String { return self.string }

  var string: String {
    switch self {
      case .comicsCoversTitle:
        return L10n.tr(key: "comics_covers_title")
      case .notFoundBody:
        return L10n.tr(key: "not_found_body")
      case .notFoundTitle:
        return L10n.tr(key: "not_found_title")
    }
  }

  private static func tr(key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

func tr(_ key: L10n) -> String {
  return key.string
}

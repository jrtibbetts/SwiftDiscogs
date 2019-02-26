// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// All of Discogs
  internal static let allOfDiscogsSearchScopeTitle = L10n.tr("SwiftDiscogsApp", "allOfDiscogsSearchScopeTitle")
  /// Bio
  internal static let artistBioSectionHeader = L10n.tr("SwiftDiscogsApp", "artistBioSectionHeader")
  /// Releases
  internal static let artistReleasesSectionHeader = L10n.tr("SwiftDiscogsApp", "artistReleasesSectionHeader")
  /// Discogs sign-in failed
  internal static let discogsSignInFailed = L10n.tr("SwiftDiscogsApp", "discogsSignInFailed")
  /// My Collection
  internal static let userCollectionSearchScopeTitle = L10n.tr("SwiftDiscogsApp", "userCollectionSearchScopeTitle")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}

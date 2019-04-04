// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// Bio
  internal static let artistBioSectionHeader = L10n.tr("SwiftDiscogsApp", "artistBioSectionHeader")
  /// Releases
  internal static let artistReleasesSectionHeader = L10n.tr("SwiftDiscogsApp", "artistReleasesSectionHeader")
  /// Cat. #
  internal static let catalogNumberShort = L10n.tr("SwiftDiscogsApp", "catalogNumberShort")
  /// Country
  internal static let country = L10n.tr("SwiftDiscogsApp", "country")
  /// Discogs sign-in failed
  internal static let discogsSignInFailed = L10n.tr("SwiftDiscogsApp", "discogsSignInFailed")
  /// Format
  internal static let format = L10n.tr("SwiftDiscogsApp", "format")
  /// Label
  internal static let label = L10n.tr("SwiftDiscogsApp", "label")
  /// Lyrics
  internal static let lyrics = L10n.tr("SwiftDiscogsApp", "lyrics")
  /// Personnel
  internal static let personnel = L10n.tr("SwiftDiscogsApp", "personnel")
  /// Title
  internal static let title = L10n.tr("SwiftDiscogsApp", "title")
  /// Tracklist
  internal static let tracklist = L10n.tr("SwiftDiscogsApp", "tracklist")
  /// Versions
  internal static let versions = L10n.tr("SwiftDiscogsApp", "versions")
  /// Year
  internal static let year = L10n.tr("SwiftDiscogsApp", "year")
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

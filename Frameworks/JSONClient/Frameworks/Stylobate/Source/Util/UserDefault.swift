//  Copyright © 2020 Poikile Creations. All rights reserved.

import Foundation

/// A property wrapper for values stored in `UserDefaults`. Use one by passing
/// in the key to store it with, along with a default value to be returned if
/// the value isn't already in the defaults (which are, ahem, by default,
/// `UserDefaults.standard`).
///
/// ```
/// @UserDefault(key: "captionSize", defaultValue: 24.0)
/// var captionSize: CGFloat
/// ```
///
/// This is mind-blowing.
///
/// @see https://www.avanderlee.com/swift/property-wrappers/
@propertyWrapper
public struct UserDefault<T> {

    let defaultValue: T

    let key: String

    let userDefaults: UserDefaults

    public init(key: String,
                defaultValue: T,
                userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    public var wrappedValue: T {

        get {
            return userDefaults.object(forKey: key) as? T ?? defaultValue
        }

        set {
            userDefaults.set(newValue, forKey: key)
        }

    }

}

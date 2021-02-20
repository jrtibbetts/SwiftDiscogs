//  Copyright © 2017 nrith. All rights reserved.

import Foundation

// MARK: - <~ (Block assignment)

infix operator <~

/// Invoke a passed-in function on an object, then return the object.
///
/// (Based on [Stylish UI Extensions](https://medium.com/@cjbrady/the-mutate-operator-9f3ef3bcd90e).)
///
/// - parameter object: The object that's passed to the function, and returned.
/// - parameter function: The function that gets invoked on `object`.
///
/// - returns: The object that was passed in. It can be ignored if you don't
///   need to chain calls to it.
@discardableResult public func <~ <T>(object: T, function: (T) -> Void) -> T {
    function(object)

    return object
}

// MARK: - =~ (Perl-style regular expression pattern match)

infix operator =~

/// Determine whether a regular expression pattern matches any part of a string.
/// Modified from [this StackOverflow answer]
// (http://stackoverflow.com/questions/27880650/swift-extract-regex-matches#27880748).
///
/// - parameter targetString: The string to be searched.
/// - parameter searchPattern: The regular expression pattern. It is always
///   case-sensitive, and searched the entire length of the target string. If
///   you want to do a case-insensitive search, or use other options, then
///   create an `NSRegularExpression` manually.
///
/// - returns: `true` if the pattern was found; `false` otherwise.
///
/// - throws: An exception if `searchPattern` is not a valid regular expression
/// pattern.
public func =~ (targetString: String, searchPattern: String) throws -> Bool {
    let regex = try NSRegularExpression(pattern: searchPattern, options: [])
    let nsString = NSString(string: targetString)

    return 0 < regex.numberOfMatches(in: targetString,
                                     options: [],
                                     range: NSRange(location: 0,
                                                    length: nsString.length))
}

//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Stylobate
import XCTest

extension Settings {

    @UserDefault(key: "someBooleanProperty", defaultValue: false)
    static var booleanProperty: Bool

    @UserDefault(key: "someIntProperty", defaultValue: 1564)
    static var intProperty: Int
}

class SettingsTests: XCTestCase {

    func testBooleanSetting() {
        Settings.booleanProperty = false
        XCTAssertFalse(Settings.booleanProperty)
    }

    func testUnsetIntSettingReturnsDefaultValue() {
        Settings.intProperty = 1616
        XCTAssertEqual(Settings.intProperty, 1616)
    }

}

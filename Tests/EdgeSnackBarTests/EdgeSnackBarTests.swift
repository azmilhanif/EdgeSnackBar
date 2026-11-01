#if canImport(UIKit)
import XCTest
@testable import EdgeSnackBar

final class EdgeSnackBarTests: XCTestCase {

    func testNormalStyleHasNoIcon() {
        XCTAssertNil(EdgeSnackBar.Style.normal.iconName)
    }

    func testOtherStylesHaveIcons() {
        for style in EdgeSnackBar.Style.allCases where style != .normal {
            XCTAssertNotNil(style.iconName)
            XCTAssertNotNil(UIImage(systemName: style.iconName!))
        }
    }

    func testFilledStylesUseFilledForeground() {
        let appearance = EdgeSnackBar.Appearance(filledForeground: .yellow)
        XCTAssertEqual(EdgeSnackBar.Style.success.foreground(in: appearance), .yellow)
        XCTAssertEqual(EdgeSnackBar.Style.error.actionColor(in: appearance), .yellow)
    }

    func testNeutralActionUsesAccent() {
        let appearance = EdgeSnackBar.Appearance(accentColor: .purple)
        XCTAssertEqual(EdgeSnackBar.Style.info.actionColor(in: appearance), .purple)
    }
}
#endif

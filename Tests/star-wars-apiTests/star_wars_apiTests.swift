import XCTest
@testable import star_wars_api

final class star_wars_apiTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(star_wars_api().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

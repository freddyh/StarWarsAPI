import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(star_wars_apiTests.allTests),
    ]
}
#endif

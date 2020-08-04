import XCTest
import Combine
@testable import star_wars_api

final class star_wars_apiTests: XCTestCase {
    var cancellabes: Set<AnyCancellable> = []
    
    func testPeople() {
        let exp = expectation(description: "Completion block called")
        StarWarsAPI.peoplePublisher()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error): XCTFail(error.localizedDescription)
                default: break
                }
            }) { (people) in
                exp.fulfill()
                XCTAssert(people.count > 0)
            }.store(in: &cancellabes)
        waitForExpectations(timeout: 8, handler: nil)
    }

    static var allTests = [
        ("testPeople", testPeople),
    ]
}

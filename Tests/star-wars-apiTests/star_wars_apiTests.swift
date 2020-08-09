import XCTest
import Combine
@testable import star_wars_api

final class star_wars_apiTests: XCTestCase {
    var cancellabes: Set<AnyCancellable> = []
    
    func testPeopleListPublisher() {
        let exp = expectation(description: "Completion block called")
        StarWarsAPI.peopleListPublisher()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error): XCTFail(error.localizedDescription)
                case .finished: exp.fulfill()
                }
            }) { (people) in
                XCTAssert(people.count > 0)
            }.store(in: &cancellabes)
        waitForExpectations(timeout: 8, handler: nil)
    }

    func testPersonPublisher() {
        let exp = expectation(description: "Completion block called")
        StarWarsAPI.personPublisher(id: 1)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error): XCTFail(error.localizedDescription)
                case .finished: exp.fulfill()
                }
            }) { (person) in
                XCTAssert(person.name == "Luke Skywalker")
            }.store(in: &cancellabes)
        waitForExpectations(timeout: 8, handler: nil)
    }
    
    func testPersonPublishers() {
        let exp = expectation(description: "Completion block called")
        StarWarsAPI.personPublishers(ids: [1, 2, 3])
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error): XCTFail(error.localizedDescription)
                case .finished: exp.fulfill()
                }
            }) { (res) in
                print(res.name)
                XCTAssertNotNil(res)
            }.store(in: &cancellabes)
        waitForExpectations(timeout: 8, handler: nil)
    }

    static var allTests = [
        ("testPeopleListPublisher", testPeopleListPublisher),
        ("testPersonPublisher", testPersonPublisher),
        ("testPersonPublishers", testPersonPublishers)
    ]
}

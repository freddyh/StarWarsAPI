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
    
    func testRootPublisher() {
        let exp = expectation(description: "Completion block called")
        StarWarsAPI.rootPublisher().sink { (completion) in
            switch completion {
            case .failure(let error): XCTFail(error.localizedDescription)
            case .finished: exp.fulfill()
            }
        } receiveValue: { (root) in
            XCTAssert(root.films == "http://swapi.dev/api/films/")
            XCTAssert(root.planets == "http://swapi.dev/api/planets/")
            XCTAssert(root.species == "http://swapi.dev/api/species/")
            XCTAssert(root.starships == "http://swapi.dev/api/starships/")
            XCTAssert(root.vehicles == "http://swapi.dev/api/vehicles/")
            XCTAssert(root.people == "http://swapi.dev/api/people/")
        }.store(in: &cancellabes)
        waitForExpectations(timeout: 8, handler: nil)
    }

    static var allTests = [
        ("testPeopleListPublisher", testPeopleListPublisher),
        ("testPersonPublisher", testPersonPublisher),
        ("testPersonPublishers", testPersonPublishers),
        ("testRootPublisher", testRootPublisher)
    ]
}

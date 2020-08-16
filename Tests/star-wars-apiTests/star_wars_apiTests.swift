import XCTest
import Combine
@testable import star_wars_api

final class star_wars_apiTests: XCTestCase {
    var cancellabes: Set<AnyCancellable> = []
    
    func testFilmPublishers() {
        let titles = ["A New Hope", "The Empire Strikes Back", "Return of the Jedi"]
        let exp = expectation(description: "Completion block called")
        StarWarsAPI.filmPublishers(ids: [1, 2, 3])
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error): XCTFail(error.localizedDescription)
                case .finished: exp.fulfill()
                }
            }) { (film) in
                XCTAssert(titles.contains(film.title))
            }.store(in: &cancellabes)
        waitForExpectations(timeout: 8, handler: nil)
    }
    
    func testFilmListPublisher() {
        let exp = expectation(description: "Completion block called")
        StarWarsAPI.filmListPublisher()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error): XCTFail(error.localizedDescription)
                case .finished: exp.fulfill()
                }
            }) { (films) in
                XCTAssert(films.count > 0)
            }.store(in: &cancellabes)
        waitForExpectations(timeout: 8, handler: nil)
    }
    
    func testFilmPublisher() {
        let exp = expectation(description: "Completion block called")
        StarWarsAPI.filmPublisher(id: 1)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error): XCTFail(error.localizedDescription)
                case .finished: exp.fulfill()
                }
            }) { (film) in
                XCTAssert(film.title == "A New Hope")
            }.store(in: &cancellabes)
        waitForExpectations(timeout: 8, handler: nil)
    }
    
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
        let names = ["C-3PO", "Luke Skywalker", "R2-D2"]
        let exp = expectation(description: "Completion block called")
        StarWarsAPI.personPublishers(ids: [1, 2, 3])
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error): XCTFail(error.localizedDescription)
                case .finished: exp.fulfill()
                }
            }) { (person) in
                XCTAssert(names.contains(person.name))
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
        ("testFilmPublishers", testFilmPublishers),
        ("testFilmListPublisher", testFilmListPublisher),
        ("testFilmPublisher", testFilmPublisher),
        ("testPeopleListPublisher", testPeopleListPublisher),
        ("testPersonPublisher", testPersonPublisher),
        ("testPersonPublishers", testPersonPublishers),
        ("testRootPublisher", testRootPublisher)
    ]
}

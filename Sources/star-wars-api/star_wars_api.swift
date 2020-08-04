import Combine
import Foundation

public struct StarWarsAPI {
    
    struct PeopleWrapper: Codable {
        let results: [Person]
    }
    
    public struct Person: Codable {
        let name: String
        let height: String
        let mass: String
        let homeWorld: String?
        let films: [String]
        let url: String
        let created: String
        let edited: String
    }
    
    public struct APIError: Error {
        let reason: String
    }
    
//    var cancellables: Set<AnyCancellable> = []
    
    public func peoplePublisher() -> AnyPublisher<[Person], APIError> {
        let url = URL(string: "https://swapi.dev/api/people")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map({ $0.data })
            .decode(type: PeopleWrapper.self, decoder: JSONDecoder())
            .map({ $0.results })
            .mapError({ (failure) -> APIError in
                return APIError(reason: failure.localizedDescription)
            })
            .eraseToAnyPublisher()
    }
}

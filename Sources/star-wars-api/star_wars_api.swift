import Combine
import Foundation

public struct StarWarsAPI {
    
    struct PeopleWrapper: Codable {
        let results: [Person]
    }
    
    public struct Person: Codable, Identifiable {
        public var id: String { name }
        public let name: String
        public let height: String
        public let mass: String
        public let homeWorld: String?
        public let films: [String]
        public let url: String
        public let created: String
        public let edited: String
    }
    
    public struct APIError: Error {
        let reason: String
    }
    
    public static func peoplePublisher() -> AnyPublisher<[Person], APIError> {
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

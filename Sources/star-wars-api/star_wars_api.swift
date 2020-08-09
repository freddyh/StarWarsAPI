import Combine
import Foundation

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
}

extension Endpoint {
    static var scheme: String { "https" }
    static var host: String { "swapi.dev" }
    static var root: String { "/api" }
    
    var url: URL {
        var components = URLComponents()
        components.scheme = Endpoint.scheme
        components.host = Endpoint.host
        components.path = Endpoint.root + path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }
        
        return url
    }
    
    static func peopleList() -> Self {
        Endpoint(path: "/people", queryItems: [])
    }
    
    static func people(id: Int) -> Self {
        Endpoint(path: "/people/\(id)", queryItems: [])
    }
}

public struct StarWarsAPI {
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
    
    public static func personPublishers(ids: [Int]) -> AnyPublisher<Person, APIError> {
        let publishers = ids.map(personPublisher(id:))
        return Publishers.MergeMany(publishers).prefix(ids.count).eraseToAnyPublisher()
    }
    
    public static func personPublisher(id: Int) -> AnyPublisher<Person, APIError> {
        let url = Endpoint.people(id: id).url
        return URLSession.shared.dataTaskPublisher(for: url)
            .map({ $0.data })
            .decode(type: Person.self, decoder: JSONDecoder())
            .mapError({ (failure) -> APIError in
                return APIError(reason: failure.localizedDescription)
            })
            .eraseToAnyPublisher()
    }
    
    public static func peopleListPublisher() -> AnyPublisher<[Person], APIError> {
        let url = Endpoint.peopleList().url
        return publisher(url: url) { (data) in
            struct PeopleWrapper: Codable {
                let results: [Person]
            }
            
            let wrapper = try? JSONDecoder().decode(PeopleWrapper.self, from: data)
            return wrapper?.results ?? []
        }
    }
    
    public static func publisher<T: Decodable>(url: URL, transform: @escaping (Data) -> T) -> AnyPublisher<T, APIError> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map({ $0.data })
            .map(transform)
            .mapError({ (failure) -> APIError in
                return APIError(reason: failure.localizedDescription)
            })
            .eraseToAnyPublisher()
    }
}

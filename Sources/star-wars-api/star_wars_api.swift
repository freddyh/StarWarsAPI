import Combine
import Foundation

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
}

extension Endpoint {
    static var scheme: String { "https" }
    static var host: String { "swapi.dev" }
    private static var rootPath: String { "/api" }
    
    var url: URL {
        var components = URLComponents()
        components.scheme = Endpoint.scheme
        components.host = Endpoint.host
        components.path = Endpoint.rootPath + path
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
    
    static func root() -> Self {
        Endpoint(path: "/", queryItems: [])
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
    
    public struct Root: Codable {
        public let films: String
        public let people: String
        public let planets: String
        public let species: String
        public let starships: String
        public let vehicles: String
    }
    
    public struct APIError: Error {
        let reason: String
    }
    
    // MARK: Root
    
    public static func rootPublisher() -> AnyPublisher<Root, APIError> {
        let url = Endpoint.root().url
        return decodePublisher(url: url)
    }
    
    // MARK: People
    
    public static func personPublishers(ids: [Int]) -> AnyPublisher<Person, APIError> {
        let publishers = ids.map(personPublisher(id:))
        return Publishers.MergeMany(publishers).prefix(ids.count).eraseToAnyPublisher()
    }
    
    public static func personPublisher(id: Int) -> AnyPublisher<Person, APIError> {
        let url = Endpoint.people(id: id).url
        return decodePublisher(url: url)
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
    
    public static func decodePublisher<T: Decodable>(url: URL) -> AnyPublisher<T, APIError> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map({ $0.data })
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError({ (failure) -> APIError in
                return APIError(reason: failure.localizedDescription)
            })
            .eraseToAnyPublisher()
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

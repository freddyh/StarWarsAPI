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
    
    static func planetsList() -> Self {
        Endpoint(path: "/planets", queryItems: [])
    }
    
    static func planets(id: Int) -> Self {
        Endpoint(path: "/planets/\(id)", queryItems: [])
    }
    
    static func speciesList() -> Self {
        Endpoint(path: "/species", queryItems: [])
    }
    
    static func species(id: Int) -> Self {
        Endpoint(path: "/species/\(id)", queryItems: [])
    }
    
    static func vehicleList() -> Self {
        Endpoint(path: "/vehicles", queryItems: [])
    }
    
    static func vehicle(id: Int) -> Self {
        Endpoint(path: "/vehicles/\(id)", queryItems: [])
    }
    
    static func starshipList() -> Self {
        Endpoint(path: "/starships", queryItems: [])
    }
    
    static func starship(id: Int) -> Self {
        Endpoint(path: "/starships/\(id)", queryItems: [])
    }
    
    static func filmList() -> Self {
        Endpoint(path: "/films", queryItems: [])
    }
    
    static func film(id: Int) -> Self {
        Endpoint(path: "/films/\(id)", queryItems: [])
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
    
    public struct APIError: Error {
        let reason: String
    }
    
    // MARK: Root
    
    public static func rootPublisher() -> AnyPublisher<Root, APIError> {
        let endpoint = Endpoint.root()
        return decodeEndpointPublisher(endpoint: endpoint)
    }
    
    public static func rootMapPublisher() -> AnyPublisher<[String: String], APIError> {
        let endpoint = Endpoint.root()
        return decodeEndpointPublisher(endpoint: endpoint)
    }
    
    // MARK: People
    
    public static func personPublishers(ids: [Int]) -> AnyPublisher<Person, APIError> {
        let publishers = ids.map(personPublisher(id:))
        return Publishers.MergeMany(publishers).prefix(ids.count).eraseToAnyPublisher()
    }
    
    public static func personPublisher(id: Int) -> AnyPublisher<Person, APIError> {
        let endpoint = Endpoint.people(id: id)
        return decodeEndpointPublisher(endpoint: endpoint)
    }
    
    public static func peopleListPublisher() -> AnyPublisher<[Person], APIError> {
        let endpoint = Endpoint.peopleList()
        return listPublisher(endpoint: endpoint)
    }
    
    // MARK: Films

    public static func filmPublishers(ids: [Int]) -> AnyPublisher<Film, APIError> {
        let publishers = ids.map(filmPublisher(id:))
        return Publishers.MergeMany(publishers).prefix(ids.count).eraseToAnyPublisher()
    }
    
    public static func filmPublisher(id: Int) -> AnyPublisher<Film, APIError> {
        let endpoint = Endpoint.film(id: id)
        return decodeEndpointPublisher(endpoint: endpoint)
    }
    
    public static func filmListPublisher() -> AnyPublisher<[Film], APIError> {
        let endpoint = Endpoint.filmList()
        return listPublisher(endpoint: endpoint)
    }

    // MARK: Starships
    
    public static func starshipPublishers(ids: [Int]) -> AnyPublisher<Starship, APIError> {
        let publishers = ids.map(starshipPublisher(id:))
        return Publishers.MergeMany(publishers).prefix(ids.count).eraseToAnyPublisher()
    }
    
    public static func starshipPublisher(id: Int) -> AnyPublisher<Starship, APIError> {
        let endpoint = Endpoint.starship(id: id)
        return decodeEndpointPublisher(endpoint: endpoint)
    }
    
    public static func starshipListPublisher() -> AnyPublisher<[Starship], APIError> {
        let endpoint = Endpoint.starshipList()
        return listPublisher(endpoint: endpoint)
    }

    // MARK: Vehicles
    
    public static func vehiclePublishers(ids: [Int]) -> AnyPublisher<Vehicle, APIError> {
        let publishers = ids.map(vehiclePublisher(id:))
        return Publishers.MergeMany(publishers).prefix(ids.count).eraseToAnyPublisher()
    }
    
    public static func vehiclePublisher(id: Int) -> AnyPublisher<Vehicle, APIError> {
        let endpoint = Endpoint.vehicle(id: id)
        return decodeEndpointPublisher(endpoint: endpoint)
    }
    
    public static func vehicleListPublisher() -> AnyPublisher<[Vehicle], APIError> {
        let endpoint = Endpoint.vehicleList()
        return listPublisher(endpoint: endpoint)
    }

    // MARK: Species
    
    public static func speciesPublishers(ids: [Int]) -> AnyPublisher<Species, APIError> {
        let publishers = ids.map(speciesPublisher(id:))
        return Publishers.MergeMany(publishers).prefix(ids.count).eraseToAnyPublisher()
    }
    
    public static func speciesPublisher(id: Int) -> AnyPublisher<Species, APIError> {
        let endpoint = Endpoint.species(id: id)
        return decodeEndpointPublisher(endpoint: endpoint)
    }
    
    public static func speciesListPublisher() -> AnyPublisher<[Species], APIError> {
        let endpoint = Endpoint.speciesList()
        return listPublisher(endpoint: endpoint)
    }
    
    // MARK: Planets
    
    public static func planetPublishers(ids: [Int]) -> AnyPublisher<Planet, APIError> {
        let publishers = ids.map(planetPublisher(id:))
        return Publishers.MergeMany(publishers).prefix(ids.count).eraseToAnyPublisher()
    }
    
    public static func planetPublisher(id: Int) -> AnyPublisher<Planet, APIError> {
        let endpoint = Endpoint.planets(id: id)
        return decodeEndpointPublisher(endpoint: endpoint)
    }
    
    public static func planetListPublisher() -> AnyPublisher<[Planet], APIError> {
        let endpoint = Endpoint.planetsList()
        return listPublisher(endpoint: endpoint)
    }
    
    // MARK: Helpers
    
    static func decodeEndpointPublisher<T: Decodable>(endpoint: Endpoint) -> AnyPublisher<T, APIError> {
        return URLSession.shared.dataTaskPublisher(for: endpoint.url)
            .map({ $0.data })
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError({ (failure) -> APIError in
                return APIError(reason: failure.localizedDescription)
            })
            .eraseToAnyPublisher()
    }
    
    static func endpointPublisher<T: Decodable>(endpoint: Endpoint, transform: @escaping (Data) -> T) -> AnyPublisher<T, APIError> {
        return URLSession.shared.dataTaskPublisher(for: endpoint.url)
            .map({ $0.data })
            .map(transform)
            .mapError({ (failure) -> APIError in
                return APIError(reason: failure.localizedDescription)
            })
            .eraseToAnyPublisher()
    }
    
    struct ListWrapper<T: Decodable>: Decodable {
        let results: [T]
    }
    
    static func listPublisher<T: Decodable>(endpoint: Endpoint) -> AnyPublisher<[T], APIError> {
        return endpointPublisher(endpoint: endpoint) { (data) -> [T] in
            do {
                return try JSONDecoder().decode(ListWrapper.self, from: data).results
            }
            catch {
                print(error.localizedDescription)
                return []
            }
        }
    }
}

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
        Endpoint(path: "/vehicle", queryItems: [])
    }
    
    static func vehicle(id: Int) -> Self {
        Endpoint(path: "/vehicle/\(id)", queryItems: [])
    }
    
    static func starshipList() -> Self {
        Endpoint(path: "/starship", queryItems: [])
    }
    
    static func starship(id: Int) -> Self {
        Endpoint(path: "/starship/\(id)", queryItems: [])
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
    public struct Film: Decodable, Identifiable {
        public var id: Int { episode_id }
        public let title: String
        public let episode_id: Int
        public let opening_crawl: String
        public let director: String
        public let producer: String
        public let release_date: String
        public let species: [String]
        public let starships: [String]
        public let vehicles: [String]
        public let characters: [String]
        public let planets: [String]
        public let url: URL
        public let created: String
        public let edited: String
    }
    
    public struct Starship {
        public let name: String // string -- The name of this starship. The common name, such as "Death Star".
        public let model: String // string -- The model or official name of this starship. Such as "T-65 X-wing" or "DS-1 Orbital Battle Station".
        public let starship_class: String // string -- The class of this starship, such as "Starfighter" or "Deep Space Mobile Battlestation"
        public let manufacturer: String // string -- The manufacturer of this starship. Comma separated if more than one.
        public let cost_in_credits: String // string -- The cost of this starship new, in galactic credits.
        public let length: String // string -- The length of this starship in meters.
        public let crew: String // string -- The number of personnel needed to run or pilot this starship.
        public let passengers: String // string -- The number of non-essential people this starship can transport.
        public let max_atmosphering_speed: String // string -- The maximum speed of this starship in the atmosphere. "N/A" if this starship is incapable of atmospheric flight.
        public let hyperdrive_rating: String // string -- The class of this starships hyperdrive.
        public let MGLT: String // string -- The Maximum number of Megalights this starship can travel in a standard hour. A "Megalight" is a standard unit of distance and has never been defined before within the Star Wars universe. This figure is only really useful for measuring the difference in speed of starships. We can assume it is similar to AU, the distance between our Sun (Sol) and Earth.
        public let cargo_capacity: String // string -- The maximum number of kilograms that this starship can transport.
        public let consumables: String // *string
        //The maximum length of time that this starship can provide consumables for its entire crew without having to resupply.
        public let films: [String] // array -- An array of Film URL Resources that this starship has appeared in.
        public let pilots: [String] // array -- An array of People URL Resources that this starship has been piloted by.
        public let url: URL // string -- the hypermedia URL of this resource.
        public let created: String // string -- the ISO 8601 date format of the time that this resource was created.
        public let edited: String // string -- the ISO 8601 date format of the time that this resource was edited.
    }
    
    public struct Vehicle {
        public let name: String // string -- The name of this vehicle. The common name, such as "Sand Crawler" or "Speeder bike".
        public let model: String // string -- The model or official name of this vehicle. Such as "All-Terrain Attack Transport".
        public let vehicle_class: String // string -- The class of this vehicle, such as "Wheeled" or "Repulsorcraft".
        public let manufacturer: String // string -- The manufacturer of this vehicle. Comma separated if more than one.
        public let length: String // string -- The length of this vehicle in meters.
        public let cost_in_credits: String // string -- The cost of this vehicle new, in Galactic Credits.
        public let crew: String // string -- The number of personnel needed to run or pilot this vehicle.
        public let passengers: String // string -- The number of non-essential people this vehicle can transport.
        public let max_atmosphering_speed: String // string -- The maximum speed of this vehicle in the atmosphere.
        public let cargo_capacity: String // string -- The maximum number of kilograms that this vehicle can transport.
        public let consumables: String // *string
        // The maximum length of time that this vehicle can provide consumables for its entire crew without having to resupply.
        public let films: [String] // array -- An array of Film URL Resources that this vehicle has appeared in.
        public let pilots: [String] // array -- An array of People URL Resources that this vehicle has been piloted by.
        public let url: String // string -- the hypermedia URL of this resource.
        public let created: String // string -- the ISO 8601 date format of the time that this resource was created.
        public let edited: String // string -- the ISO 8601 date format of the time that this resource was edited.
    }
    
    public struct Species {
        public let name: String // string -- The name of this species.
        public let classification: String // string -- The classification of this species, such as "mammal" or "reptile".
        public let designation: String // string -- The designation of this species, such as "sentient".
        public let average_height: String // string -- The average height of this species in centimeters.
        public let average_lifespan: String // string -- The average lifespan of this species in years.
        public let eye_colors: String // string -- A comma-separated string of common eye colors for this species, "none" if this species does not typically have eyes.
        public let hair_colors: String // string -- A comma-separated string of common hair colors for this species, "none" if this species does not typically have hair.
        public let skin_colors: String // string -- A comma-separated string of common skin colors for this species, "none" if this species does not typically have skin.
        public let language: String // string -- The language commonly spoken by this species.
        public let homeworld: String // string -- The URL of a planet resource, a planet that this species originates from.
        public let people: [String] // array -- An array of People URL Resources that are a part of this species.
        public let films: [String] // array -- An array of Film URL Resources that this species has appeared in.
        public let url: String // string -- the hypermedia URL of this resource.
        public let created: String // string -- the ISO 8601 date format of the time that this resource was created.
        public let edited: String // string -- the ISO 8601 date format of the time that this resource was edited.
    }
    
    public struct Planet {
        public let name: String // string -- The name of this planet.
        public let diameter: String // string -- The diameter of this planet in kilometers.
        public let rotation_period: String // string -- The number of standard hours it takes for this planet to complete a single rotation on its axis.
        public let orbital_period: String // string -- The number of standard days it takes for this planet to complete a single orbit of its local star.
        public let gravity: String // string -- A number denoting the gravity of this planet, where "1" is normal or 1 standard G. "2" is twice or 2 standard Gs. "0.5" is half or 0.5 standard Gs.
        public let population: String // string -- The average population of sentient beings inhabiting this planet.
        public let climate: String // string -- The climate of this planet. Comma separated if diverse.
        public let terrain: String // string -- The terrain of this planet. Comma separated if diverse.
        public let surface_water: String // string -- The percentage of the planet surface that is naturally occurring water or bodies of water.
        public let residents: [String] // array -- An array of People URL Resources that live on this planet.
        public let films: [String] // array -- An array of Film URL Resources that this planet has appeared in.
        public let url: String // string -- the hypermedia URL of this resource.
        public let created: String // string -- the ISO 8601 date format of the time that this resource was created.
        public let edited: String // string -- the ISO 8601 date format of the time that this resource was edited.
    }
    
    public struct Person: Decodable, Identifiable {
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
    
    public struct Root: Decodable {
        public let films: String
        public let people: String
        public let planets: String
        public let species: String
        public let starships: String
        public let vehicles: String
        
        public var collections: [String] {
            [
                films,
                people,
                planets,
                species,
                starships,
                vehicles
            ]
        }
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
            struct PeopleWrapper: Decodable {
                let results: [Person]
            }
            
            let wrapper = try? JSONDecoder().decode(PeopleWrapper.self, from: data)
            return wrapper?.results ?? []
        }
    }
    
    // MARK: Films

    public static func filmPublishers(ids: [Int]) -> AnyPublisher<Film, APIError> {
        let publishers = ids.map(filmPublisher(id:))
        return Publishers.MergeMany(publishers).prefix(ids.count).eraseToAnyPublisher()
    }
    
    public static func filmPublisher(id: Int) -> AnyPublisher<Film, APIError> {
        let url = Endpoint.film(id: id).url
        return decodePublisher(url: url)
    }
    
    public static func filmListPublisher() -> AnyPublisher<[Film], APIError> {
        let url = Endpoint.filmList().url
        return publisher(url: url) { (data) in
            struct FilmWrapper: Decodable {
                let results: [Film]
            }
            
            let wrapper = try? JSONDecoder().decode(FilmWrapper.self, from: data)
            return wrapper?.results ?? []
        }
    }

    static func decodePublisher<T: Decodable>(url: URL) -> AnyPublisher<T, APIError> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map({ $0.data })
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError({ (failure) -> APIError in
                return APIError(reason: failure.localizedDescription)
            })
            .eraseToAnyPublisher()
    }
    
    static func publisher<T: Decodable>(url: URL, transform: @escaping (Data) -> T) -> AnyPublisher<T, APIError> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map({ $0.data })
            .map(transform)
            .mapError({ (failure) -> APIError in
                return APIError(reason: failure.localizedDescription)
            })
            .eraseToAnyPublisher()
    }
}

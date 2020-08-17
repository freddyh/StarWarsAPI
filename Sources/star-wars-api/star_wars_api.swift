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
    
    /// A Film resource is a single film
    public struct Film: Decodable, Identifiable {
        
        /// The id of this film. See `title`
        public var id: String { title }
        
        /// The title of this film
        public let title: String
        
        /// The episode number of this film
        public let episode_id: Int
        
        /// The opening paragraphs at the beginning of this film
        public let opening_crawl: String
        
        /// The name of the director of this film
        public let director: String
        
        /// The name(s) of the producer(s) of this film. Comma separated.
        public let producer: String
        
        /// The ISO 8601 date format of film release at original creator country
        public let release_date: String
        
        /// An array of species resource URLs that are in this film
        public let species: [String]
        
        /// An array of starship resource URLs that are in this film
        public let starships: [String]
        
        /// An array of vehicle resource URLs that are in this film
        public let vehicles: [String]
        
        /// An array of people resource URLs that are in this film
        public let characters: [String]
        
        /// An array of planet resource URLs that are in this film
        public let planets: [String]
        
        /// The hypermedia URL of this resource
        public let url: URL
        
        /// The ISO 8601 date format of the time that this resource was created.
        public let created: String
        
        /// The ISO 8601 date format of the time that this resource was edited.
        public let edited: String
    }
    
    /// A Starship is a single transport craft that has hyperdrive capability
    public struct Starship: Decodable, Identifiable {
        
        /// The id of this starship. See `name`
        public var id: String { name }
        
        /// The name of this starship. The common name, such as "Death Star".
        public let name: String
        
        /// The model or official name of this starship. Such as "T-65 X-wing" or "DS-1 Orbital Battle Station".
        public let model: String
        
        /// The class of this starship, such as "Starfighter" or "Deep Space Mobile Battlestation"
        public let starship_class: String
        
        /// The manufacturer of this starship. Comma separated if more than one.
        public let manufacturer: String
        
        /// The cost of this starship new, in galactic credits.
        public let cost_in_credits: String
        
        /// The length of this starship in meters.
        public let length: String
        
        /// The number of personnel needed to run or pilot this starship.
        public let crew: String
        
        /// The number of non-essential people this starship can transport.
        public let passengers: String
        
        /// The maximum speed of this starship in the atmosphere. "N/A" if this starship is incapable of atmospheric flight.
        public let max_atmosphering_speed: String
        
        /// The class of this starships hyperdrive.
        public let hyperdrive_rating: String
        
        /// The Maximum number of Megalights this starship can travel in a standard hour. A "Megalight" is a standard unit of distance and has never been defined before within the Star Wars universe. This figure is only really useful for measuring the difference in speed of starships. We can assume it is similar to AU, the distance between our Sun (Sol) and Earth.
        public let MGLT: String
        
        /// The maximum number of kilograms that this starship can transport.
        public let cargo_capacity: String
        
        ///The maximum length of time that this starship can provide consumables for its entire crew without having to resupply.
        public let consumables: String
        
        /// An array of Film URL Resources that this starship has appeared in.
        public let films: [String]
        
        /// An array of People URL Resources that this starship has been piloted by.
        public let pilots: [String]
        
        /// the hypermedia URL of this resource.
        public let url: URL
        
        /// the ISO 8601 date format of the time that this resource was created.
        public let created: String
        
        /// the ISO 8601 date format of the time that this resource was edited.
        public let edited: String
    }
    
    /// A Vehicle resource is a single transport craft that does not have hyperdrive capability.
    public struct Vehicle: Decodable, Identifiable {
        
        /// The id of this vehicle. See `name`.
        public var id: String { name }
        
        /// The name of this vehicle. The common name, such as "Sand Crawler" or "Speeder bike".
        public let name: String
        
        /// The model or official name of this vehicle. Such as "All-Terrain Attack Transport".
        public let model: String
        
        /// The class of this vehicle, such as "Wheeled" or "Repulsorcraft".
        public let vehicle_class: String
        
        /// The manufacturer of this vehicle. Comma separated if more than one.
        public let manufacturer: String
        
        /// The length of this vehicle in meters.
        public let length: String
        
        /// The cost of this vehicle new, in Galactic Credits.
        public let cost_in_credits: String
        
        /// The number of personnel needed to run or pilot this vehicle.
        public let crew: String
        
        /// The number of non-essential people this vehicle can transport.
        public let passengers: String
        
        /// The maximum speed of this vehicle in the atmosphere.
        public let max_atmosphering_speed: String
        
        /// The maximum number of kilograms that this vehicle can transport.
        public let cargo_capacity: String
        
        /// The maximum length of time that this vehicle can provide consumables for its entire crew without having to resupply.
        public let consumables: String
        
        /// An array of Film URL Resources that this vehicle has appeared in.
        public let films: [String]
        
        /// An array of People URL Resources that this vehicle has been piloted by.
        public let pilots: [String]
        
        /// the hypermedia URL of this resource.
        public let url: String
        
        /// the ISO 8601 date format of the time that this resource was created.
        public let created: String
        
        /// the ISO 8601 date format of the time that this resource was edited.
        public let edited: String
    }
    
    /// A Species resource is a type of person or character within the Star Wars Universe.
    public struct Species {
        
        /// The name of this species.
        public let name: String
        
        /// The classification of this species, such as "mammal" or "reptile".
        public let classification: String
        
        /// The designation of this species, such as "sentient".
        public let designation: String
        
        /// The average height of this species in centimeters.
        public let average_height: String
        
        /// The average lifespan of this species in years.
        public let average_lifespan: String
        
        /// A comma-separated string of common eye colors for this species, "none" if this species does not typically have eyes.
        public let eye_colors: String
        
        /// A comma-separated string of common hair colors for this species, "none" if this species does not typically have hair.
        public let hair_colors: String
        
        /// A comma-separated string of common skin colors for this species, "none" if this species does not typically have skin.
        public let skin_colors: String
        
        /// The language commonly spoken by this species.
        public let language: String
        
        /// The URL of a planet resource, a planet that this species originates from.
        public let homeworld: String
        
        /// An array of People URL Resources that are a part of this species.
        public let people: [String]
        
        /// An array of Film URL Resources that this species has appeared in.
        public let films: [String]
        
        /// the hypermedia URL of this resource.
        public let url: String
        
        /// the ISO 8601 date format of the time that this resource was created.
        public let created: String
        
        /// the ISO 8601 date format of the time that this resource was edited.
        public let edited: String
    }
    
    /// A Planet resource is a large mass, planet or planetoid in the Star Wars Universe, at the time of 0 ABY.
    public struct Planet {
        
        /// The name of this planet.
        public let name: String
        
        /// The diameter of this planet in kilometers.
        public let diameter: String
        
        /// The number of standard hours it takes for this planet to complete a single rotation on its axis.
        public let rotation_period: String
        
        /// The number of standard days it takes for this planet to complete a single orbit of its local star.
        public let orbital_period: String
        
        /// A number denoting the gravity of this planet, where "1" is normal or 1 standard G. "2" is twice or 2 standard Gs. "0.5" is half or 0.5 standard Gs.
        public let gravity: String
        
        /// The average population of sentient beings inhabiting this planet.
        public let population: String
        
        /// The climate of this planet. Comma separated if diverse.
        public let climate: String
        
        /// The terrain of this planet. Comma separated if diverse.
        public let terrain: String
        
        /// The percentage of the planet surface that is naturally occurring water or bodies of water.
        public let surface_water: String
        
        /// An array of People URL Resources that live on this planet.
        public let residents: [String]
        
        /// An array of Film URL Resources that this planet has appeared in.
        public let films: [String]
        
        /// the hypermedia URL of this resource.
        public let url: String
        
        /// the ISO 8601 date format of the time that this resource was created.
        public let created: String
        
        /// the ISO 8601 date format of the time that this resource was edited.
        public let edited: String
    }
    
    /// A People resource is an individual person or character within the Star Wars universe.
    public struct Person: Decodable, Identifiable {
        
        public var id: String { name }
        
        /// the name of this person
        public let name: String
        
        /// The birth year of the person, using the in-universe standard of BBY or ABY - Before the Battle of Yavin or After the Battle of Yavin. The Battle of Yavin is a battle that occurs at the end of Star Wars episode IV: A New Hope.
        public let birth_year: String
        
        /// The eye color of this person. Will be "unknown" if not known or "n/a" if the person does not have an eye.
        public let eye_color: String
        
        /// The gender of this person. Either "Male", "Female" or "unknown", "n/a" if the person does not have a gender.
        public let gender: String
        
        /// The hair color of this person. Will be "unknown" if not known or "n/a" if the person does not have hair.
        public let hair_color: String
        
        /// The height of this person in centimeters
        public let height: String
        
        /// The mass of this person in kilograms
        public let mass: String
        
        /// The URL of a planet resource, a planet that this person was born on or inhabits.
        public let homeworld: String
        
        /// An array of film resource URLs that this person has been in.
        public let films: [String]
        
        /// An array of species resource URLs that this person belongs to.
        public let species: [String]
        
        ///  An array of starship resource URLs that this person has piloted.
        public let starships: [String]
        
        /// An array of vehicle resource URLs that this person has piloted.
        public let vehicles: [String]
        
        /// the hypermedia URL of this resource.
        public let url: String
        
        /// the ISO 8601 date format of the time that this resource was created.
        public let created: String
        
        /// the ISO 8601 date format of the time that this resource was edited.
        public let edited: String
    }
    
    /// The Root resource provides information on all available resources within the API.
    public struct Root: Decodable {
        
        /// The URL root for Film resources
        public let films: String
        
        /// The URL root for People resources
        public let people: String
        
        /// The URL root for Planet resources
        public let planets: String
        
        /// The URL root for Species resources
        public let species: String
        
        /// The URL root for Starship resources
        public let starships: String
        
        /// The URL root for Vehicles resources
        public let vehicles: String
        
        /// An array of the URL roots for all resources
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
    
    public static func rootMapPublisher() -> AnyPublisher<[String: String], APIError> {
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
        return endpointPublisher(endpoint: endpoint) { (data) in
            struct StarshipWrapper: Decodable {
                let results: [Starship]
            }
            let wrapper = try? JSONDecoder().decode(StarshipWrapper.self, from: data)
            return wrapper?.results ?? []
        }
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
        return endpointPublisher(endpoint: endpoint) { (data) in
            struct Wrapper: Decodable {
                let results: [Vehicle]
            }
            let wrapper = try? JSONDecoder().decode(Wrapper.self, from: data)
            return wrapper?.results ?? []
        }
    }

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

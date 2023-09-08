//
//  Repository.swift
//  FavCountries
//
//  Created by Shirag Berejikian on 2023-09-08.
//

import Foundation

// The purpose of the repository layer is to allow abstracting the source of the data and caching in the future
protocol RepositoryProtocol {
    func allCountries() async throws -> [Country]
}

class LiveRepository: RepositoryProtocol {
    func allCountries() async throws -> [Country] {
        let url = URL(string: "https://restcountries.com/v3.1/all?fields=name,flags,continents,population,capital,cca2")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Country].self, from: data)
    }
}

enum ApiError: Error {
    case parsingFailed
}

extension Country: Decodable {
    init(from decoder: Decoder) throws {
        let rawCountry = try RawCountry(from: decoder)
        
        id = String(rawCountry.cca2)
        name = rawCountry.name.common
        
        if let flagImageUrl = URL(string: rawCountry.flags.png) {
            self.flagImageUrl = flagImageUrl
        } else {
            throw(ApiError.parsingFailed)
        }
        
        continents = rawCountry.continents
        population = rawCountry.population
        capitals = rawCountry.capital
    }
}

struct RawCountry: Codable {
    let cca2: String
    let flags: RawFlags
    let name: RawName
    let capital: [String]
    let population: Int
    let continents: [String]
}

struct RawFlags: Codable {
    let png: String
}

struct RawName: Codable {
    let common: String
}

extension Country {
    static var mockCanada: Country {
        Country(id: "CA",
                name: "Canada",
                flagImageUrl: URL(string: "https://flagcdn.com/w320/ca.png")!,
                continents: ["North America"],
                population: 38005238,
                capitals: ["Ottawa"])
    }
    
    static var mockUnitedStates: Country {
        Country(id: "US",
                name: "United States of America",
                flagImageUrl: URL(string: "https://flagcdn.com/w320/us.png")!,
                continents: ["North America"],
                population: 329484123,
                capitals: ["Washington, D.C."])
    }
}

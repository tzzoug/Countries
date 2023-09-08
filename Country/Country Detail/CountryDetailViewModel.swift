//
//  CountryDetailViewModel.swift
//  Country
//
//  Created by Shirag Berejikian on 2023-09-08.
//

import Foundation

class CountryDetailViewModel {
    @Published var countryId: String
    @Published var flagImageUrl: URL
    @Published var name: String
    @Published var capitals: String
    @Published var continents: String
    @Published var population: String
    @Published var isFavorited: Bool
    
    private let repository: RepositoryProtocol
    private let appState: AppStateProtocol
    
    private let country: Country
    init(repository: RepositoryProtocol,
         appState: AppStateProtocol,
         country: Country) {
        self.repository = repository
        self.appState = appState
        self.country = country
        
        self.countryId = country.id
        self.isFavorited = appState.favoriteCountryIds.contains(country.id)
        
        self.flagImageUrl = country.flagImageUrl
        self.name = country.name
        self.capitals = country.capitals.joined(separator: ", ")
        self.continents = country.continents.joined(separator: ", ")
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        self.population = numberFormatter.string(from: NSNumber(value: country.population)) ?? String(country.population)
    }
    
    func didToggleFavorite() {
        self.appState.toggleFavoriteCountryId(countryId: self.countryId)
    }
    
    func updateCountryFavoriteStatus() {
        DispatchQueue.main.async {
            self.isFavorited = self.appState.favoriteCountryIds.contains(self.country.id)
        }
    }
}

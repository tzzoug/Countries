//
//  FavoriteCountriesViewModel.swift
//  Country
//
//  Created by Shirag Berejikian on 2023-09-08.
//

import Foundation

protocol FavoriteCountriesViewModelDelegate: AnyObject {
    func didSelectCountry(country: Country)
}

class FavoriteCountriesViewModel {
    weak var coordinator: FavoriteCountriesViewModelDelegate?
    
    @Published var countryCellViewModels: [CountryCellViewModel] = []

    private let repository: RepositoryProtocol
    private let appState: AppStateProtocol
    private var countries: [Country] = []
    
    init(repository: RepositoryProtocol, appState: AppStateProtocol) {
        self.repository = repository
        self.appState = appState
    }
    
    func viewDidLoad() {
        Task {
            self.countries = try await self.repository.allCountries()
            let countryCellViewModels = self.countries.filter { self.appState.favoriteCountryIds.contains($0.id) }.map { CountryCellViewModel(country: $0, isFavorited: appState.favoriteCountryIds.contains($0.id)) }
            DispatchQueue.main.async {
                self.countryCellViewModels = countryCellViewModels
            }
        }
    }
    
    func updateCountryRow(for countryId: String) {
        guard let country = countries.first(where: { $0.id == countryId }) else { return }
        DispatchQueue.main.async {
            let isFavorited = self.appState.favoriteCountryIds.contains(countryId)
            if !isFavorited, let index = self.countryCellViewModels.firstIndex(where: { $0.country.id == countryId }) {
                self.countryCellViewModels.remove(at: index)
            } else {
                self.countryCellViewModels.append(CountryCellViewModel(country: country, isFavorited: true))
            }
            
        }
    }
    
    func didToggleFavorite(countryId: String) {
        self.appState.toggleFavoriteCountryId(countryId: countryId)
    }
    
    func didSelect(index: Int) {
        let selectedCellViewModel = countryCellViewModels[index]
        coordinator?.didSelectCountry(country: selectedCellViewModel.country)
    }
    
    func didDelete(index: Int) {
        let selectedCellViewModel = countryCellViewModels[index]
        self.appState.toggleFavoriteCountryId(countryId: selectedCellViewModel.country.id)
    }
}

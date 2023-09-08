//
//  AllCountriesViewModel.swift
//  FavCountries
//
//  Created by Shirag Berejikian on 2023-09-08.
//

import Foundation

protocol AllCountriesViewModelDelegate: AnyObject {
    func didSelectCountry(country: Country)
}

class AllCountriesViewModel {
    weak var coordinator: AllCountriesViewModelDelegate?
    
    @Published var countryCellViewModels: [CountryCellViewModel] = []
    @Published var updatedCountryCellViewModelIndex: Int = 0
    
    private let repository: RepositoryProtocol
    private let appState: AppStateProtocol

    init(repository: RepositoryProtocol, appState: AppStateProtocol) {
        self.repository = repository
        self.appState = appState
    }
    
    func viewDidLoad() async {
        do {
            let countries = try await repository.allCountries()
            self.countryCellViewModels = countries.map { CountryCellViewModel(country: $0, isFavorited: appState.favoriteCountryIds.contains($0.id)) }
        } catch {
            // I would update the UI to reflect that we were not able to fetch the data and to offer a way to refresh the UI
        }
    }
    
    func onFavoriteToggle(countryId: String) {
        self.appState.toggleFavoriteCountryId(countryId: countryId)
    }
    
    func updateCountryRow(for countryId: String) {
        DispatchQueue.main.async {
            let isFavorited = self.appState.favoriteCountryIds.contains(countryId)
            self.countryCellViewModels.first(where: { $0.country.id == countryId })?.isFavorited = isFavorited
            if let updatedIndex = self.countryCellViewModels.firstIndex(where: { $0.country.id == countryId }) {
                self.updatedCountryCellViewModelIndex = updatedIndex
            }
        }
    }
    
    func didSelect(index: Int) {
        let selectedCellViewModel = countryCellViewModels[index]
        coordinator?.didSelectCountry(country: selectedCellViewModel.country)
    }
}

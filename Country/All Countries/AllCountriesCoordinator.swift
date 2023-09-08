//
//  AllCountriesCoordinator.swift
//  FavCountries
//
//  Created by Shirag Berejikian on 2023-09-08.
//

import UIKit

class AllCountriesCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []

    var rootViewController: UINavigationController
    var allCountriesViewController: AllCountriesViewController?
    var allCountriesViewModel: AllCountriesViewModel?
    var countryDetailViewModel: CountryDetailViewModel?
    
    private let repository: RepositoryProtocol
    private let appState: AppStateProtocol
    
    init(rootViewController: UINavigationController, repository: RepositoryProtocol, appState: AppStateProtocol) {
        self.rootViewController = rootViewController
        self.repository = repository
        self.appState = appState
    }
    
    func start(animated: Bool) {
        let viewModel = AllCountriesViewModel(repository: repository, appState: appState)
        self.allCountriesViewModel = viewModel
        viewModel.coordinator = self
        
        let storyboard = UIStoryboard(name: "AllCountriesViewController", bundle: Bundle.main)
        let allCountriesViewController = storyboard.instantiateViewController(identifier: "AllCountriesViewController", creator: { coder in
            return AllCountriesViewController(coder: coder, viewModel: viewModel)
        })

        self.allCountriesViewController = allCountriesViewController
        self.rootViewController.pushViewController(allCountriesViewController, animated: false)
    }
    
    func didUpdateFavorite(countryId: String) {
        allCountriesViewModel?.updateCountryRow(for: countryId)
        countryDetailViewModel?.updateCountryFavoriteStatus()
    }
}

extension AllCountriesCoordinator: AllCountriesViewModelDelegate {
    func didSelectCountry(country: Country) {
        let viewModel = CountryDetailViewModel(repository: repository, appState: appState, country: country)
        self.countryDetailViewModel = viewModel
        let storyboard = UIStoryboard(name: "CountryDetailViewController", bundle: Bundle.main)
        let countryDetailViewController = storyboard.instantiateViewController(identifier: "CountryDetailViewController", creator: { coder in
            return CountryDetailViewController(coder: coder, viewModel: viewModel)
        })
        
        rootViewController.pushViewController(countryDetailViewController, animated: true)
    }
}

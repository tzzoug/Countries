//
//  FavoriteCountriesCoordinator.swift
//  FavCountries
//
//  Created by Shirag Berejikian on 2023-09-08.
//

import UIKit

import UIKit

class FavoriteCountriesCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []

    var rootViewController: UINavigationController
    var favoriteCountriesViewController: FavoriteCountriesViewController?
    var favoriteCountriesViewModel: FavoriteCountriesViewModel?
    
    private let repository: RepositoryProtocol
    private let appState: AppStateProtocol

    init(rootViewController: UINavigationController, repository: RepositoryProtocol, appState: AppStateProtocol) {
        self.rootViewController = rootViewController
        self.repository = repository
        self.appState = appState
    }
    
    func start(animated: Bool) {
        let viewModel = FavoriteCountriesViewModel(repository: repository, appState: appState)
        self.favoriteCountriesViewModel = viewModel
        viewModel.coordinator = self
        
        let storyboard = UIStoryboard(name: "FavoriteCountriesViewController", bundle: Bundle.main)
        let favoriteCountriesViewController = storyboard.instantiateViewController(identifier: "FavoriteCountriesViewController", creator: { coder in
            return FavoriteCountriesViewController(coder: coder, viewModel: viewModel)
        })

        self.favoriteCountriesViewController = favoriteCountriesViewController
        self.rootViewController.pushViewController(favoriteCountriesViewController, animated: false)
    }
    
    func didUpdateFavorite(countryId: String) {
        favoriteCountriesViewModel?.updateCountryRow(for: countryId)
    }
}

extension FavoriteCountriesCoordinator: FavoriteCountriesViewModelDelegate {
    func didSelectCountry(country: Country) {
        let viewModel = CountryDetailViewModel(repository: repository, appState: appState, country: country)
        let storyboard = UIStoryboard(name: "CountryDetailViewController", bundle: Bundle.main)
        let countryDetailViewController = storyboard.instantiateViewController(identifier: "CountryDetailViewController", creator: { coder in
            return CountryDetailViewController(coder: coder, viewModel: viewModel)
        })
        
        rootViewController.pushViewController(countryDetailViewController, animated: true)
    }
}

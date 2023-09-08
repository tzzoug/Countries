//
//  TabBarCoordinator.swift
//  FavCountries
//
//  Created by Shirag Berejikian on 2023-09-08.
//

import UIKit

class TabBarCoordinator: NSObject, Coordinator {
    var childCoordinators = [Coordinator]()
    var rootViewController: UINavigationController
    var tabBarController: TabBarViewController?
    
    var allCountriesCoordinator: AllCountriesCoordinator?
    var favoriteCountriesCoordinator: FavoriteCountriesCoordinator?

    var repository: RepositoryProtocol
    var appState: AppStateProtocol
    
    init(rootViewController: UINavigationController, repository: RepositoryProtocol) {
        self.rootViewController = rootViewController
        self.repository = repository
        self.appState = LiveAppState()
        super.init()
        
        self.appState.delegate = self
    }
    
    func start(animated: Bool) {
        let allCountriesCoordinator = AllCountriesCoordinator(rootViewController: UINavigationController(), repository: repository, appState: appState)
        self.allCountriesCoordinator = allCountriesCoordinator
        self.addChild(child: allCountriesCoordinator)
        allCountriesCoordinator.start(animated: false)

        let favoriteCountriesCoordinator = FavoriteCountriesCoordinator(rootViewController: UINavigationController(), repository: repository, appState: appState)
        self.favoriteCountriesCoordinator = favoriteCountriesCoordinator
        self.addChild(child: favoriteCountriesCoordinator)
        favoriteCountriesCoordinator.start(animated: false)
        
        let tabBarController = TabBarViewController(coordinator: self)
        self.tabBarController = tabBarController
        self.rootViewController.pushViewController(tabBarController, animated: false)
    }
}

extension TabBarCoordinator: AppStateDelegate {
    func didUpdateFavorite(countryId: String) {
        allCountriesCoordinator?.didUpdateFavorite(countryId: countryId)
        favoriteCountriesCoordinator?.didUpdateFavorite(countryId: countryId)
    }
}

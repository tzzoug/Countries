//
//  ViewController.swift
//  Country
//
//  Created by Shirag Berejikian on 2023-09-08.
//

import UIKit

class TabBarViewController: UITabBarController {
    weak var coordinator: TabBarCoordinator!
    
    convenience init() {
        fatalError("init() has not been implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(coordinator: TabBarCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let coordinator else { return }

        if let allCountriesViewController = coordinator.allCountriesCoordinator?.rootViewController,
           let favoriteCountriesViewController = coordinator.favoriteCountriesCoordinator?.rootViewController {
            allCountriesViewController.tabBarItem = UITabBarItem(title: "Home",
                                                                 image: UIImage(systemName: "house"),
                                                                 selectedImage: nil)

            favoriteCountriesViewController.tabBarItem = UITabBarItem(title: "Favorites",
                                                                      image: UIImage(systemName: "star"),
                                                                      selectedImage: nil)
            
            self.setViewControllers([allCountriesViewController, favoriteCountriesViewController], animated: false)
        }
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
    }
}

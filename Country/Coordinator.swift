//
//  Coordinator.swift
//  FavCountries
//
//  Created by Shirag Berejikian on 2023-09-08.
//

import UIKit

protocol Coordinator: AnyObject {
    var rootViewController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    func addChild(child: Coordinator)
    func childDidFinish(child: Coordinator)
    func start(animated: Bool)
}

extension Coordinator {
    func addChild(child: Coordinator) {
        childCoordinators.append(child)
    }
    
    func childDidFinish(child: Coordinator) {
        childCoordinators.removeAll { coordinator in
            child === coordinator
        }
    }
}

//
//  AppState.swift
//  Country
//
//  Created by Shirag Berejikian on 2023-09-08.
//

import Foundation

protocol AppStateDelegate: AnyObject {
    func didUpdateFavorite(countryId: String)
}

protocol AppStateProtocol: AnyObject {
    var delegate: AppStateDelegate? { get set }
    var favoriteCountryIds: Set<String> { get }
    func toggleFavoriteCountryId(countryId: String)
}

class LiveAppState: AppStateProtocol {
    weak var delegate: AppStateDelegate?
    
    var favoriteCountryIds: Set<String> = []
    
    func toggleFavoriteCountryId(countryId: String) {
        if favoriteCountryIds.contains(countryId) {
            favoriteCountryIds.remove(countryId)
        } else {
            favoriteCountryIds.insert(countryId)
        }
        
        delegate?.didUpdateFavorite(countryId: countryId)
    }
}

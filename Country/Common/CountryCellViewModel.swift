//
//  CountryCellViewModel.swift
//  Country
//
//  Created by Shirag Berejikian on 2023-09-08.
//

import Foundation

class CountryCellViewModel {
    @Published var flagImageUrl: URL
    @Published var name: String
    @Published var isFavorited: Bool
    
    let country: Country
    init(country: Country,
         isFavorited: Bool) {
        self.country = country
        self.isFavorited = isFavorited
        self.name = country.name
        self.flagImageUrl = country.flagImageUrl
    }
}

extension CountryCellViewModel: Equatable {
    static func == (lhs: CountryCellViewModel, rhs: CountryCellViewModel) -> Bool {
        lhs.flagImageUrl == rhs.flagImageUrl && lhs.name == rhs.name && lhs.isFavorited == rhs.isFavorited
    }
}

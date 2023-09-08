//
//  Country.swift
//  FavCountries
//
//  Created by Shirag Berejikian on 2023-09-08.
//

import Foundation

struct Country: Identifiable {
    let id: String
    let name: String
    let flagImageUrl: URL
    let continents: [String]
    let population: Int
    let capitals: [String]
}

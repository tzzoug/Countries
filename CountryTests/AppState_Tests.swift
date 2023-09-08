//
//  AppState_tests.swift
//  CountryTests
//
//  Created by Shirag Berejikian on 2023-09-08.
//

import XCTest
@testable import Country

final class AppState_tests: XCTestCase {

    func test_AddingAFavorite() {
        // Given
        let sut = LiveAppState()
        
        // When
        sut.toggleFavoriteCountryId(countryId: "CA")
        
        // Then
        XCTAssertEqual(sut.favoriteCountryIds, ["CA"])
    }
    
    func test_AddingFavoriteAndRemovingIt() {
        // Given
        let sut = LiveAppState()
        sut.toggleFavoriteCountryId(countryId: "CA")

        // When
        sut.toggleFavoriteCountryId(countryId: "CA")
        
        // Then
        XCTAssertEqual(sut.favoriteCountryIds, [])
    }
    
    func test_AddingMultipleFavorites() {
        // Given
        let sut = LiveAppState()
        sut.toggleFavoriteCountryId(countryId: "CA")
        
        // When
        sut.toggleFavoriteCountryId(countryId: "US")
        
        // Then
        XCTAssertEqual(sut.favoriteCountryIds, ["CA", "US"])
    }
    
    func test_AddingFavoritesAndRemovingAFavorite() {
        // Given
        let sut = LiveAppState()
        sut.toggleFavoriteCountryId(countryId: "CA")
        sut.toggleFavoriteCountryId(countryId: "US")
        
        // When
        sut.toggleFavoriteCountryId(countryId: "CA")
        
        // Then
        XCTAssertEqual(sut.favoriteCountryIds, ["US"])
    }
}

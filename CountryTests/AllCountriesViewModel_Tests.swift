//
//  AllCountriesViewModel_Tests.swift
//  CountryTests
//
//  Created by Shirag Berejikian on 2023-09-08.
//

import XCTest
@testable import Country

// I would use a package like Mockito to mock protocols easier, but for this sample, I manually created the mock repository and app state

class MockAppState: AppStateProtocol {
    var delegate: AppStateDelegate?
    
    var favoriteCountryIds: Set<String> = []
    
    func toggleFavoriteCountryId(countryId: String) {
        favoriteCountryIds = ["CA"]
    }
}

class MockRepositoryNonFailing: RepositoryProtocol {
    func allCountries() async throws -> [Country] {
        return [.mockCanada]
    }
}

class MockRepositoryFailing: RepositoryProtocol {
    enum RepositoryError: Error {
        case fetchFailed
    }
    
    func allCountries() async throws -> [Country] {
        throw RepositoryError.fetchFailed
    }
}

final class AllCountriesViewModel_Tests: XCTestCase {

    func test_viewDidLoadCalledNoErrors() async {
        let mockRepository = MockRepositoryNonFailing()
        let mockAppState = MockAppState()
        
        let sut = AllCountriesViewModel(repository: mockRepository, appState: mockAppState)
        await sut.viewDidLoad()

        XCTAssertEqual(sut.countryCellViewModels, [CountryCellViewModel(country: .mockCanada, isFavorited: false)])
    }

    func test_viewDidLoadCalledErrors() async {
        let mockRepository = MockRepositoryFailing()
        let mockAppState = MockAppState()

        let sut = AllCountriesViewModel(repository: mockRepository, appState: mockAppState)
        await sut.viewDidLoad()

        XCTAssertEqual(sut.countryCellViewModels, [])
        // We should further check if the error properties are set on the viewmodel, but for this demo, I did not explicitly create the error views
    }
}

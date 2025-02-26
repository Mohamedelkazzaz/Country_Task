//
//  CountryViewModelTests.swift
//  Country_TaskTests
//
//  Created by Mohamed Elkazzaz on 27/02/2025.
//

import XCTest
@testable import Country_Task
import CoreLocation

final class CountryViewModelTests: XCTestCase {
    var viewModel: CountryViewModel!
    var mockService: MockCountryService!
    var mockLocationManager: MockLocationManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockService = MockCountryService()
        mockLocationManager = MockLocationManager()
        viewModel = CountryViewModel(countryService: mockService, locationManager: mockLocationManager)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockService = nil
        mockLocationManager = nil
        try super.tearDownWithError()
    }

    func testLoadCountries() throws {
        let expectation = self.expectation(description: "Load Countries")

        viewModel.onCountriesUpdate = {
            XCTAssertFalse(self.viewModel.filteredCountries.isEmpty, "Countries list should not be empty")
            expectation.fulfill()
        }

        viewModel.loadCountries()
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testSearchForCountry() throws {
        viewModel.loadCountries()
        viewModel.searchText = "Japan"

        XCTAssertEqual(viewModel.filteredCountries.count, 1, "Search should return one result")
        XCTAssertEqual(viewModel.filteredCountries.first?.name, "Japan", "Search result should be Japan")
    }

    func testPinCountry() throws {
        let country = Country(
            name: "France",
            capital: "Paris",
            currencies: [Currency(code: "EUR", name: "Euro", symbol: "€")],
            latlng: [48.8566, 2.3522],
            alpha2Code: "FR",
            flags: Flags(svg: nil, png: nil)
        )

        viewModel.pinCountry(country)

        XCTAssertEqual(viewModel.pinnedCountries.first?.name, "France", "Pinned country should be added to pinned list")
    }

    func testPinOnlyFiveCountries() throws {
        let countries = [
            Country(name: "France", capital: "Paris", currencies: [Currency(code: "EUR", name: "Euro", symbol: "€")], latlng: [48.8566, 2.3522], alpha2Code: "FR", flags: nil),
            Country(name: "Germany", capital: "Berlin", currencies: [Currency(code: "EUR", name: "Euro", symbol: "€")], latlng: [51.1657, 10.4515], alpha2Code: "DE", flags: nil),
            Country(name: "Japan", capital: "Tokyo", currencies: [Currency(code: "JPY", name: "Yen", symbol: "¥")], latlng: [35.6762, 139.6503], alpha2Code: "JP", flags: nil),
            Country(name: "USA", capital: "Washington, D.C.", currencies: [Currency(code: "USD", name: "Dollar", symbol: "$")], latlng: [38.9072, -77.0369], alpha2Code: "US", flags: nil),
            Country(name: "Italy", capital: "Rome", currencies: [Currency(code: "EUR", name: "Euro", symbol: "€")], latlng: [41.9028, 12.4964], alpha2Code: "IT", flags: nil),
            Country(name: "Brazil", capital: "Brasilia", currencies: [Currency(code: "BRL", name: "Real", symbol: "R$")], latlng: [-15.8267, -47.9218], alpha2Code: "BR", flags: nil)
        ]

        for country in countries {
            viewModel.pinCountry(country)
        }

        XCTAssertEqual(viewModel.pinnedCountries.count, 5, "Pinned countries list should not exceed five")
    }

    func testRemovePinnedCountry() throws {
        let country = Country(
            name: "Italy",
            capital: "Rome",
            currencies: [Currency(code: "EUR", name: "Euro", symbol: "€")],
            latlng: [41.9028, 12.4964],
            alpha2Code: "IT",
            flags: nil
        )

        viewModel.pinCountry(country)

        XCTAssertEqual(viewModel.pinnedCountries.count, 1, "There should be one country before removal")

        viewModel.removePinnedCountry(at: 0)

        XCTAssertEqual(viewModel.pinnedCountries.count, 0, "There should be no saved countries after removal")
    }
}

// MARK: - Mock Dependencies

class MockCountryService: CountryServiceProtocol {
    func fetchAllCountries(completion: @escaping (Result<[Country], Error>) -> Void) {
        let mockCountries = [
            Country(name: "Germany", capital: "Berlin", currencies: [Currency(code: "EUR", name: "Euro", symbol: "€")], latlng: [51.1657, 10.4515], alpha2Code: "DE", flags: nil),
            Country(name: "Japan", capital: "Tokyo", currencies: [Currency(code: "JPY", name: "Yen", symbol: "¥")], latlng: [35.6762, 139.6503], alpha2Code: "JP", flags: nil)
        ]
        completion(.success(mockCountries))
    }
}

class MockLocationManager: LocationManager {
    override func requestLocation() {
        let mockCoordinate = CLLocationCoordinate2D(latitude: 51.1657, longitude: 10.4515)
        onLocationUpdate?(mockCoordinate)
    }
}

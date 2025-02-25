//
//  CountryViewModel.swift
//  Country_Task
//
//  Created by Mohamed Elkazzaz on 25/02/2025.
//

import Foundation
import CoreLocation

class HomeViewModel {
    
    // Outputs
    var onCountriesUpdate: (() -> Void)?
    
    // Internal state
    private var allCountries: [Country] = [] {
        didSet { filterCountries() }
    }
    var pinnedCountries: [Country] = []
    var filteredCountries: [Country] = []
    
    var searchText: String = "" {
        didSet { filterCountries() }
    }
    
    private let countryService: CountryServiceProtocol
    private let locationManager: LocationManager
    
    init(countryService: CountryServiceProtocol, locationManager: LocationManager) {
        self.countryService = countryService
        self.locationManager = locationManager
        self.locationManager.onLocationUpdate = { [weak self] coordinate in
            self?.determineCountryFromLocation(coordinate: coordinate)
        }
    }
    
    func loadCountries() {
        countryService.fetchAllCountries { [weak self] result in
            switch result {
            case .success(let countries):
                self?.allCountries = countries
                self?.onCountriesUpdate?()
            case .failure(let error):
               print("Error fetching countries: \(error)")
            }
        }
    }
    
    private func filterCountries() {
        if searchText.isEmpty {
            filteredCountries = allCountries
        } else {
            filteredCountries = allCountries.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
        onCountriesUpdate?()
    }
    
    func determineCountryFromLocation(coordinate: CLLocationCoordinate2D) {
        guard !allCountries.isEmpty else { return }
        var closestCountry: Country?
        var closestDistance: CLLocationDistance = .greatestFiniteMagnitude
        
        let userLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        for country in allCountries {
            if let latlng = country.latlng, latlng.count == 2 {
                let countryLocation = CLLocation(latitude: latlng[0], longitude: latlng[1])
                let distance = userLocation.distance(from: countryLocation)
                if distance < closestDistance {
                    closestDistance = distance
                    closestCountry = country
                }
            }
        }
        
        if let countryToAdd = closestCountry {
            pinCountry(countryToAdd)
        } else {
            if let fallback = allCountries.first {
                pinCountry(fallback)
            }
        }
    }
    
    private func pinCountry(_ country: Country) {
        guard !pinnedCountries.contains(where: { $0.name == country.name }) else { return }
        if pinnedCountries.count < 5 {
            pinnedCountries.insert(country, at: 0)
            onCountriesUpdate?()
        }
    }
    
    func removePinnedCountry(at index: Int) {
        pinnedCountries.remove(at: index)
        onCountriesUpdate?()
    }
}

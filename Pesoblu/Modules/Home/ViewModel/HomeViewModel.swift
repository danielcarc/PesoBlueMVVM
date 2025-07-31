//
//  HomeViewModel.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 10/12/2024.
//

import Foundation

protocol HomeViewModelProtocol {
    func getDolarBlue() async throws -> DolarBlue?
    func getUserCountry() -> String?
    func getValueForCountry(countryCode: String) async throws -> String
    func fetchPlaces(city: String) throws -> [PlaceItem]
    func fetchCitysItems() -> [CitysItem]
    func fetchDiscoverItems() -> [DiscoverItem]
}


final class HomeViewModel: HomeViewModelProtocol{
    private let currencyService: CurrencyServiceProtocol
    private let locationService: LocationServiceProtocol
    private let placesService: PlaceServiceProtocol
    private let discoverDataService: DiscoverDataServiceProtocol
    private let cityDataService: CityDataServiceProtocol
    
    init(currencyService: CurrencyServiceProtocol,
         locationService: LocationServiceProtocol,
         placesService: PlaceServiceProtocol,
         discoverDataService: DiscoverDataServiceProtocol,
         cityDataService : CityDataServiceProtocol) {
        self.currencyService = currencyService
        self.locationService = locationService
        self.placesService = placesService
        self.discoverDataService = discoverDataService
        self.cityDataService = cityDataService
    }
    
    private var discoverItems: [DiscoverItem] = []
    private var citysItem: [CitysItem] = []
    private var dolarBlue: DolarBlue?
    //private var currency : Rates = Rates(BRL: Brl(rate: nil), CLP: Clp(rate: nil), UYU: Uyu(rate: nil))
    
    func fetchCitysItems() -> [CitysItem]{
        return cityDataService.fetch()
    }
    
    func fetchDiscoverItems() -> [DiscoverItem]{
        return discoverDataService.fetch()
    }
    
    func getDolarBlue() async throws -> DolarBlue? {
        return try await currencyService.getDolarBlue()
    }
    
    func getValueForCountry(countryCode: String) async throws -> String {
        return try await currencyService.getValueForCountry(countryCode: countryCode)
    }
    
    func fetchPlaces(city: String) throws -> [PlaceItem] {
        return try placesService.fetchPlaces(city: city)
    }
    
    func getUserCountry () -> String?{
        return locationService.getUserCountry()
    }

}

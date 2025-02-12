//
//  PesobluTests.swift
//  PesobluTests
//
//  Created by Daniel Carcacha on 10/02/2025.
//

import Testing
import XCTest
import UIKit
@testable import Pesoblu


final class HomeViewControllerTests: XCTestCase{
    
    private lazy var sut: HomeViewController = {
        var sut = HomeViewController()
        _ = sut.view
        return sut
    }()
    
    func test_whenViewLoads_citysCollectionViewsIsNotNil(){
        
        XCTAssertNotNil(self.sut.citysCView)
    }
    func test_whenViewLoads_discoverCollectionViewsIsNotNil(){
        
        XCTAssertNotNil(self.sut.discoverBaCView)
    }
    
    func test_whenViewLoads_quickConversionViewsIsNotNil(){
        XCTAssertNotNil(self.sut.quickConversorView)
        
    }
    
    func test_HomeViewController_shouldBeCitysCviewDelegate(){
        
        XCTAssertTrue(self.sut.citysCView.delegate === sut)
    }
    
    func test_CitysCollectionView_conformsToUICollectionViewDataSource() {
        // Instanciamos el CitysCollectionView
        let citysCView = CitysCollectionView()

        // Comprobamos que el objeto se conforme con el protocolo UICollectionViewDataSource
        XCTAssertTrue(citysCView.conforms(to: UICollectionViewDataSource.self))

        // Verificamos que el dataSource del collectionView sea el propio CitysCollectionView
        XCTAssertTrue(citysCView.collectionViewForTesting.dataSource === citysCView)
    }
    func test_DiscoverCollectionView_conformsToUICollectionViewDataSource() {
        // Instanciamos el CitysCollectionView
        let discoverCView = CitysCollectionView()

        // Comprobamos que el objeto se conforme con el protocolo UICollectionViewDataSource
        XCTAssertTrue(discoverCView.conforms(to: UICollectionViewDataSource.self))

        // Verificamos que el dataSource del collectionView sea el propio CitysCollectionView
        XCTAssertTrue(discoverCView.collectionViewForTesting.dataSource === discoverCView)
    }
    
    @MainActor
    func testSetupQuickConversor_Success() async {
        let mockViewModel = MockHomeViewModel()
        let view = QuickConversorView()
        let sut = HomeViewController(homeViewModel: mockViewModel, quickConversorView: view)

        sut.setupQuickConversor()
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 segundos

        XCTAssertEqual(view.usdLabelTesting.text, "$ 1000.00")
        XCTAssertEqual(view.arsvalueLabelTesting.text, "$ 5000.0")
    }
    
    @MainActor
    func testSetupQuickConversor_InvalidURL() async {
        let mockViewModel = MockHomeViewModel()
        mockViewModel.shouldFail = true
        mockViewModel.apiError = .invalidURL

        let sut = HomeViewController(homeViewModel: mockViewModel)

        sut.setupQuickConversor()
        try? await Task.sleep(nanoseconds: 500_000_000)

        XCTAssertEqual(sut.alertMessage, "URL mal formada")
    }
    
    @MainActor
    func testSetupQuickConversor_DecodingError() async {
        let mockViewModel = MockHomeViewModel()
        mockViewModel.shouldFail = true
        mockViewModel.apiError = .decodingError

        let sut = HomeViewController(homeViewModel: mockViewModel)

        sut.setupQuickConversor()
        try? await Task.sleep(nanoseconds: 500_000_000)

        XCTAssertEqual(sut.alertMessage, "Error al decodificar los datos")
    }
    
    

}


class MockHomeViewModel: HomeViewModelProtocol {
    func fetchPlaces(city: String) throws -> [PlaceItem] {
        return []
    }
    
    var shouldFail = false
    var apiError: APIError?
    
    func getDolarBlue() async throws -> DolarBlue? {
        if shouldFail, let error = apiError {
            throw error
        }
        let dolar: DolarBlue = .init(moneda: "1", casa: "2", nombre: "3", compra: 1000.0, venta: 1000.0, fechaActualizacion: "13")
        
        return dolar  // Valor simulado
    }

    func getUserCountry() -> String? {
        return "AR"
    }

    func getValueForCountry(countryCode: String) async throws -> String {
        if shouldFail, let error = apiError {
            throw error
        }
        return "5000.0" // Valor simulado
    }
}


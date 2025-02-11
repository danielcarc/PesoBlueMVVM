//
//  PesobluTests.swift
//  PesobluTests
//
//  Created by Daniel Carcacha on 10/02/2025.
//

import Testing
import XCTest
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

    
    
    
}

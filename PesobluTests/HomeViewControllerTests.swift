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
    
    func test_whenViewLoads_collectionViewIsNotNil(){
        
        XCTAssertNotNil(self.sut.citysCView)
    }
}

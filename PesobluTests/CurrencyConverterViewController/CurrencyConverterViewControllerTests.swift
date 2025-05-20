//
//  CurrencyConverterViewControllerTests.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 25/03/2025.
//

import XCTest
@testable import Pesoblu
import Combine

class CurrencyConverterViewControllerTests: XCTestCase {
    var viewController: CurrencyConverterViewController!
    var mockViewModel: CurrencyConverterViewModel!
    let mockCurrencyService = MockCurrencyService()
    let mockNotificationService = MockNotificationService()
    
    override func setUp() {
        super.setUp()
        
        mockViewModel = CurrencyConverterViewModel(currencyService: mockCurrencyService, notificationService: mockNotificationService)
        viewController = CurrencyConverterViewController(currencyConverterViewModel: mockViewModel)
        // Agregar el viewController a un UINavigationController
        let navigationController = UINavigationController(rootViewController: viewController)
                
        navigationController.loadViewIfNeeded() // Carga la vista
    }
    
    override func tearDown() {
        viewController = nil
        mockViewModel = nil
        super.tearDown()
    }
    
    func testSetupConfiguresNavigation() {
        // When
        viewController.setup()
        
        // Then
        XCTAssertEqual(viewController.title, "Convertir")
        XCTAssertTrue(viewController.navigationController?.navigationBar.prefersLargeTitles ?? false)
    }
    
    func testStartTimerCallsGetDolar() async {
        // Given
        mockCurrencyService.dolarValue = 150.0
        let expectation = XCTestExpectation(description: "Timer triggers getDolar")
        
        // When
        // Ejecutamos el bloque del timer manualmente en lugar de esperar 6000s
        Task {
            if let dolar = try await viewController.currencyConverterViewModel.getDolarBlue() {
                let dolarNow = String(format: "%.2f", dolar.venta)
                await viewController.currencyConverterViewModel.checkPermission(dolar: dolarNow)
            }
            // Then
            XCTAssertTrue(self.mockNotificationService.didCheckPermission)
            XCTAssertEqual(self.mockNotificationService.lastDolar, "150.00")
            expectation.fulfill()
        }
        
        await viewController.startTimer()
                
        // Esperamos asíncronamente la expectativa
        await fulfillment(of: [expectation], timeout: 2.0)
    }
}

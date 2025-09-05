//
//  ChangeViewModel.swift
//  PesoBlueMVVM
//
//  Created by Daniel Francisco Carcacha on 04/10/23.
//

import Foundation

enum CurrencyCode: String, CaseIterable {
    case UYU, BRL, CLP, EUR, MXN, COP, GBP, JPY, ILS, PYG, PEN, RUB, CAD, BOB

    var title: String {
        NSLocalizedString("currency.\(rawValue).title", comment: "")
    }

    var label: String {
        NSLocalizedString("currency.\(rawValue).label", comment: "")
    }

    func rate(from rates: Rates) -> String? {
        switch self {
        case .UYU: return rates.UYU?.rate
        case .BRL: return rates.BRL?.rate
        case .CLP: return rates.CLP?.rate
        case .EUR: return rates.EUR?.rate
        case .MXN: return rates.MXN?.rate
        case .COP: return rates.COP?.rate
        case .GBP: return rates.GBP?.rate
        case .JPY: return rates.JPY?.rate
        case .ILS: return rates.ILS?.rate
        case .PYG: return rates.PYG?.rate
        case .PEN: return rates.PEN?.rate
        case .RUB: return rates.RUB?.rate
        case .CAD: return rates.CAD?.rate
        case .BOB: return rates.BOB?.rate
        }
    }
}

protocol ChangeViewModelDelegate: AnyObject {
    func didFinish()
    func didFail(error: Error)
}

protocol ChangeViewModelProtocol {
    func getChangeOfCurrencies() async
    var delegate: ChangeViewModelDelegate? { get set }
    var currencies: [CurrencyItem] { get set }
}


class ChangeViewModel: ChangeViewModelProtocol{
    
    
    private let currencyService: CurrencyServiceProtocol
    var currencies: [CurrencyItem]
    var rates : Rates
    weak var delegate: ChangeViewModelDelegate?
    
    init(delegate: ChangeViewModelDelegate? = nil, currencyService: CurrencyServiceProtocol, currencies: [CurrencyItem], rates: Rates) {
        self.delegate = delegate
       
        self.currencyService = currencyService
        self.currencies = currencies
        self.rates = rates
    }
    
    
    func getChangeOfCurrencies() async {
        await fetchCurrencies()
    }

    @MainActor
    private func fetchCurrencies() async {
        do {
            if var mep = try await currencyService.getDolarMep() {
                mep.currencyTitle = NSLocalizedString("currency.MEP.title", comment: "")
                mep.currencyLabel = NSLocalizedString("currency.MEP.label", comment: "")
                rates = try await currencyService.getChangeOfCurrencies()
                var updated: [CurrencyItem] = [mep]
                for code in CurrencyCode.allCases {
                    updated.append(getCurrencyValue(for: code, currency: mep.venta))
                }
                await MainActor.run {
                    self.currencies.append(contentsOf: updated)
                    self.delegate?.didFinish()
                }
            }
        } catch {
            await MainActor.run {
                self.delegate?.didFail(error: error)
            }
        }
    }
}

    // MARK: - Currency Methods

extension ChangeViewModel {

    func getCurrencyValue(for code: CurrencyCode, currency: Double) -> CurrencyItem {
        let rateValue = Double(code.rate(from: rates) ?? "0.0") ?? 0.0
        let result = rateValue != 0 ? currency / rateValue : 0.0
        return CurrencyConversion(
            currencyTitle: code.title,
            currencyLabel: code.label,
            rate: String(format: "%.2f", result)
        )
    }
}

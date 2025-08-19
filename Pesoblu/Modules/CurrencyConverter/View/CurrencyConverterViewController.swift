//
//  CurrencyViewController.swift
//  PesoBlueMVVM
//
//  Created by Daniel Francisco Carcacha on 24/10/23.
//

import UIKit
import Combine
import UserNotifications

final class CurrencyConverterViewController: UIViewController  {

    private var cancellables = Set<AnyCancellable>()
    let viewModel: CurrencyConverterViewModelProtocol
    private let selectedCurrency: CurrencyItem
    private weak var timer: Timer?

    private lazy var converterView: CurrencyConverterView = {
        let view = CurrencyConverterView(/*viewModel: viewModel*/)
        //view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(viewModel: CurrencyConverterViewModelProtocol,
         currency: CurrencyItem) {
        self.viewModel = viewModel
        self.selectedCurrency = currency
        
        
        super.init(nibName: nil, bundle: nil)
    }
    
    /// This view controller is intended to be instantiated programmatically.
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func loadView() {
        self.view = converterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        converterView.alpha = 0
        converterView.transform = CGAffineTransform(translationX: 0, y: 30)
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut]) {
            self.converterView.alpha = 1
            self.converterView.transform = .identity
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
}
extension CurrencyConverterViewController {
    
    func setup() {
        title = NSLocalizedString("currency_converter_title", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = false
        let backButton = UIBarButtonItem(image: UIImage(named: "nav-arrow-left"), style: .plain, target: self, action: #selector(didTapBack))
        backButton.tintColor = UIColor.black

        self.navigationItem.leftBarButtonItem = backButton
        self.view.backgroundColor = UIColor(hex: "F0F8FF")
        startTimer()
        viewModel.updateCurrency(selectedCurrency: selectedCurrency)
        converterView.setCurrency(currency: selectedCurrency)
        setupBindings()
        setupAmountTextFieldBinding()
    }
}

//MARK: - Local Notifications

extension CurrencyConverterViewController {

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 600, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            Task {
                if let dolar = try await self.viewModel.getDolarBlue() {
                    let dolarNow = String(format: "%.2f", dolar.venta)
                    await self.viewModel.checkPermission(dolar: dolarNow)
                }
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
//#Preview("CurrencyViewController", traits: .defaultLayout, body: { CurrencyViewController()})

//MARK: - Button Methods
extension CurrencyConverterViewController {
    
    @objc func didTapBack() {
        // Regresar a la vista anterior
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Bindings
extension CurrencyConverterViewController  {
    func setupBindings() {
        viewModel.getConvertedValues()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (currencyFromPeso, currencyToPeso, fromDolarToCurrency, currencyToDolarValue) in
                guard let self = self else { return }

                if self.selectedCurrency.currencyLabel == "Dólar Bolsa de Valores / MEP" {
                    self.converterView.updateValues(
                        fromPeso: currencyToDolarValue,
                        toPeso: fromDolarToCurrency,
                        fromDolar: fromDolarToCurrency,
                        toDolar: currencyToDolarValue
                    )
                } else {
                    self.converterView.updateValues(
                        fromPeso: currencyFromPeso,
                        toPeso: currencyToPeso,
                        fromDolar: fromDolarToCurrency,
                        toDolar: currencyToDolarValue
                    )
                }
            }
            .store(in: &cancellables)
    }

    func setupAmountTextFieldBinding() {
        converterView.onAmountChanged = { [weak self] amount in
            guard let self = self else { return }
            self.viewModel.updateAmount(amount)
            if amount == nil || amount == 0 {
                self.resetControls()
            }
        }
    }

    private func resetControls() {
        converterView.resetControls()
    }
}

#if DEBUG
extension CurrencyConverterViewController {
    internal var timerForTesting: Timer? { timer }
}
#endif

//
//  ChangeViewController.swift
//  PesoBlueMVVM
//
//  Created by Daniel Francisco Carcacha on 29/09/23.
//

import UIKit

class ChangeViewController: UIViewController  {
    
    private var viewModel : ChangeViewModelProtocol
    private var changeCView: ChangeCollectionView
    private var changeHeightConstraint: NSLayoutConstraint?
    var onSelectCurrency: ((CurrencyItem) -> Void)?
    
    init(viewModel: ChangeViewModelProtocol, changeCView: ChangeCollectionView) {
        self.viewModel = viewModel
        self.changeCView = changeCView
        
        super.init(nibName: nil, bundle: nil)
    }
    
    /// This view controller is intended to be instantiated programmatically.
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }
    
    private var mainScrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.bounces = true
        
        return scrollView
    }()
    
    private var contentView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        Task {
            await viewModel.getChangeOfCurrencies()
        }
        setTitle()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.applyVerticalGradientBackground(colors: [
            UIColor(red: 236/255, green: 244/255, blue: 255/255, alpha: 1),
            UIColor(red: 213/255, green: 229/255, blue: 252/255, alpha: 1)
        ])
    }
}

    // MARK: - Setup CollectionView

private extension ChangeViewController {
    func setup() {
        
        changeCView.delegate = self
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        contentView.addSubview(changeCView)
        
        changeCView.translatesAutoresizingMaskIntoConstraints = false
        changeHeightConstraint = changeCView.heightAnchor.constraint(equalToConstant: 0)
        
        
        NSLayoutConstraint.activate([
            
            mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.leadingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.trailingAnchor, constant: -10),
            contentView.widthAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.widthAnchor, constant: -20),
            contentView.bottomAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.bottomAnchor),
            
            changeCView.topAnchor.constraint(equalTo: contentView.topAnchor),
            changeCView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            changeCView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            changeCView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            changeHeightConstraint!

        ])
        changeCView.onHeightChange = { [weak self] height in
            self?.changeHeightConstraint?.constant = height
            self?.view.layoutIfNeeded()
        }
    }
}

extension ChangeViewController {
    func setTitle() {
        title = NSLocalizedString("exchange_rate_title", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}
    // MARK: - ChangeCollectionViewDelegate Methods

extension ChangeViewController: ChangeCollectionViewDelegate {
    func didSelectCurrency(for currencyItem: CurrencyItem) {
        AppLogger.debug("didSelectCurrency \(currencyItem)")
        onSelectCurrency?(currencyItem)
    }
}

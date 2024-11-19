//
//  HomeViewController.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 12/11/2024.
//

import UIKit


//hacer el conversion rapida
//ver de agregar mas ademas de brasil, uruguay y chile
//debajo el collection view de descubre buenos aires
//luego el de experiencias tipo tango, cafeteria, gastronomia, cocteleria y mas
//y luego top ciudades para visitar empezando con Bariloche, mendoza, ushuaia, cordoba

class HomeViewController: UIViewController {

    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    // Conversor rápido Section
    private let quickConverterTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Conversor rápido"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = UIColor(named: "TextColor")
        return label
    }()
    
    private let usdLabel = createCurrencyLabel(symbol: "USD", description: "Dólar estadounidense", amount: "1,000")
    private let arsLabel = createCurrencyLabel(symbol: "ARS", description: "Peso argentino", amount: "99,000")
    
    // Descubre Argentina Section
    private let discoverTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Descubre Argentina"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    private let discoverCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
    }

    private func setupView() {
        view.backgroundColor = .white
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Layout for scroll view
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        setupQuickConverterSection()
    }
    
    // MARK: - Quick Converter Section
    private func setupQuickConverterSection() {
        let stackView = UIStackView(arrangedSubviews: [quickConverterTitleLabel, usdLabel, arsLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    private static func createCurrencyLabel(symbol: String, description: String, amount: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "\(symbol) | \(description)\n\(amount)"
        return label
    }
    
    private func setupCollectionView() {
        discoverCollectionView.dataSource = self
        discoverCollectionView.register(DiscoverCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
}

// MARK: - UICollectionView DataSource
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3 // Aquí pondrías los datos reales
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? DiscoverCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}

class DiscoverCollectionViewCell: UICollectionViewCell {
    let backgroundImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(backgroundImageView)
        backgroundImageView.frame = contentView.bounds
        backgroundImageView.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


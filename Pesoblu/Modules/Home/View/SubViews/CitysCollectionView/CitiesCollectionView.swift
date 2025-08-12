//
//  CitysCollectionView.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 12/01/2025.
//
import UIKit

protocol CitiesViewDelegate: AnyObject {
    func didUpdateItemCount(_ count: Int)
    func didSelectItem(_ city: CitiesItem)
    
}

final class CitiesCollectionView: UIView {
    
    private var data: [CitiesItem] = []
    private let homeViewModel: HomeViewModelProtocol  // Usamos el protocolo en lugar de la clase concreta
    weak var delegate: CitiesViewDelegate?
    
    init(homeViewModel: HomeViewModelProtocol, frame: CGRect = .zero) {
        self.homeViewModel = homeViewModel
        super.init(frame: frame)
        setup()
    }
    
    /// This view is intended to be instantiated programmatically.
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }
    
    func loadData() {
        self.data = homeViewModel.fetchCitiesItems()
        citiesCollectionView.reloadData()
        citiesCollectionView.collectionViewLayout.invalidateLayout()
        delegate?.didUpdateItemCount(data.count)
    }
    
    private lazy var discoverArgentinaLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .left
        label.text = NSLocalizedString("top_cities_to_visit", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var citiesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let totalHorizontalPadding: CGFloat = 40
        let totalSpacing = layout.minimumInteritemSpacing * 1 // Espacio entre dos celdas
        let availableWidth = UIScreen.main.bounds.width - totalHorizontalPadding - layout.minimumInteritemSpacing
        let itemWidth = availableWidth / 2
        //layout.itemSize = .init(width: cellWidth, height: 130)
        layout.itemSize = CGSize(width: itemWidth, height: 130)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CitiesCell.self, forCellWithReuseIdentifier: "CitysCell")
        return collectionView
    }()
    
}

//MARK: - Setup Methods and Constraints

extension CitiesCollectionView {
    
    func setup() {
        self.backgroundColor = .clear
        addSubview(discoverArgentinaLabel)
        addSubview(citiesCollectionView)
        
        NSLayoutConstraint.activate([
            discoverArgentinaLabel.topAnchor.constraint(equalTo: topAnchor),
            discoverArgentinaLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            discoverArgentinaLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            citiesCollectionView.topAnchor.constraint(equalTo: discoverArgentinaLabel.bottomAnchor, constant: 16),
            citiesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            citiesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            citiesCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
    }
}

//MARK: - UICollectionViewDataSource Methods

extension CitiesCollectionView: UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = data[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CitysCell", for: indexPath) as! CitiesCell
        cell.set(image: item.image, title: item.name)
        return cell
    }
}

extension CitiesCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCity = data[indexPath.item]
        delegate?.didSelectItem(selectedCity)
    }
}


extension CitiesCollectionView  {
    var collectionViewForTesting: UICollectionView {
        return citiesCollectionView
    }
}

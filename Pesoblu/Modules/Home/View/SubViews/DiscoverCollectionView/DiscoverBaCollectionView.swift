//
//  DiscoverBaCell.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 22/11/2024.
//

import UIKit
import Kingfisher

protocol CollectionViewSelectionDelegate: AnyObject  {
    func didSelectItem(_ item: DiscoverItem) // Define el tipo de datos que envías
}

final class DiscoverBaCollectionView: UIView  {
    
    private var data: [DiscoverItem] = []
    private var homeViewModel : HomeViewModelProtocol
    weak var delegate: CollectionViewSelectionDelegate?
    
    
    
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
    
    func setData() {
        self.data = homeViewModel.fetchDiscoverItems()
        discoverCollectionView.reloadData()
    }
    
    func updateData() {
        self.data = homeViewModel.fetchDiscoverItems()
        discoverCollectionView.reloadData()
    }
    
    private lazy var discoverArgentinaLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .left
        label.text = NSLocalizedString("discover_buenos_aires", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var discoverCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 160, height: 120)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10

        let vw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vw.register(DiscoverCell.self, forCellWithReuseIdentifier: "DiscoverCell")
        vw.showsHorizontalScrollIndicator = false
        vw.isScrollEnabled = true
        vw.backgroundColor = .clear
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.delegate = self
        vw.dataSource = self
        return vw
    }()

}

//MARK: - UICollectionViewDataSource

extension DiscoverBaCollectionView: UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = data[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverCell", for: indexPath) as! DiscoverCell
        cell.set(image: item.image, title: item.name)
        return cell
    }
    
}

//MARK: - UICollectionViewDelegate Methods

extension DiscoverBaCollectionView: UICollectionViewDelegate  {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedItem = data[indexPath.item]
        delegate?.didSelectItem(selectedItem)
        
    }
    
}

private extension DiscoverBaCollectionView  {
    
    func setup() {
        self.backgroundColor = .clear
        addSubview(discoverArgentinaLabel)
        addSubview(discoverCollectionView)
        
        NSLayoutConstraint.activate([
            discoverArgentinaLabel.topAnchor.constraint(equalTo: topAnchor),
            discoverArgentinaLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            discoverArgentinaLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            discoverCollectionView.topAnchor.constraint(equalTo: discoverArgentinaLabel.bottomAnchor, constant: 16),
            discoverCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            discoverCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            discoverCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
    }
}

extension DiscoverBaCollectionView  {
    var collectionViewForTesting: UICollectionView {
        return discoverCollectionView
    }
}

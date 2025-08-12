//
//  PlacesListCollectionView.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 21/01/2025.
//

import Foundation
import UIKit

protocol PlacesListCollectionViewDelegate: AnyObject  {
    func didUpdateItemCount(_ count: Int)
    func didSelectItem(_ item: PlaceItem)
    func placesListCollectionViewDidFailToLoadImage(_ collectionView: PlacesListCollectionView, error: Error)
}

final class PlacesListCollectionView: UIView  {

    var placeData: [PlaceItemViewModel] = []
    weak var delegate: PlacesListCollectionViewDelegate?
    var selectedIndex: IndexPath?

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }

    /// This view is intended to be instantiated programmatically.
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }

    func updateData(with items: [PlaceItemViewModel]) {
        placeData = items

        let text = "\(placeData.count) lugares"
        quantityLabel.text = text
        quantityLabel.accessibilityLabel = text
        delegate?.didUpdateItemCount(placeData.count)
        placeCollectionView.reloadData()
    }
    
    private lazy var quantityLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.text = NSLocalizedString("quantity_restaurants_label", comment: "Quantity of restaurants label")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityIdentifier = "quantity_label"
        label.accessibilityLabel = label.text
        return label
    }()
    
    private lazy var placeCollectionView: UICollectionView = {
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = screenWidth - 40
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: itemWidth, height: 278)
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10) // Añade márgenes
        layout.minimumLineSpacing = 10 // Espaciado vertical
        layout.minimumInteritemSpacing = 0
        
        let vw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vw.register(PlaceCell.self, forCellWithReuseIdentifier: "PlaceCell")
        vw.showsHorizontalScrollIndicator = false
        vw.backgroundColor = .clear 
        vw.isScrollEnabled = false
        vw.dataSource = self
        vw.delegate = self
        vw.translatesAutoresizingMaskIntoConstraints = false
        return vw
        
    }()
}


//MARK: - UICollectionViewDataSource Methods

extension PlacesListCollectionView: UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        placeData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = placeData[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceCell", for: indexPath) as? PlaceCell else {
            return UICollectionViewCell()
        }
        cell.set(image: nil,
                 title: item.title,
                 price: item.price,
                 formattedDistance: item.formattedDistance,
                 type: item.type)
        cell.updateImage(url: item.imageUrl)
        return cell
    }
    
}

//MARK: - UICOllectionViewDelegate Methods


extension PlacesListCollectionView: UICollectionViewDelegate  {

   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let item: PlaceItem = placeData[indexPath.item].place
       delegate?.didSelectItem(item)
    }
}

//MARK: - Setup and Constraints

extension PlacesListCollectionView  {
    
    func setup() {
        self.backgroundColor = .clear
        addSubview(quantityLabel)
        addSubview(placeCollectionView)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        placeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                
            quantityLabel.topAnchor.constraint(equalTo: topAnchor),
            quantityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            quantityLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            quantityLabel.heightAnchor.constraint(equalToConstant: 22),
            
            placeCollectionView.topAnchor.constraint(equalTo: quantityLabel.bottomAnchor, constant: 10),
            placeCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            placeCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            placeCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        
        ])
    }
}

extension PlacesListCollectionView: PlaceCellDelegate  {
    func placeCellDidFailToLoadImage(_ cell: PlaceCell, error: any Error) {
        delegate?.placesListCollectionViewDidFailToLoadImage(self, error: error)
    }
    
    
}

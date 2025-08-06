//
//  PlacesListCollectionView.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 21/01/2025.
//

import Foundation
import UIKit
import CoreLocation

protocol PlacesListCollectionViewDelegate: AnyObject {
    func didUpdateItemCount(_ count: Int)
    func didSelectItem(_ item: PlaceItem)
    func placesListCollectionViewDidFailToLoadImage(_ collectionView: PlacesListCollectionView, error: Error)
}

class PlacesListCollectionView: UIView {

    var viewModel: PlacesListViewModelProtocol

    init(viewModel: PlacesListViewModelProtocol, frame: CGRect = .zero) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setup()
        locationManager.onLocationUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.placeCollectionView.reloadData()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var placeData: [PlaceItem] = []
    private let locationManager = LocationManager()
    weak var delegate: PlacesListCollectionViewDelegate?
    var selectedIndex: IndexPath?
    
    
    func updateData(for places: [PlaceItem], by filter: String){
        var filteredPlaces: [PlaceItem] = []
        if filter != "All" {
            filteredPlaces = viewModel.filterData(places: places, filter: filter)
        }else{
            filteredPlaces = places
        }
        placeData = filteredPlaces
        quantityLabel.text = "\(placeData.count) lugares"
        delegate?.didUpdateItemCount(placeData.count)
        placeCollectionView.reloadData()
    }
    
    private lazy var quantityLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.text = "Cantidad de restaurantes"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
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

extension PlacesListCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        placeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = placeData[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceCell", for: indexPath) as! PlaceCell

        // Configura los datos básicos
        cell.set(image: nil, title: item.name, price: item.price ?? "N/A", distance: "Cargando...", type: item.subtitle ?? "N/A")

        // Actualiza la distancia de forma independiente
        if let userLocation = locationManager.userLocation {
            Task {
                let distance = viewModel.calculateDistance(from: userLocation, to: item)
                await MainActor.run {
                    if collectionView.indexPath(for: cell) == indexPath { // Verifica la reutilización
                        cell.updateDistance(distance)
                    }
                }
            }
        }
        //usamos ahora kingfisher para la descarga
        cell.updateImage(url: item.imageUrl)
        return cell
    }
    
}

//MARK: - UICOllectionViewDelegate Methods


extension PlacesListCollectionView: UICollectionViewDelegate {
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let item: PlaceItem = placeData[indexPath.item]
       delegate?.didSelectItem(item)
    }
}

//MARK: - Setup and Constraints

extension PlacesListCollectionView {
    
    func setup(){
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

extension PlacesListCollectionView: PlaceCellDelegate {
    func placeCellDidFailToLoadImage(_ cell: PlaceCell, error: any Error) {
        delegate?.placesListCollectionViewDidFailToLoadImage(self, error: error)
    }
    
    
}

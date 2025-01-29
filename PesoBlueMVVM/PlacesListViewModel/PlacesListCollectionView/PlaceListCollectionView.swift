//
//  PlaceListCollectionView.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 21/01/2025.
//

import Foundation
import UIKit
import CoreLocation

protocol PlaceListCollectionViewDelegate: AnyObject {
    func didUpdateItemCount(_ count: Int)
    func didSelectItem(_ item: PlaceItem)
}

class PlaceListCollectionView: UIView{
    
    var viewModel = PlaceListViewModel()
    
    var placeData: [PlaceItem] = []
    private let locationManager = LocationManager()
    weak var delegate: PlaceListCollectionViewDelegate?
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
        layout.itemSize = .init(width: itemWidth, height: 238)
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10) // Añade márgenes
        layout.minimumLineSpacing = 10 // Espaciado vertical
        layout.minimumInteritemSpacing = 0
        
        let vw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vw.register(PlaceCell.self, forCellWithReuseIdentifier: "PlaceCell")
        vw.showsHorizontalScrollIndicator = false
        vw.backgroundColor = UIColor(hex: "F0F8FF")
        vw.isScrollEnabled = false
        vw.dataSource = self
        vw.delegate = self
        vw.translatesAutoresizingMaskIntoConstraints = false
        return vw
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        locationManager.onLocationUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.placeCollectionView.reloadData()
            }
        }
    }

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
}


//MARK: - UICollectionViewDataSource Methods

extension PlaceListCollectionView: UICollectionViewDataSource{
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

        // Descarga la imagen de forma independiente
        Task {
            do {
                let image = try await viewModel.downloadImage(from: item.imageUrl)
                await MainActor.run {
                    if collectionView.indexPath(for: cell) == indexPath { // Verifica la reutilización
                        cell.updateImage(image)
                    }
                }
            } catch {
                print("Error descargando imagen: \(error)")
            }
        }

        return cell
    }
    
}

//MARK: - UICOllectionViewDelegate Methods


extension PlaceListCollectionView: UICollectionViewDelegate{
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
       let item: PlaceItem = placeData[indexPath.item]
       delegate?.didSelectItem(item)
        
    }

}

//MARK: - Setup and Constraints

extension PlaceListCollectionView{
    
    func setup(){
        
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

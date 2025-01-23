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
}

class PlaceListCollectionView: UIView{
    
    var viewModel = PlaceListViewModel()
    
    var placeData: [PlaceItem] = []
    private let locationManager = LocationManager()
    weak var delegate: PlaceListCollectionViewDelegate?
    
    
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
        vw.backgroundColor = .white
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

        // Configurar datos básicos de la celda
        cell.set(image: nil, title: item.name, price: item.price ?? "N/A", distance: "Cargando...", type: item.subtitle ?? "N/A")
        
        // Obtener la ubicación del usuario
        var distance: String = "Cargando..."
        if let userLocation = locationManager.userLocation {
            distance = viewModel.calculateDistance(from: userLocation, to: item)
        }
        
        // Descargar la imagen de forma asíncrona y actualizar todo en un solo paso
        Task {
            do {
                let image = try await viewModel.downloadImage(from: item.imageUrl)
                // Actualizar la celda completamente en el hilo principal
                await MainActor.run {
                    cell.set(image: image, title: item.name, price: item.price ?? "N/A", distance: distance, type: item.subtitle ?? "N/A")
                }
            } catch {
                print("Error descargando imagen: \(error)")
                // Actualizar solo los datos disponibles si hay un error
                await MainActor.run {
                    cell.set(image: nil, title: item.name, price: item.price ?? "N/A", distance: distance, type: item.subtitle ?? "N/A")
                }
            }
        }

        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.width - 20, height: 228) // Ajusta el ancho según corresponda
//    }
    
}

extension PlaceListCollectionView: UICollectionViewDelegate{
    
    //me falta agregar constraints y addsubviews ademas de los metodos para rellenar las celdas
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

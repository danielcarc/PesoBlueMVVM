//
//  PlaceListCollectionView.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 21/01/2025.
//

import Foundation
import UIKit

class PlaceListCollectionView: UIView{
    
    var placeData: [PlaceItem] = []
    
    private lazy var quantityLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.text = "Cantidad de restaurantes"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var placeCollectionView: UICollectionView = {
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = screenWidth - 20
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: itemWidth, height: 160)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        
        let vw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vw.register(PlaceCell.self, forCellWithReuseIdentifier: "PlaceCell")
        vw.showsHorizontalScrollIndicator = false
        vw.backgroundColor = .white
        vw.dataSource = self
        vw.delegate = self
        vw.translatesAutoresizingMaskIntoConstraints = false
        return vw
        
    }()
    
    
    
}


//MARK: - UICollectionViewDataSource Methods

extension PlaceListCollectionView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        placeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = placeData[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceCell", for: indexPath) as! PlaceCell
        //cell.set(image: item.image, title: item.name)
        return cell
    }
    
}

extension PlaceListCollectionView: UICollectionViewDelegate{
    
    //me falta agregar constraints y addsubviews ademas de los metodos para rellenar las celdas
    
}

//
//  CitysCollectionView.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 12/01/2025.
//
import UIKit

class CitysCollectionView: UICollectionView{
    
    private var data : [CitysItem] = []
    private var homeViewModel = HomeViewModel()
    
    func updateData() {
        
        self.data = homeViewModel.fetchCitysItems()
        collectionView.reloadData()
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let totalSpacing = layout.minimumInteritemSpacing * 1 // Espacio entre dos celdas
        let availableWidth = UIScreen.main.bounds.width - totalSpacing - 20
        let cellWidth = availableWidth / 2
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth * 1.2)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CitysCell.self, forCellWithReuseIdentifier: "CitysCell")
        return collectionView
    }()
    
}

//MARK: - Setup Methods and Constraints

extension CitysCollectionView{
    
    
}

//MARK: - UICollectionViewDataSource Methods

extension CitysCollectionView: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = data[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CitysCell", for: indexPath) as! CitysCell
        cell.set(image: item.image, title: item.name)
        return cell
    }
}

extension CitysCollectionView: UICollectionViewDelegate{
    
}

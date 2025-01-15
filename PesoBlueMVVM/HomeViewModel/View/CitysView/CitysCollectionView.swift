//
//  CitysCollectionView.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 12/01/2025.
//
import UIKit

protocol CitysViewDelegate: AnyObject{
    func didUpdateItemCount(_ count: Int)
    func didSelectItem(_ city: CitysItem)
    
}

class CitysCollectionView: UIView{
    
    private var data : [CitysItem] = []
    private var homeViewModel = HomeViewModel()
    weak var delegate: CitysViewDelegate?
    
    func updateData() {
        
        self.data = homeViewModel.fetchCitysItems()
        collectionView.reloadData()
        delegate?.didUpdateItemCount(data.count)
        print("Items count updated: \(data.count)")
    }
    
    private lazy var discoverArgentinaLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .left
        label.text = "Top ciudades para visitar"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let totalSpacing = layout.minimumInteritemSpacing * 1 // Espacio entre dos celdas
        let availableWidth = UIScreen.main.bounds.width - totalSpacing - 20
        let cellWidth = availableWidth / 2
        layout.itemSize = .init(width: cellWidth, height: 130)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CitysCell.self, forCellWithReuseIdentifier: "CitysCell")
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
}

//MARK: - Setup Methods and Constraints

extension CitysCollectionView{
    
    func setup() {
        addSubview(discoverArgentinaLabel)
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            discoverArgentinaLabel.topAnchor.constraint(equalTo: topAnchor),
            discoverArgentinaLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            discoverArgentinaLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: discoverArgentinaLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
    }
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

// MARK: - UICollectionViewDelegateFlowLayout
extension CitysCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let collectionViewSize = collectionView.frame.size.width - padding * 3 //3 porque son 2 celdas + padding inicial y final
        
        // Dividimos el ancho disponible entre 2 para obtener dos columnas
        return CGSize(width: collectionViewSize/2, height: 130)
    }
}

extension CitysCollectionView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCity = data[indexPath.item]
        delegate?.didSelectItem(selectedCity)
    }
}

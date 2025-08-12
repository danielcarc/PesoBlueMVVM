//
//  FilterCollectionView.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 20/01/2025.
//

import UIKit

protocol FilterCollectionViewDelegate: AnyObject  {
    func didSelectFilter(_ filter: DiscoverItem)
}

final class FilterCollectionView: UIView {

    weak var delegate: FilterCollectionViewDelegate?

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }

    /// This view is intended to be instantiated programmatically.
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }

    private var data: [DiscoverItem] = []
    private var placeType: PlaceType?
    private var selectedIndexPath: IndexPath?

    func update(with items: [DiscoverItem], selectedType: PlaceType) {
        data = items
        placeType = selectedType
        selectedIndexPath = nil
        filterCollectionView.reloadData()
    }
    
    private lazy var filterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.text = NSLocalizedString("filters_title", comment: "Filters header title")
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var filterCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 100, height: 110)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        //layout.estimatedItemSize = .init(width: 95, height: 110)
        
        let vw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vw.register(FilterCell.self, forCellWithReuseIdentifier: "FilterCell")
        vw.showsHorizontalScrollIndicator = false
        vw.backgroundColor = .clear
        vw.dataSource = self
        vw.delegate = self
        vw.translatesAutoresizingMaskIntoConstraints = false
        
        return vw
    }()
    
}

//MARK: - UICollectionViewDataSource Methods

extension FilterCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = data[indexPath.item]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as? FilterCell else {
            return UICollectionViewCell()
        }
        cell.set(image: item.image, title: item.name)
        
        if let type = PlaceType(rawValue: item.name), type == placeType {
            selectedIndexPath = indexPath
        }
        
        //configura el estado visual del borde
        if indexPath == selectedIndexPath {
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.black.cgColor
        } else {
            cell.layer.borderWidth = 0
            cell.layer.borderColor = UIColor.clear.cgColor
        }
        
        return cell
    }
    
}

extension FilterCollectionView: UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 110)
    }
}

extension FilterCollectionView : UICollectionViewDelegate {
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let previousIndexPath = selectedIndexPath
       
       //actualizamos el nuevo índice seleccionado
       selectedIndexPath = indexPath
       
       //llamamos al delegado
       let filter = data[indexPath.item]
       delegate?.didSelectFilter(filter)
       
       //recargamos solo las celdas afectadas (la anterior y la nueva seleccionada)
       var indexPathsToReload: [IndexPath] = [indexPath]
       if let previous = previousIndexPath {
           indexPathsToReload.append(previous)
       }
       
       collectionView.reloadItems(at: indexPathsToReload)
       
    }

}



//MARK: - Setup CollectionView Constraints

extension FilterCollectionView {
    
    func setup() {
        self.backgroundColor = .clear
        addSubview(filterLabel)
        addSubview(filterCollectionView)
        
        NSLayoutConstraint.activate([
                
            filterLabel.topAnchor.constraint(equalTo: topAnchor),
            filterLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            filterLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            filterLabel.heightAnchor.constraint(equalToConstant: 22),
            
            filterCollectionView.topAnchor.constraint(equalTo: filterLabel.bottomAnchor, constant: 10),
            filterCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            filterCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            filterCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        
        ])
    }
}


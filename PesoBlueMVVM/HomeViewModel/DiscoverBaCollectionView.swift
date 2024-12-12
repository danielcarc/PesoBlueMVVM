//
//  DiscoverBaCell.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 22/11/2024.
//

import UIKit

//class DiscoverBaCollectionView: UICollectionViewCell {
//    
//    private var dCell : DiscoverCell!
//    
//    var item : TestData? {
//        didSet{
//            
//            guard let image = item?.image,
//                  let title = item?.title
//                  else { return }
//            dCell?.set(image: image, title: title)
//            
//        }
//    }
//    
//     lazy var discoverCollectionView: UICollectionView = {
//        
//        let layout = UICollectionViewFlowLayout()
//        
//        layout.itemSize = .init(width: 200, height: 150)
//        layout.scrollDirection = .horizontal
//        layout.minimumLineSpacing = 10
//        
//        let vw = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        //registramos la celda
//        vw.register(DiscoverCell.self, forCellWithReuseIdentifier: "DiscoverCell")
//        
//        vw.showsHorizontalScrollIndicator = false
//        vw.backgroundColor = .white
//        //vw.dataSource = self
//        vw.translatesAutoresizingMaskIntoConstraints = false
//        return vw
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

class DiscoverBaCollectionView: UIView {
    private var data: [TestData] = []

    func setData(_ data: [TestData]) {
        self.data = data
        discoverCollectionView.reloadData()
    }
    
    func updateData(_ newData: [TestData]) {
        self.data = newData
        discoverCollectionView.reloadData()
    }

    lazy var discoverCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 160, height: 90)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10

        let vw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vw.register(DiscoverCell.self, forCellWithReuseIdentifier: "DiscoverCell")
        vw.showsHorizontalScrollIndicator = false
        vw.backgroundColor = .white
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.dataSource = self
        return vw
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}

extension DiscoverBaCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = data[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverCell", for: indexPath) as! DiscoverCell
        cell.set(image: item.image, title: item.title)
        return cell
    }
}

private extension DiscoverBaCollectionView {
    
    func setup() {
        addSubview(discoverCollectionView)
        
        NSLayoutConstraint.activate([
            discoverCollectionView.topAnchor.constraint(equalTo: topAnchor),
            discoverCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            discoverCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            discoverCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
    }
}

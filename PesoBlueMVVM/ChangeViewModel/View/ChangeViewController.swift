//
//  CurrencyViewController.swift
//  PesoBlueMVVM
//
//  Created by Daniel Francisco Carcacha on 29/09/23.
//

import UIKit

class ChangeViewController: UIViewController {
    
    
    private var viewModel = ChangeViewModel()
    
    private lazy var collectionView : UICollectionView = {
       
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: UIScreen.main.bounds.width, height: 171)
        let vw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //registramos la celda
        vw.register(ChangeCollectionViewCell.self, forCellWithReuseIdentifier: "ChangeCollectionViewCell")
        
        vw.dataSource = self
        vw.translatesAutoresizingMaskIntoConstraints = false
        return vw
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        viewModel.delegate = self
        viewModel.getChange()
        
    }
}

private extension ChangeViewController{
    func setup(){
        
        view.backgroundColor = .white
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        
        ])
    }
}

extension ChangeViewController: ChangeViewModelDelegate{
    func didFinish() {
        collectionView.reloadData()
    }
    
    func didFail(error: Error) {
        print(error)
    }
}

extension ChangeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.changes.count
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.changes[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChangeCollectionViewCell", for: indexPath) as! ChangeCollectionViewCell

        cell.item = item
        
        return cell
    }
}


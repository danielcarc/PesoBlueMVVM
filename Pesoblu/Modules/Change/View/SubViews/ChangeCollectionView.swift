//
//  CurrencyCollectionViewCell.swift
//  PesoBlueMVVM
//
//  Created by Daniel Francisco Carcacha on 04/10/23.
//
import Foundation
import UIKit

protocol ChangeCollectionViewDelegate: AnyObject{
    func didSelectCurrency(for currencyItem: CurrencyItem)
}

class ChangeCollectionView: UIView {
    
    private var collectionView: UICollectionView
    private var viewModel: ChangeViewModelProtocol
    weak var delegate: ChangeCollectionViewDelegate?
    
    var onHeightChange: ((CGFloat) -> Void)?
    
    init(viewModel: ChangeViewModelProtocol){
        self.viewModel = viewModel
        
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.itemSize = .init(width: width, height: 80)
        layout.minimumLineSpacing = 10
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension ChangeCollectionView{

}
private extension ChangeCollectionView{
    func setup(){
        
        collectionView.register(ChangeCell.self, forCellWithReuseIdentifier: "ChangeCell")
        collectionView.backgroundColor = UIColor(hex: "F0F8FF")
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        viewModel.delegate = self
        
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)

        ])
    }
}

extension ChangeCollectionView: ChangeViewModelDelegate{
    func didFinish() {
        collectionView.reloadData()
        DispatchQueue.main.async{
            let totalHeight = CGFloat(self.viewModel.currencies.count) * 90
            self.onHeightChange?(totalHeight)
        }
    }
    
    func didFail(error: any Error) {
        print(error.localizedDescription)
    }
}

//MARK: - UICollectionView DataSource

extension ChangeCollectionView: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.currencies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.currencies[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChangeCell", for: indexPath) as! ChangeCell
        
        cell.set(currencyTitle: item.currencyTitle ?? "",
                 currencyLabel: item.currencyLabel ?? "",
                 valueBuy: item.rate ?? "")
        
        return cell
    }
}

extension ChangeCollectionView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currencyItem = viewModel.currencies[indexPath.item]
        delegate?.didSelectCurrency(for: currencyItem)
    }
}


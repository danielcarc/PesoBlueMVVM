//
//  CurrencyCollectionViewCell.swift
//  PesoBlueMVVM
//
//  Created by Daniel Francisco Carcacha on 04/10/23.
//
import Foundation
import UIKit

class ChangeCollectionViewCell: UICollectionViewCell {
    
    private var view : ChangeView?
    
    var item : CurrencyItem? {
        didSet{
            if let item = item {
                updateView(with: item)
            }
        }
    }
    func updateView(with currencies: CurrencyItem){

        guard let nameLabel = currencies.currencyTitle,
              let valueSell = currencies.currencyLabel,
              let valueBuy = currencies.rate else { return }
        view?.set(currencyTitle: nameLabel, currencyLabel: valueSell, valueBuy: Double(valueBuy) ?? 0.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension ChangeCollectionViewCell{

}
private extension ChangeCollectionViewCell{
    func setup(){
        contentView.backgroundColor = .clear
        guard view == nil else {return}
        
        view = ChangeView()
        
        self.contentView.addSubview(view!)
        
        NSLayoutConstraint.activate([
            view!.topAnchor.constraint(equalTo: contentView.topAnchor),
            view!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            view!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)

        ])
    }
}

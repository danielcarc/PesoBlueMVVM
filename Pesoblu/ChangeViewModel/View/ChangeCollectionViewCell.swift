//
//  CurrencyCollectionViewCell.swift
//  PesoBlueMVVM
//
//  Created by Daniel Francisco Carcacha on 04/10/23.
//

import UIKit

class ChangeCollectionViewCell: UICollectionViewCell {
    
    private var view : ChangeView?
    
    var item : ChangesResponse? {
        didSet{
            
            if item?.oficial != nil {
                guard let nameLabel = item?.oficial?.dolarLabel,
                      let valueSell = item?.oficial?.value_sell,
                      let valueBuy = item?.oficial?.value_buy else { return }
                view?.set(nameLabel: nameLabel, valueSell: valueSell, valueBuy: valueBuy)
            }else if item?.blue != nil{
                guard let nameLabel = item?.blue?.dolarLabel,
                      let valueSell = item?.blue?.value_sell,
                      let valueBuy = item?.blue?.value_buy else { return }
                view?.set(nameLabel: nameLabel, valueSell: valueSell, valueBuy: valueBuy)
            }else{
                guard let nameLabel = item?.blue_euro?.dolarLabel,
                      let valueSell = item?.blue_euro?.value_sell,
                      let valueBuy = item?.blue_euro?.value_buy else { return }
                view?.set(nameLabel: nameLabel, valueSell: valueSell, valueBuy: valueBuy)
            }
        }
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

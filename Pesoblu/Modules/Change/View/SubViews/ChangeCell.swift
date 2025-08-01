//
//  ChangeCell.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 25/07/2025.
//
import UIKit

class ChangeCell: UICollectionViewCell{
    
    private lazy var changeView = ChangeView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(currencyTitle: String, currencyLabel: String, valueBuy: String){
        changeView.set(currencyTitle: currencyTitle,
                       currencyLabel: currencyLabel,
                       valueBuy: valueBuy)
    }
    
    private func setup(){
        contentView.backgroundColor = .clear
        changeView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(changeView)
        
        NSLayoutConstraint.activate([
            changeView.topAnchor.constraint(equalTo: contentView.topAnchor),
            changeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            changeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            changeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
    }
}

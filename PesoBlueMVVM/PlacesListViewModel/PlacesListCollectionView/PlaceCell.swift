//
//  PlaceCell.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 20/01/2025.
//

import UIKit

class PlaceCell: UICollectionViewCell {
    
    private lazy var placeImage: UIImageView = {
        var image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var placeName: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //mostrar precio, tipo de lugar, y ver si se puede distancia
    private lazy var priceLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var typeLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var distanceLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var placeStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [placeName, priceLabel, typeLabel, distanceLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    func set(image: String, title: String, price: String, distance: String){
        placeImage.image = UIImage(named: image)
        placeName.text = title
        priceLabel.text = price
        //falta type
        distanceLabel.text = distance
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension PlaceCell {
 
    func setupViews(){
        addsubViews()
        setupConstraints()
        
    }
    
    func addsubViews(){
        self.backgroundColor = .white
        self.layer.cornerRadius = 4
        self.addSubview(placeImage)
        self.addSubview(placeStackView)
        
        
    }
    
    func setupConstraints(){
        
        NSLayoutConstraint.activate([
            
            placeImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            placeImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            placeImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            placeImage.heightAnchor.constraint(equalToConstant: 100),
            
            placeStackView.topAnchor.constraint(equalTo: placeImage.bottomAnchor, constant: 8),
            placeStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            placeStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            
        ])
    }
    
}
    

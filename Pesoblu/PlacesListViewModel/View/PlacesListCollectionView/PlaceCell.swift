//
//  PlaceCell.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 20/01/2025.
//

import UIKit

protocol PlaceCellDelegate: AnyObject {
    func placeCellDidFailToLoadImage(_ cell: PlaceCell, error: Error)
}

class PlaceCell: UICollectionViewCell {
    
    weak var delegate: PlaceCellDelegate?
    //MARK: - Properties

    private lazy var placeImage: UIImageView = {
        var image = UIImageView()
        image.contentMode = .scaleToFill
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
    
    //MARK: - Set Methods
    func set(image: UIImage?, title: String, price: String, distance: String, type: String){
        placeImage.image = image
        placeName.text = title
        priceLabel.text = price
        typeLabel.text = type
        distanceLabel.text = distance
    }
    
    func updateDistance(_ distance: String) {
        distanceLabel.text = distance
    }
    
    func updateImage(url: String) {
        guard let imageUrl = URL(string: url) else {
            placeImage.image = UIImage(systemName: "photo")
            return
        }

        placeImage.kf.setImage(
            with: imageUrl,
            placeholder: UIImage(systemName: "photo"),
            options: [.transition(.fade(0.3)), .cacheOriginalImage]
        ) { result in
            switch result {
            case .success:
                break  // Imagen cargada correctamente
            case .failure(let error):
                self.delegate?.placeCellDidFailToLoadImage(self, error: error)  // Notificar el error
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setup SubViews and Constraints Methods

extension PlaceCell {
 
    func setupViews(){
        addsubViews()
        setupConstraints()
    }
    
    func addsubViews(){
        self.backgroundColor = .white
        self.layer.cornerRadius = 4
        contentView.addSubview(placeImage)
        contentView.addSubview(placeName)
        contentView.addSubview(typeLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(distanceLabel)
    }
    
    func setupConstraints(){
        
        NSLayoutConstraint.activate([
            placeImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            placeImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            placeImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            placeImage.heightAnchor.constraint(equalToConstant: 190),
            //placeImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20),
            
            placeName.topAnchor.constraint(equalTo: placeImage.bottomAnchor, constant: 8),
            placeName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            placeName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            typeLabel.topAnchor.constraint(equalTo: placeName.bottomAnchor, constant: 4),
            typeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            typeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            priceLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            distanceLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            distanceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            distanceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            distanceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
}
    

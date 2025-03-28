//
//  FilterCell.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 20/01/2025.
//
import UIKit

class FilterCell: UICollectionViewCell{
    
    // MARK: - Properties
    private lazy var imageView : UIImageView = {
        var view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var titleLabel : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(named: "primaryTextColor") ?? .black
        label.textAlignment = .center
        return label
    }()
    
    func set(image: String, title: String){
        imageView.image = UIImage(named: image)
        titleLabel.text = title
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FilterCell{
    
    func setupViews(){
        addSubViews()
        setupConstraints()
    }
    
    func addSubViews(){
        self.backgroundColor = .clear
        self.backgroundColor = .white
        self.layer.cornerRadius = 8.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // ImageView - quitar el constraint de width fijo ya que ya está restringido por leading/trailing
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            imageView.heightAnchor.constraint(equalToConstant: 77),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}

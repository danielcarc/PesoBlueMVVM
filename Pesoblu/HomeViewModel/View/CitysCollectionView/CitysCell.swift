//
//  CitysCell.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 12/01/2025.
//

import UIKit

class CitysCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    private lazy var imageView : UIImageView = {
        var view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var titleLabel : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
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
private extension CitysCell {
    
    private func setupViews() {
        
        addsubviews()
        setupConstraints()
        
    }
    
    func addsubviews() {
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        //self.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        //imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints(){
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            imageView.heightAnchor.constraint(equalToConstant: 100),
            //imageView.widthAnchor.constraint(equalToConstant: 166),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
    }
}

//
//  DiscoverCell.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 22/11/2024.
//


import UIKit

final class DiscoverCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    private lazy var imageView : UIImageView = {
        var view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 6
        
        return view
    }()
    
    private lazy var titleLabel : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
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
        fatalError(NSLocalizedString("init_coder_not_implemented", comment: ""))
    }
}
private extension DiscoverCell {
    
    private func setupViews() {
        
        addsubviews()
        setupConstraints()
        
    }
    
    func addsubviews() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 6

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 90),
            imageView.widthAnchor.constraint(equalToConstant: 160),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

    


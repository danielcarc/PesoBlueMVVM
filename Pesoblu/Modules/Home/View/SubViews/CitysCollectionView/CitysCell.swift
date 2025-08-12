//
//  CitysCell.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 12/01/2025.
//

import UIKit

final class CitysCell: UICollectionViewCell  {
    
    // MARK: - Public Properties
    private lazy var imageView : UIImageView = {
        var view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = LayoutConstants.containerCornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var titleLabel : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: LayoutConstants.cityCellTitleFontSize, weight: .bold)
        label.numberOfLines = 0
        label.textColor = UIColor(named: "primaryTextColor") ?? .black
        label.textAlignment = .center
        return label
    }()
    
    func set(image: String, title: String) {
        imageView.image = UIImage(named: image)
        titleLabel.text = title
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    /// This view is intended to be instantiated programmatically.
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }
}
private extension CitysCell  {
    
    private func setupViews() {
        addsubviews()
        setupConstraints()
    }
    
    func addsubviews() {
        self.backgroundColor = .white
        self.layer.cornerRadius = LayoutConstants.cityCellCornerRadius
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: LayoutConstants.cityImageHeight),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: LayoutConstants.extraSmallPadding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstants.edgePadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LayoutConstants.edgePadding),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -LayoutConstants.extraSmallPadding)
        ])
    }
}

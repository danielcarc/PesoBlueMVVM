//
//  PlaceView.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 30/01/2025.
//

import Foundation
import UIKit
import MapKit

class PlaceView: UIView{
    
    private var viewModel = PlaceViewModel()
    
    private lazy var stackView: UIStackView = {
        var sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 12
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        return sv
    }()
    
    private lazy var placeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var categoriesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var contactStackView : UIStackView = {
        var sv = UIStackView(arrangedSubviews: [phoneIconButton, instagramIconButton])
        sv.axis = .horizontal
        sv.alignment = .leading
        sv.distribution = .fillProportionally
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 16
        
        return sv
    }()
    
    private lazy var phoneIconButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "phone.fill"), for: .normal)
        button.tintColor = .black
        button.accessibilityLabel = "Llamar a Siamo nel Forno"
        button.addTarget(self, action: #selector(callPhone(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var instagramIconButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        button.tintColor = .black
        button.accessibilityLabel = "Abrir Instagram de Siamo nel Forno"
        button.addTarget(self, action: #selector(openInstagram(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.layer.cornerRadius = 12
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        return mapView
    }()
    
    func setData(item: PlaceItem){
        let place = item
        nameLabel.text = place.name
        categoriesLabel.text = place.categories?.joined(separator: " · ")
        addressLabel.text = "📍 \(place.address), \(place.area)"
        descriptionLabel.text = place.placeDescription
        phoneIconButton.accessibilityLabel = item.phone
        instagramIconButton.accessibilityLabel = item.instagram
        
        Task {
            do {
                let image = try await viewModel.downloadImage(from: item.imageUrl)
                await MainActor.run {
                    placeImageView.image = image
                }
            }
            catch {
                print("Error descargando imagen: \(error)")
            }
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: place.lat ?? 0.0, longitude: place.long ?? 0.0)
        annotation.title = place.name
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: false)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
}

extension PlaceView{
    
    func setup(){
        addViews()
        addConstraints()
    }
    
    func addViews(){
        self.addSubview(stackView)
        stackView.addArrangedSubview(placeImageView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(categoriesLabel)
        stackView.addArrangedSubview(addressLabel)
        stackView.addArrangedSubview(contactStackView)
        
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(mapView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(expandImage))
        placeImageView.addGestureRecognizer(tapGesture)
        
    }
    
    func addConstraints(){
        
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            placeImageView.heightAnchor.constraint(equalToConstant: 200),
            mapView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
    }
}

extension PlaceView{
    
    @objc private func expandImage() {
        // Animación para expandir la imagen
    }
    
    @objc private func callPhone(sender: UIButton) {
        guard let phoneNumber = sender.accessibilityLabel,
              !phoneNumber.isEmpty,
              let url = URL(string: "tel://\(phoneNumber)"),
              UIApplication.shared.canOpenURL(url) else {
            print("No se puede abrir la app de llamadas o el número es inválido.")
            return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
//    @objc private func callPhone(sender: UIButton) {
//        guard let phoneNumber = sender.accessibilityLabel,
//              !phoneNumber.isEmpty,
//              let url = URL(string: "tel://\(phoneNumber)") else {
//            print("Número inválido.")
//            return
//        }
//
//        print("Intentando llamar a: \(url.absoluteString)")
//
//        if UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        } else {
//            print("No se puede abrir la app de llamadas.")
//        }
//    }
    
    @objc private func openInstagram(sender: UIButton) {
        if let instagramURL = sender.accessibilityLabel, let url = URL(string: instagramURL) {
            UIApplication.shared.open(url)
        }
    }
}

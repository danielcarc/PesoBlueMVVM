//
//  PlaceView.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 30/01/2025.
//

import Foundation
import UIKit
import MapKit
import Kingfisher
import CoreData

protocol PlaceViewDelegate: AnyObject{
    func didFailToLoadImage(_ view: PlaceView, error: Error)
    func didFailToCall()
    func didFailToOpenInstagram(title: String, message: String)
}

final class PlaceView: UIView{
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: PlaceViewDelegate?
    var place: PlaceItem?
    
    private lazy var stackView: UIStackView = {
        var sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 24
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var placeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
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
        button.setImage(UIImage(named: "phone-outcome"), for: .normal)
        button.tintColor = .black
        button.accessibilityLabel = "Llamar a Siamo nel Forno"
        button.addTarget(self, action: #selector(callPhone(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var instagramIconButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "instagram"), for: .normal)
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
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openInMaps)))
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    func setData(item: PlaceItem){
        place = item
        nameLabel.text = item.name
        categoriesLabel.text = item.categories?.joined(separator: " · ")
        addressLabel.text = "📍 \(item.address), \(item.area)"
        descriptionLabel.text = item.placeDescription
        phoneIconButton.accessibilityLabel = item.phone
        instagramIconButton.accessibilityLabel = item.instagram

        updateImage(url: item.imageUrl)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: item.lat ?? 0.0, longitude: item.long ?? 0.0)
        annotation.title = item.name
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: false)
    }
    
    func updateImage(url: String) {
        guard let imageUrl = URL(string: url) else {
            placeImageView.image = UIImage(systemName: "photo")
            return
        }
        placeImageView.kf.setImage(
            with: imageUrl,
            placeholder: UIImage(systemName: "photo"),
            options: [.transition(.fade(0.3)), .cacheOriginalImage]
        ) { result in
            switch result {
            case .success:
                break  // Imagen cargada correctamente
            case .failure(let error):
                self.delegate?.didFailToLoadImage(self, error: error)  // Notificar el error
            }
        }
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

//MARK: - TapGesture Methods

extension PlaceView{
    
    @objc private func expandImage() {
        guard let superview = self.superview else { return }
        
        //crear fondo oscuro en el que se ve el background
        let backgroundView = UIView(frame: superview.bounds)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        backgroundView.tag = 100 // Tag para identificarlo
        superview.addSubview(backgroundView)
        
        //crear copia de la imagen para expandir
        let expandedImageView = UIImageView(image: placeImageView.image)
        expandedImageView.contentMode = .scaleAspectFit
        expandedImageView.isUserInteractionEnabled = true
        expandedImageView.layer.cornerRadius = 12 // Mantener el estilo
        expandedImageView.clipsToBounds = true
        
        //posicionar la imagen en su ubicación original relativa al superview
        expandedImageView.frame = placeImageView.convert(placeImageView.bounds, to: superview)
        superview.addSubview(expandedImageView)
        
        //agregar gesto para cerrar
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissExpandedImage))
        expandedImageView.addGestureRecognizer(tapGesture)
        
        //animamos la expansión
        UIView.animate(withDuration: 0.3) {
            expandedImageView.frame = superview.bounds
            expandedImageView.center = superview.center
        }
    }
    
    @objc private func dismissExpandedImage(_ sender: UITapGestureRecognizer) {
        guard let expandedImageView = sender.view as? UIImageView,
              let superview = self.superview,
              let backgroundView = superview.viewWithTag(100) else { return }
        
        //anima contracción a la posición original
        UIView.animate(withDuration: 0.3, animations: {
            expandedImageView.frame = self.placeImageView.convert(self.placeImageView.bounds, to: superview)
            backgroundView.alpha = 0
        }) { _ in
            expandedImageView.removeFromSuperview()
            backgroundView.removeFromSuperview()
        }
    }
    
    @objc private func callPhone(sender: UIButton) {
        guard let phoneNumber = sender.accessibilityLabel,
              !phoneNumber.isEmpty,
              //esto valida que solo contiene numeros validos de un telefono
              phoneNumber.rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789+- ").inverted) == nil,
              let url = URL(string: "telprompt://\(phoneNumber)"),
              UIApplication.shared.canOpenURL(url) else {
            delegate?.didFailToCall()
            print("No se puede abrir la app de llamadas o el número es inválido.")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc private func openInstagram(sender: UIButton) {
        //obtengo la URL web del accessibilityLabel
        guard let instagramWebURL = sender.accessibilityLabel?.trimmingCharacters(in: .whitespacesAndNewlines),
              !instagramWebURL.isEmpty,
              let urlComponents = URLComponents(string: instagramWebURL),
              urlComponents.scheme == "https",
              urlComponents.host == "www.instagram.com",
              let username = urlComponents.path.split(separator: "/").first else {
            delegate?.didFailToOpenInstagram(title: "Error al abrir Instagram", message: "URL de Instagram inválida.")
            return
        }
        
        //construir la URL para la app de Instagram
        let appURLString = "instagram://user?username=\(username)"
        guard let appURL = URL(string: appURLString),
              UIApplication.shared.canOpenURL(appURL) else {
            //fallback al navegador con la URL web original
            guard let webURL = URL(string: instagramWebURL),
                  UIApplication.shared.canOpenURL(webURL) else {
                delegate?.didFailToOpenInstagram(title: "Error al abrir Instagram", message: "No se puede abrir Instagram. Verifica la URL o instala la app.")
                return
            }
            UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
            return
        }
        
        //abrir la app de instagram directamente
        UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
    }
    
    @objc private func openInMaps() {
        if let place = self.place {
            let latitude = place.lat ?? 0.0
            let longitude = place.long ?? 0.0
            
            let encodedPlaceName = place.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let urlString = "maps://?q=\(encodedPlaceName)&ll=\(latitude),\(longitude)"
            print("URL generada: \(urlString)")
            
            if let url = URL(string: urlString) {
                print("URL válida: \(url)")
                let canOpen = UIApplication.shared.canOpenURL(url)
                print("¿Puede abrir Apple Maps?: \(canOpen)")
                if canOpen {
                    UIApplication.shared.open(url)
                } else {
                    let googleMapsURL = "https://www.google.com/maps/search/?api=1&query=\(latitude),\(longitude)"
                    print("Intentando Google Maps: \(googleMapsURL)")
                    if let url = URL(string: googleMapsURL) {
                        UIApplication.shared.open(url)
                    }
                }
            } else {
                print("URL inválida para Apple Maps")
            }
        } else {
            print("No hay lugar definido")
            return
        }
    }

}

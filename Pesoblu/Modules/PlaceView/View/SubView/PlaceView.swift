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

protocol PlaceViewDelegate: AnyObject {
    func didFailToLoadImage(_ view: PlaceView, error: Error)
    func didFailToCall()
    func didFailToOpenInstagram(title: String, message: String)
    func didFailToOpenMaps()
}

final class PlaceView: UIView {
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    /// This view is intended to be instantiated programmatically.
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }
    
    weak var delegate: PlaceViewDelegate?
    private var place: PlaceItem?
    private var phoneNumber: String?
    
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
        button.accessibilityLabel = NSLocalizedString("call_place", comment: "")
        button.addTarget(self, action: #selector(callPhone(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var instagramIconButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "instagram"), for: .normal)
        button.tintColor = .black
        button.accessibilityLabel = NSLocalizedString("open_instagram_place", comment: "")
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
    
    func setData(item: PlaceItem) {
        place = item
        nameLabel.text = item.name
        categoriesLabel.text = item.categories?.joined(separator: " · ")
        addressLabel.text = "📍 \(item.address), \(item.area)"
        descriptionLabel.text = item.placeDescription
        phoneNumber = item.phone
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

    private func setup() {
        addViews()
        addConstraints()
    }

    private func addViews() {
        self.backgroundColor = .clear
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

    private func addConstraints() {
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


    // MARK: - TapGesture Methods

extension PlaceView {
    
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
    
    @objc private func callPhone(sender _: UIButton) {
        guard let number = phoneNumber,
              !number.isEmpty,
              //esto valida que solo contiene numeros validos de un telefono
              number.rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789+- ").inverted) == nil,
              let url = URL(string: "telprompt://\(number)"),
              UIApplication.shared.canOpenURL(url) else {
            delegate?.didFailToCall()
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc private func openInstagram(sender: UIButton) {
        guard let instagramWebURL = sender.accessibilityLabel?.trimmingCharacters(in: .whitespacesAndNewlines),
              !instagramWebURL.isEmpty,
              let url = URL(string: instagramWebURL),
              url.host?.contains("instagram.com") == true else {
            delegate?.didFailToOpenInstagram(title: NSLocalizedString("error_open_instagram", comment: ""), message: NSLocalizedString("invalid_instagram_url", comment: ""))
            return
        }

        // Obtener el nombre de usuario del path
        let pathComponents = url.pathComponents
        guard pathComponents.count > 1 else {
            delegate?.didFailToOpenInstagram(title: NSLocalizedString("error_title", comment: ""), message: NSLocalizedString("username_not_found", comment: ""))
            return
        }

        let username = pathComponents[1] // /username → ["", "username"]

        // Intentar abrir en Instagram app
        let appURLString = "instagram://user?username=\(username)"
        if let appURL = URL(string: appURLString),
           UIApplication.shared.canOpenURL(appURL) {
            DispatchQueue.main.async {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            }
        } else {
            // Fallback al navegador
            if UIApplication.shared.canOpenURL(url) {
                DispatchQueue.main.async {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            } else {
                delegate?.didFailToOpenInstagram(title: NSLocalizedString("error_title", comment: ""), message: NSLocalizedString("cannot_open_instagram_or_safari", comment: ""))
            }
        }
    }

    @objc private func openInMaps() {
        guard let place = self.place else {
            delegate?.didFailToOpenMaps()
            return
        }

        let latitude = place.lat ?? 0.0
        let longitude = place.long ?? 0.0
        let encodedPlaceName = place.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "maps://?q=\(encodedPlaceName)&ll=\(latitude),\(longitude)"

        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            let fallbackURLString = "https://www.google.com/maps/search/?api=1&query=\(latitude),\(longitude)"
            if let fallbackURL = URL(string: fallbackURLString) {
                UIApplication.shared.open(fallbackURL)
            } else {
                delegate?.didFailToOpenMaps()
            }
        }
    }


}

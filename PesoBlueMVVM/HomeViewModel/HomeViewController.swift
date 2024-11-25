//
//  HomeViewController.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 12/11/2024.
//

import UIKit


//hacer el conversion rapida
//ver de agregar mas ademas de brasil, uruguay y chile
//debajo el collection view de descubre buenos aires
//luego el de experiencias tipo tango, cafeteria, gastronomia, cocteleria y mas
//y luego top ciudades para visitar empezando con Bariloche, mendoza, ushuaia, cordoba

import UIKit

class HomeViewController: UIViewController {
    
    var quickConversorView : QuickConversorView!
    var discoverBaCView : DiscoverBaCollectionView!
    
    private let data : [TestData] = [
        TestData(image: "Obelisco", title: "Obelisco"),
        TestData(image: "googlelogo", title: "Caminito"),
        TestData(image: "CircuitoChico", title: "Recoleta"),
        TestData(image: "AppIcon", title: "Puente de la Mujer")
    ]
    
    
    override func loadView() {
        let mainView = UIView()
        mainView.backgroundColor = .white

        quickConversorView = QuickConversorView()
        discoverBaCView = DiscoverBaCollectionView()

        mainView.addSubview(quickConversorView)
        mainView.addSubview(discoverBaCView)

        // Configura las constraints de ambas vistas
        quickConversorView.translatesAutoresizingMaskIntoConstraints = false
        discoverBaCView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            quickConversorView.topAnchor.constraint(equalTo: mainView.safeAreaLayoutGuide.topAnchor),
            quickConversorView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            quickConversorView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            quickConversorView.heightAnchor.constraint(equalToConstant: 185),

            discoverBaCView.topAnchor.constraint(equalTo: quickConversorView.bottomAnchor, constant: 16),
            discoverBaCView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            discoverBaCView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16),
            discoverBaCView.heightAnchor.constraint(equalToConstant: 250)
        ])

        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
        
    }
    
}

extension HomeViewController {
    func setup() {
        discoverBaCView.updateData(data) // Pasas los datos al DiscoverBaCollectionView
    }
}

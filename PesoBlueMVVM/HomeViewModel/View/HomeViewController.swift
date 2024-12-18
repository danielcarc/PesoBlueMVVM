//
//  HomeViewController.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 12/11/2024.
//



//agregar el descubre buenos aires, creando otra vista, sacar los constraints de los container de ars y usd laterales
//hacer mas ancha la fotografia y menos alta, definir esto en quickconversionview para que ademas se vea el titulo

//hacer el conversion rapida
//ver de agregar mas ademas de brasil, uruguay y chile
//debajo el collection view de descubre buenos aires
//luego el de experiencias tipo tango, cafeteria, gastronomia, cocteleria y mas
//y luego top ciudades para visitar empezando con Bariloche, mendoza, ushuaia, cordoba

import UIKit

class HomeViewController: UIViewController {
    
    var quickConversorView = QuickConversorView()
    var discoverBaCView = DiscoverBaCollectionView()
    
    private var mainStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
        
  
    private let data : [TestData] = [
        TestData(image: "Obelisco", title: "Obelisco"),
        TestData(image: "googlelogo", title: "Caminito"),
        TestData(image: "CircuitoChico", title: "Recoleta"),
        TestData(image: "AppIcon", title: "Puente de la Mujer")
    ]
    
    
    override func loadView() {
        
        self.view = UIView()
        self.view.backgroundColor = .white
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupUI()
        setup()
        
    }
    
}

extension HomeViewController {
    func setup() {
        
        discoverBaCView.updateData(data)
        
    }
}

extension HomeViewController{
    
    func setupUI(){
        
        addSubViews()
        addConstraints()
        
    }
    
    func addSubViews(){
        
        view.addSubview(mainStackView)
        
        quickConversorView.translatesAutoresizingMaskIntoConstraints = false
        discoverBaCView.translatesAutoresizingMaskIntoConstraints = false
        
        mainStackView.addArrangedSubview(quickConversorView)
        mainStackView.addArrangedSubview(discoverBaCView)
        
    }
    
    func addConstraints(){
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            
            quickConversorView.heightAnchor.constraint(equalToConstant: 151),
            discoverBaCView.heightAnchor.constraint(equalToConstant: 158)
        ])
    }
}



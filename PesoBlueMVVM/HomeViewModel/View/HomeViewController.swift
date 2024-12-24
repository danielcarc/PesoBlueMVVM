//
//  HomeViewController.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 12/11/2024.
//

//debajo el collection view de descubre buenos aires
//luego el de experiencias tipo tango, cafeteria, gastronomia, cocteleria y mas
// hacer el segue a una vista nueva usando el elemento seleccionado ejemplo cafe
//y luego top ciudades para visitar empezando con Bariloche, mendoza, ushuaia, cordoba

import UIKit

class HomeViewController: UIViewController {
    
    var quickConversorView = QuickConversorView()
    var discoverBaCView = DiscoverBaCollectionView()
    
    var homeViewModel: HomeViewModel = HomeViewModel()
    
    private var mainStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
        
  
    
    override func loadView() {
        
        self.view = UIView()
        self.view.backgroundColor = .white
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
}

//MARK: - Setting the View

extension HomeViewController {
    
    func setup() {
        setupUI()
        setupQuickConversor()
        discoverBaCView.updateData()
        discoverBaCView.delegate = self
    }
    
}

//MARK: - Setup SubViews and Constraints

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

//MARK: - SetUp QuickConversor

extension HomeViewController{
    
    func setupQuickConversor(){
        
        Task {
            if let dolar = await homeViewModel.getDolarBlue()?.venta {
                quickConversorView.setDolar(dolar: dolar)
            } else {
                print("No se pudo obtener el valor del dólar")
            }
            //necesito primero el countrycode, despues un switch dependiendo del pais que moneda se convierte y desde ahi a obtener el valor
            let countryCode = homeViewModel.getUserCountry()
            let value = await homeViewModel.getValueForCountry(countryCode: countryCode ?? "AR")
            quickConversorView.setValue(value: value)
            
        }
    }
}


//MARK: - CollectionViewDelegate Methods

extension HomeViewController: CollectionViewSelectionDelegate{
    
    func didSelectItem(_ item: DiscoverItem) {
        let item = item
        print(item.name)
    }
    
}




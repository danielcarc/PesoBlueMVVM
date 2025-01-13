//
//  HomeViewController.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 12/11/2024.
//

//y luego top ciudades para visitar empezando con Bariloche, mendoza, ushuaia, cordoba
//hacerlas 2 por columnas por linea y arriba de todo la vista agregarle el clima del dia

import UIKit

class HomeViewController: UIViewController {
    
    var quickConversorView = QuickConversorView()
    var discoverBaCView = DiscoverBaCollectionView()
    var citysCView = CitysCollectionView()
    
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
        citysCView.updateData()
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
        citysCView.translatesAutoresizingMaskIntoConstraints = false
        
        mainStackView.addArrangedSubview(quickConversorView)
        mainStackView.addArrangedSubview(discoverBaCView)
        mainStackView.addArrangedSubview(citysCView)
        
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


//MARK: - DiscoverCollectionViewDelegate Methods

extension HomeViewController: CollectionViewSelectionDelegate{
    
    func didSelectItem(_ item: DiscoverItem) {
        do {
            let selectedPlaces = try homeViewModel.filteredItem(item: item)
            
            if selectedPlaces.isEmpty {
                showAlert(message: "No hay lugares disponibles para el ítem seleccionado.")
            } else {
                let placesListVC = PlacesListViewController()
                placesListVC.selectedPlaces = selectedPlaces
                
                if let navigationController = navigationController {
                    navigationController.pushViewController(placesListVC, animated: true)
                } else {
                    print("Error: HomeViewController no está dentro de un UINavigationController.")
                    present(placesListVC, animated: true)
                }
            }
        } catch PlaceError.noPlacesAvailable {
            showAlert(message: "No se encontraron lugares disponibles.")
        } catch PlaceError.fileNotFound {
            showAlert(message: "No se encontró el archivo de datos.")
        } catch PlaceError.failedToParseData {
            showAlert(message: "Hubo un problema al procesar los datos.")
        } catch {
            showAlert(message: "Ha ocurrido un error inesperado: \(error.localizedDescription).")
        }
    }


    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }

    
}




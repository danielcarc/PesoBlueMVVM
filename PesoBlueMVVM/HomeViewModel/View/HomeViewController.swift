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
    
    var collectionViewHeightConstraint: NSLayoutConstraint!
    
    var homeViewModel = HomeViewModel()
    
    private var mainScrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.bounces = true
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.backgroundColor = .lightGray
        return view
    }()
    
    private var stackView: UIStackView = {
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
        citysCView.delegate = self
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
        
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        quickConversorView.translatesAutoresizingMaskIntoConstraints = false
        discoverBaCView.translatesAutoresizingMaskIntoConstraints = false
        citysCView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(quickConversorView)
        stackView.addArrangedSubview(discoverBaCView)
        stackView.addArrangedSubview(citysCView)
        
    }
    
    func addConstraints(){
        
        collectionViewHeightConstraint = citysCView.heightAnchor.constraint(equalToConstant: 200) // Altura inicial
               
        NSLayoutConstraint.activate([
            
            mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            //contentView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            
            quickConversorView.heightAnchor.constraint(equalToConstant: 151),
            discoverBaCView.heightAnchor.constraint(equalToConstant: 158),
            collectionViewHeightConstraint
            //citysCView.heightAnchor.constraint(equalToConstant: 600)
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
            let selectedCity = "CABA"
            let selectedPlaces = try homeViewModel.fetchPlaces(city: selectedCity)
            let placeType = item.name
            
            if selectedPlaces.isEmpty {
                showAlert(message: "No hay lugares disponibles para el ítem seleccionado.")
            } else {
                let placesListVC = PlacesListViewController()
                placesListVC.selectedPlaces = selectedPlaces
                placesListVC.selectedCity = selectedCity
                placesListVC.placeType = placeType
                
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



//MARK: - CitysViewDelegate Methods
extension HomeViewController: CitysViewDelegate{
    func didSelectItem(_ city: CitysItem) {
        let selectedCity = String(city.name)
        print(selectedCity)
        
        do{
            let selectedPlaces = try homeViewModel.fetchPlaces(city: selectedCity)
            if selectedPlaces.isEmpty {
                showAlert(message: "No hay lugares disponibles para el ítem seleccionado.")
            } else {
                let placesListVC = PlacesListViewController()
                placesListVC.selectedPlaces = selectedPlaces
                placesListVC.selectedCity = selectedCity
                //placesListVC.placeType = placeType
                
                if let navigationController = navigationController {
                    navigationController.pushViewController(placesListVC, animated: true)
                } else {
                    print("Error: HomeViewController no está dentro de un UINavigationController.")
                    present(placesListVC, animated: true)
                }
            }
        }
        catch PlaceError.noPlacesAvailable {
            showAlert(message: "No se encontraron lugares disponibles.")
        } catch PlaceError.fileNotFound {
            showAlert(message: "No se encontró el archivo de datos.")
        } catch PlaceError.failedToParseData {
            showAlert(message: "Hubo un problema al procesar los datos.")
        } catch {
            showAlert(message: "Ha ocurrido un error inesperado: \(error.localizedDescription).")
        }
    }
    
    func didUpdateItemCount(_ count: Int) {
        let labelSpace = 38.0
        let rows = ceil(Double(count) / 2.0) // Asumiendo 2 columnas
        let itemHeight = 130.0
        let spacing = 10.0
        
        let totalHeight = rows * itemHeight + (rows - 1) * spacing + labelSpace
        collectionViewHeightConstraint.constant = totalHeight
        view.layoutIfNeeded()
        print(count)
    }
    
    
    
}





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
    
    var quickConversorView : QuickConversorView
    var discoverBaCView : DiscoverBaCollectionView
    var citysCView : CitysCollectionView
    var alertMessage: String?
    
    var collectionViewHeightConstraint: NSLayoutConstraint!
    
    private let homeViewModel: HomeViewModelProtocol
    
    init(homeViewModel: HomeViewModelProtocol,
         quickConversorView: QuickConversorView = QuickConversorView(),
         discoverBaCView: DiscoverBaCollectionView? = nil,
         citysCView: CitysCollectionView? = nil) {
        
        self.homeViewModel = homeViewModel
        self.quickConversorView = quickConversorView
        self.discoverBaCView = discoverBaCView ?? DiscoverBaCollectionView(homeViewModel: homeViewModel)
        self.citysCView = citysCView ?? CitysCollectionView(homeViewModel: homeViewModel)
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
    
    private var mainScrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.bounces = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = true
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //se asegura de que el tamaño de contentView se ajuste al tamaño de stackView
        let stackViewHeight = stackView.frame.height
        contentView.frame.size.height = stackViewHeight
        
        //actualiza el tamaño de contenido del scrollView
        mainScrollView.contentSize = CGSize(width: contentView.frame.width, height: contentView.frame.height)
        
        //añadir la restricción de ancho solo después de que el frame esté calculado
        contentView.widthAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.widthAnchor).isActive = true
    }
    
}

//MARK: - Setting the View

extension HomeViewController {
    
    func setup() {
        setupUI()
        setupQuickConversor()
        citysCView.delegate = self
        //citysCView.citysCollectionView.dataSource = self
        discoverBaCView.updateData()
        citysCView.updateData()
        discoverBaCView.delegate = self
        //discoverBaCView.discoverCollectionView.dataSource = self
        
    }
    
}

//MARK: - Setup SubViews and Constraints

extension HomeViewController{
    
    func setupUI(){
        
        addSubViews()
        addConstraints()
        
    }
    
    func addSubViews(){
        self.view.backgroundColor = UIColor(hex: "F0F8FF")
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
//        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.translatesAutoresizingMaskIntoConstraints = false
        
//        quickConversorView.translatesAutoresizingMaskIntoConstraints = false
//        discoverBaCView.translatesAutoresizingMaskIntoConstraints = false
//        citysCView.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            contentView.topAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.widthAnchor), // Ancho igual
            
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            quickConversorView.heightAnchor.constraint(equalToConstant: 151),
            discoverBaCView.heightAnchor.constraint(equalToConstant: 158),
            collectionViewHeightConstraint
            //citysCView.heightAnchor.constraint(equalToConstant: 600)
        ])
        let heightConstraint = contentView.heightAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.heightAnchor)
        heightConstraint.priority = UILayoutPriority.defaultLow
        heightConstraint.isActive = true
        
    }
}

//MARK: - SetUp QuickConversor

extension HomeViewController{
    
    func setupQuickConversor(){
        
        Task {
            do{
                if let dolarBlue = try await homeViewModel.getDolarBlue() {
                    quickConversorView.setDolar(dolar: dolarBlue.venta)
                } else {
                    print("No se pudo obtener el valor del dólar")
                }
                let countryCode = homeViewModel.getUserCountry() ?? "AR"
                let value = try await homeViewModel.getValueForCountry(countryCode: countryCode)
                quickConversorView.setValue(value: value)
            } catch let error as APIError {
                handleAPIError(error)
            } catch {
                showAlert(message: "Error desconocido: \(error.localizedDescription)")
            }
        }
    }
    
    private func handleAPIError(_ error: APIError) {
        switch error {
            case .invalidURL:
                showAlert(message: "URL mal formada")
            case .requestFailed(let statusCode):
                showAlert(message: "Error en la API, código: \(statusCode)")
            case .invalidResponse:
                showAlert(message: "Respuesta no válida del servidor")
            case .decodingError:
                showAlert(message: "Error al decodificar los datos")
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
        self.alertMessage = message
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

        //print(count)
    }
    
}





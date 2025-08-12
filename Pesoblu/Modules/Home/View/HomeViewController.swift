//
//  HomeViewController.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 12/11/2024.
//

import UIKit

final class HomeViewController: UIViewController  {
    
    private var quickConversorView : QuickConversorView
    private var discoverBaCView : DiscoverBaCollectionView
    private var citiesCView : CitiesCollectionView
    private var alertMessage: String?
    private var onSelect : (([PlaceItem], String, PlaceType) -> Void)?
    
    private var collectionViewHeightConstraint: NSLayoutConstraint!
    
    private let homeViewModel: HomeViewModelProtocol
    
    init(homeViewModel: HomeViewModelProtocol,
         quickConversorView: QuickConversorView = QuickConversorView(),
         discoverBaCView: DiscoverBaCollectionView? = nil,
         citiesCView: CitiesCollectionView? = nil) {
        
        self.homeViewModel = homeViewModel
        self.quickConversorView = quickConversorView
        self.discoverBaCView = discoverBaCView ?? DiscoverBaCollectionView(homeViewModel: homeViewModel)
        self.citiesCView = citiesCView ?? CitiesCollectionView(homeViewModel: homeViewModel)
        
        super.init(nibName: nil, bundle: nil)
    }

    /// This view controller is intended to be instantiated programmatically.
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }
    
    func setOnSelect(_ completion: @escaping ([PlaceItem], String, PlaceType) -> Void) {
        onSelect = completion
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
        setupQuickConversor()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
       super.viewDidLayoutSubviews()
        //Desde aca nos aseguramos que las subvistas se creen despues del self.view, caso contrario este vale 0 y se marcan errores
        if mainScrollView.superview == nil {
            setup()
        }
        view.applyVerticalGradientBackground(colors: [
            UIColor(red: 236/255, green: 244/255, blue: 255/255, alpha: 1),
            UIColor(red: 213/255, green: 229/255, blue: 252/255, alpha: 1)
        ])
    }
    
}

//MARK: - Setting the View
@MainActor
extension HomeViewController  {
    func setup() {
        setupUI()
        citiesCView.delegate = self
        discoverBaCView.loadData()
        citiesCView.loadData() // Asegurar que los datos se carguen cuando la vista esté lista
        discoverBaCView.delegate = self
    }
}

//MARK: - Setup SubViews and Constraints
@MainActor
extension HomeViewController {
    
    func setupUI() {
        title = NSLocalizedString("home_title", comment: "")
        self.navigationController?.navigationBar.prefersLargeTitles = true
        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = .all
        addSubViews()
        addConstraints()
        setupDiscoverCollectionView()
        setupCitiesCollectionView()
        
    }
    
    func addSubViews() {
        self.view.backgroundColor = UIColor(hex: "F0F8FF")
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        
        contentView.addSubview(stackView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(quickConversorView)
    }
    
    func addConstraints() {
        //collectionViewHeightConstraint = citysCView.heightAnchor.constraint(equalToConstant: 200) // Altura inicial
        NSLayoutConstraint.activate([
            
            mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            mainScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            mainScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.widthAnchor), // Ancho igual
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            quickConversorView.heightAnchor.constraint(equalToConstant: 151),
            //discoverBaCView.heightAnchor.constraint(equalToConstant: 158),
            //collectionViewHeightConstraint
        ])
    }
    
    func setupDiscoverCollectionView() {
        stackView.addArrangedSubview(discoverBaCView)
        discoverBaCView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            discoverBaCView.heightAnchor.constraint(equalToConstant: 158)
        ])
        discoverBaCView.collectionViewForTesting.reloadData()
        discoverBaCView.loadData()
    }
    func setupCitiesCollectionView() {
        stackView.addArrangedSubview(citiesCView)
        citiesCView.translatesAutoresizingMaskIntoConstraints = false
        collectionViewHeightConstraint = citiesCView.heightAnchor.constraint(equalToConstant: 200) // Altura inicial
        NSLayoutConstraint.activate([
            collectionViewHeightConstraint
        ])
        citiesCView.collectionViewForTesting.reloadData()
        citiesCView.loadData()
    }
}

//MARK: - SetUp QuickConversor
@MainActor
extension HomeViewController {
    func setupQuickConversor() {
        
        Task { @MainActor in
            do{
                if let dolarBlue = try await homeViewModel.getDolarBlue() {
                    quickConversorView.setDolar(dolar: dolarBlue.venta)
                } else {
                    print(NSLocalizedString("no_dollar_value", comment: ""))
                }
                let countryCode = homeViewModel.getUserCountry() ?? NSLocalizedString("default_country_code", comment: "")
                let value = try await homeViewModel.getValueForCountry(countryCode: countryCode)
                quickConversorView.setValue(value: value)
            } catch let error as APIError {
                handleAPIError(error)
            } catch {
                showAlert(message: String(format: NSLocalizedString("unknown_error", comment: ""), error.localizedDescription))
            }
        }
    }
    
    private func handleAPIError(_ error: APIError) {
        switch error {
            case .invalidURL:
                showAlert(message: NSLocalizedString("invalid_url_error", comment: ""))
            case .requestFailed(let statusCode):
                showAlert(message: String(format: NSLocalizedString("api_error_code", comment: ""), statusCode))
            case .invalidResponse:
                showAlert(message: NSLocalizedString("invalid_server_response", comment: ""))
            case .decodingError:
                showAlert(message: NSLocalizedString("decoding_error", comment: ""))
        }
    }
}

//MARK: - DiscoverCollectionViewDelegate Methods
extension HomeViewController: CollectionViewSelectionDelegate {
    
    func didSelectItem(_ item: DiscoverItem) {
        do {
            let selectedCity = NSLocalizedString("city_caba", comment: "")
            let selectedPlaces = try homeViewModel.fetchPlaces(city: selectedCity)
            guard let placeType = PlaceType(rawValue: item.name) else { return }
            if selectedPlaces.isEmpty {
                showAlert(message: NSLocalizedString("no_places_available_for_selected_item", comment: ""))
            } else {
                onSelect?(selectedPlaces, selectedCity, placeType)
            }
        } catch PlaceError.noPlacesAvailable {
            showAlert(message: NSLocalizedString("no_places_found", comment: ""))
        } catch PlaceError.fileNotFound {
            showAlert(message: NSLocalizedString("file_not_found", comment: ""))
        } catch PlaceError.failedToParseData {
            showAlert(message: NSLocalizedString("data_processing_error", comment: ""))
        } catch {
            showAlert(message: String(format: NSLocalizedString("unexpected_error", comment: ""), error.localizedDescription))
        }
    }

    func showAlert(message: String) {
        self.alertMessage = message
        let alert = UIAlertController(title: NSLocalizedString("error_title", comment: ""), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok_action", comment: ""), style: .default))
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - CitiesViewDelegate Methods
extension HomeViewController: CitiesViewDelegate {
    func didSelectItem(_ city: CitiesItem) {
        let selectedCity = String(city.name)
        
        do{
            let selectedPlaces = try homeViewModel.fetchPlaces(city: selectedCity)
            let placeType: PlaceType = .all
            if selectedPlaces.isEmpty {
                showAlert(message: NSLocalizedString("no_places_available_for_selected_item", comment: ""))
            } else {
                onSelect?(selectedPlaces, selectedCity, placeType)
            }
        }
        catch PlaceError.noPlacesAvailable {
            showAlert(message: NSLocalizedString("no_places_found", comment: ""))
        } catch PlaceError.fileNotFound {
            showAlert(message: NSLocalizedString("file_not_found", comment: ""))
        } catch PlaceError.failedToParseData {
            showAlert(message: NSLocalizedString("data_processing_error", comment: ""))
        } catch {
            showAlert(message: String(format: NSLocalizedString("unexpected_error", comment: ""), error.localizedDescription))
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
    }
}
    
#if DEBUG
extension HomeViewController {
    var quickConversorViewForTesting: QuickConversorView { quickConversorView }
    var discoverBaCViewForTesting: DiscoverBaCollectionView { discoverBaCView }
    var citiesCViewForTesting: CitiesCollectionView { citiesCView }
    var alertMessageForTesting: String? { alertMessage }
}
#endif
    






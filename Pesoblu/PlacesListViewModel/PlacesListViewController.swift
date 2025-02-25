//
//  PlacesListViewController.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 08/01/2025.
//

//agregar favoritos
// boton de back personalizado y boton de favoritos en el otro costado
//tal vez agregar un recomendado a los mejores lugar en el json
import UIKit
import Foundation

class PlacesListViewController: UIViewController {
    
    var selectedPlaces: [PlaceItem]?
    var selectedCity: String?
    var placeType: String?
    var viewModel = PlaceListViewModel()
    var filterCView = FilterCollectionView()
    var placeListCView = PlaceListCollectionView()
    var collectionViewHeightConstraint: NSLayoutConstraint!
    
    private var mainScrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.bounces = true
        
        return scrollView
    }()
    
    private var contentView: UIView = {
        var view = UIView()
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeListCView.delegate = self
        filterCView.delegate = self
        setup()
    }
    
}

//MARK: - AddSubViews and Setup Constraints

extension PlacesListViewController{
    
    func setup(){
        
        addsubviews()
        setupConstraints()
        setCollectionViews()
    }
    
    func setCollectionViews(){
        
        filterCView.updateData(type: placeType ?? "All")
       
        if let selectedPlaces = selectedPlaces {
            placeListCView.updateData(for: selectedPlaces, by: placeType ?? "All")
        } else {
            print("selectedPlaces es nil")
            placeListCView.updateData(for: [], by: placeType ?? "All")
        }
    }
    
    func addsubviews() {
        self.view.backgroundColor  = UIColor(hex: "F0F8FF")
        let backButton = UIBarButtonItem(image: UIImage(named: "nav-arrow-left"), style: .plain, target: self, action: #selector(didTapBack))
        backButton.tintColor = UIColor.black

        self.navigationItem.leftBarButtonItem = backButton
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        self.mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(filterCView)
        stackView.addArrangedSubview(placeListCView)
        
        filterCView.translatesAutoresizingMaskIntoConstraints = false
        placeListCView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        
        collectionViewHeightConstraint = placeListCView.heightAnchor.constraint(equalToConstant: 200)
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.leadingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.trailingAnchor, constant: -10),
            contentView.widthAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.widthAnchor, constant: -20),
            contentView.bottomAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor),

            filterCView.heightAnchor.constraint(equalToConstant: 142),
            collectionViewHeightConstraint
        ])
        let heightConstraint = contentView.heightAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.heightAnchor)
        heightConstraint.priority = UILayoutPriority.defaultLow
        heightConstraint.isActive = true
    }
    
    @objc func didTapBack() {
        // Regresar a la vista anterior
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - UICollectionViewDelegate Methods
extension PlacesListViewController: PlaceListCollectionViewDelegate {
    func placeListCViewDidFailToLoadImage(_ collectionView: PlaceListCollectionView, error: any Error) {
        showAlert(title: "Error de Imagen", message: "No se pudo cargar la imagen. Intente nuevamente mas tarde")
    }
    
    func didSelectItem(_ item: PlaceItem) {
        guard let navigationController = navigationController else {
                print("Error: No hay un NavigationController disponible")
                return
            }
            
            let placeVC = PlaceViewController()
            placeVC.placeItem = item
            navigationController.pushViewController(placeVC, animated: true) 
    }
    
    func didUpdateItemCount(_ count: Int) {
        let labelSpacing = 38.0
        let rows = ceil(Double(count))
        let itemHeight = 278.0
        let spacing = 10.0
        let totalHeight = rows * itemHeight + (rows - 1) * spacing + labelSpacing
        collectionViewHeightConstraint.constant = totalHeight
        
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
        }
    }
}

extension PlacesListViewController: FilterCollectionViewDelegate {
    func didSelectFilter(_ filter: DiscoverItem) {
        self.placeType = filter.name
        filterCView.updateData(type: placeType ?? "All")
        if let selectedPlaces = selectedPlaces {
            placeListCView.updateData(for: selectedPlaces, by: placeType ?? "All")
        } else {
            print("selectedPlaces es nil")
            placeListCView.updateData(for: [], by: placeType ?? "All")
        }
    }
    
}
//MARK: - Alert Methods

extension PlacesListViewController{
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

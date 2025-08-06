//
//  PlacesListViewController.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 08/01/2025.
//

import UIKit
import Foundation
import CoreData

class PlacesListViewController: UIViewController {
    
    var onSelect: ((PlaceItem) -> Void)?
    var filterCView: FilterCollectionView
    var placesListCView: PlacesListCollectionView
    var placesListViewModel: PlacesListViewModelProtocol
    var selectedPlaces: [PlaceItem]
    var selectedCity: String
    var placeType: String
    
    init(placesListViewModel: PlacesListViewModelProtocol,
         filterCView: FilterCollectionView? = nil,
         placesListCView: PlacesListCollectionView? = nil,
         selectedPlaces: [PlaceItem],
         selectedCity: String,
         placeType: String){
        self.placesListViewModel = placesListViewModel
        self.filterCView = filterCView ?? FilterCollectionView(viewModel: placesListViewModel)
        self.placesListCView = placesListCView ?? PlacesListCollectionView(viewModel: placesListViewModel)
        self.selectedPlaces = selectedPlaces
        self.selectedCity = selectedCity
        self.placeType = placeType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
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
        placesListCView.delegate = self
        filterCView.delegate = self
        //setup()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if mainScrollView.superview == nil {
            setup()
        }
        view.applyVerticalGradientBackground(colors: [
            UIColor(red: 236/255, green: 244/255, blue: 255/255, alpha: 1),
            UIColor(red: 213/255, green: 229/255, blue: 252/255, alpha: 1)
        ])
    }
}

//MARK: - AddSubViews and Setup Constraints and Set Collection Views Data

extension PlacesListViewController{
    
    func setup(){
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Lista de Lugares"
        addsubviews()
        setupConstraints()
        setCollectionViews()
    }
    
    func setCollectionViews(){
        filterCView.updateData(type: placeType)
        placesListCView.updateData(for: selectedPlaces, by: placeType)
    }
    
    func addsubviews() {
        //self.view.backgroundColor  = UIColor(hex: "F0F8FF")
        filterCView.backgroundColor = .clear
        placesListCView.backgroundColor = .clear
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
        stackView.addArrangedSubview(placesListCView)

        filterCView.translatesAutoresizingMaskIntoConstraints = false
        placesListCView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        
        collectionViewHeightConstraint = placesListCView.heightAnchor.constraint(equalToConstant: 200)
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
    
}

//MARK: - UICollectionViewDelegate Methods
extension PlacesListViewController: PlacesListCollectionViewDelegate {
    func placesListCollectionViewDidFailToLoadImage(_ collectionView: PlacesListCollectionView, error: any Error) {
        showAlert(title: "Error de Imagen", message: "No se pudo cargar la imagen. Intente nuevamente mas tarde")
    }
    
    func didSelectItem(_ item: PlaceItem) {
        onSelect?(item)
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

//MARK: - FilterCollectionViewDelegate Methods

extension PlacesListViewController: FilterCollectionViewDelegate {
    func didSelectFilter(_ filter: DiscoverItem) {
        self.placeType = filter.name
        filterCView.updateData(type: placeType)
        placesListCView.updateData(for: selectedPlaces, by: placeType)
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

//MARK: - Button Methods
extension PlacesListViewController{
    
    @objc func didTapBack() {
        // Regresar a la vista anterior
        navigationController?.popViewController(animated: true)
    }
}

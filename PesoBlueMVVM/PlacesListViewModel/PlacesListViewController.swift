//
//  PlacesListViewController.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 08/01/2025.
//

//agregar filtro y recomendados
// y seleccionar la opcion elegida
// cuando hay un filtro seleccionado, en la nueva pantalla debe aparecer seleccionado
//cuando hay un nuevo filtro seleccionado, se desselecciona el anterior y se selecciona el nuevo
// luego se muestran los nuevos datos y se actualiza el collectionview
//agregar favoritos
// boton de back personalizado y boton de favoritos en el otro costado
import UIKit

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
        self.view.backgroundColor = .white
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        placeListCView.delegate = self
        setup()
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        mainScrollView.contentSize = CGSize(width: contentView.frame.width, height: contentView.frame.height)
////        print("ScrollView contentSize:", mainScrollView.contentSize)
////        print("ContentView frame:", contentView.frame)
////        print("StackView frame:", stackView.frame)
//    }
    
}

//MARK: - AddSubViews and Setup Constraints

extension PlacesListViewController{
    
    func setup(){
        
        addsubviews()
        setupConstraints()
        setCollectionViews()
    }
    
    func setCollectionViews(){
        
        filterCView.updateData()
       
        if let selectedPlaces = selectedPlaces {
            placeListCView.updateData(for: selectedPlaces, by: placeType ?? "All")
        } else {
            print("selectedPlaces es nil")
            placeListCView.updateData(for: [], by: placeType ?? "All")
        }
    }
    
    func addsubviews() {
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
}

extension PlacesListViewController: PlaceListCollectionViewDelegate {
    
    func didUpdateItemCount(_ count: Int) {
        let labelSpacing = 38.0
        let rows = ceil(Double(count))
        let itemHeight = 238.0
        let spacing = 10.0
        let totalHeight = rows * itemHeight + (rows - 1) * spacing + labelSpacing
        collectionViewHeightConstraint.constant = totalHeight
        
        DispatchQueue.main.async {
//            self.placeListCView.layoutIfNeeded() // Asegúrate de refrescar el layout
//            self.stackView.layoutIfNeeded()
//            self.contentView.layoutIfNeeded()
//            self.mainScrollView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
    }
}

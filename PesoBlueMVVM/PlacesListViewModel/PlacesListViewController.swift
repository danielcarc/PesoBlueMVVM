//
//  PlacesListViewController.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 08/01/2025.
//

//agregar filtro y seleccion del editor, para esto que suba una pequeña vista de no se 250p
// y seleccionar la opcion elegida
//agregar favoritos
// boton de back personalizado y boton de favoritos en el otro costado
import UIKit

class PlacesListViewController: UIViewController {
    
    var selectedPlaces: [PlaceItem]?
    var selectedCity: String?
    var placeType: String?
    var viewModel = PlaceListViewModel()
    
    var filterCView = FilterCollectionView()
    
    private var mainScrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        //scrollView.clipsToBounds = false
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
        
        setupUI()
    }
    

}

//MARK: - AddSubViews and Setup Constraints

extension PlacesListViewController{
    
    func setupUI(){
        
        filterCView.updateData()
        addsubviews()
        setupConstraints()
        
    }
    
    func addsubviews() {
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        filterCView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(filterCView)
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // MainScrollView
            mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView - Simplificar sus constraints
            contentView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            
            contentView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            
            // StackView
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            filterCView.heightAnchor.constraint(equalToConstant: 142)
            
        ])
    }
}

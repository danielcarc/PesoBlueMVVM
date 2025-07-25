//
//  PlaceViewController.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 29/01/2025.
//

import UIKit
import MapKit
import CoreData

class PlaceViewController: UIViewController {
    
    private var placeView: PlaceView
    private let placeViewModel: PlaceViewModelProtocol
    var place: PlaceItem
    
    init(placeView: PlaceView, placeViewModel: PlaceViewModelProtocol, place: PlaceItem) {
        
        self.placeViewModel = placeViewModel
        self.placeView = placeView
        self.place = place
        super.init(nibName: nil, bundle: nil)
        setupDependencies()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var context: NSManagedObjectContext {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext ?? NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    }
    
    private var isFavorite: Bool = false {
        didSet {
            updateFavoriteButton()
        }
    }
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return button
    }()
    
    private lazy var scrollView : UIScrollView = {
        var sview = UIScrollView()
        sview.showsVerticalScrollIndicator = true
        sview.bounces = true
        sview.showsHorizontalScrollIndicator = false
        sview.isScrollEnabled = true
        sview.translatesAutoresizingMaskIntoConstraints = false
        return sview
    }()
    
    private lazy var contentView : UIView = {
        var content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        return content
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

//MARK: - Setup Constraints

extension PlaceViewController{
    
    func setupDependencies(){
        placeView.delegate = self
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(hex: "F0F8FF")
        
        let backButton = UIBarButtonItem(image: UIImage(named: "nav-arrow-left"), style: .plain, target: self, action: #selector(didTapBack))
        backButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backButton
        setupNavigationButton()
        
        
        setupViews()
        
        setupConstraints()
        placeView.setData(item: place)
        loadFavoriteStatus()
//        if let placeItem = place {
//            placeView.setData(item: placeItem)
//            loadFavoriteStatus()
//        }
    }
    
    func setupViews(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(placeView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        placeView.translatesAutoresizingMaskIntoConstraints = false
    }
    

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            placeView.topAnchor.constraint(equalTo: contentView.topAnchor),
            placeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            placeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            placeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            placeView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
            
        ])
    }
}

//MARK: - Error Alerts

extension PlaceViewController: PlaceViewDelegate{
    func didFailToOpenInstagram(title: String, message: String) {
        showAlert(title: title, message: message)
    }
    
    func didFailToCall() {
        showAlert(title: "Error de Llamada", message: "No se puede realizar la llamada. Verifica el número o el dispositivo.")
    }
    
    func didFailToLoadImage(_ view: PlaceView, error: any Error) {
        showAlert(title: "Error de Imagen", message: "Error al cargar imagen. Intente nuevamente mas tarde.")
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

//MARK: - Navigation and Methods Buttons


extension PlaceViewController{
    
    func setupNavigationButton(){
        // Asignar el botón como customView del UIBarButtonItem
        let barButtonItem = UIBarButtonItem(customView: favoriteButton)
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    private func updateFavoriteButton() {
        UIView.transition(with: favoriteButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.favoriteButton.setImage(UIImage(systemName: self.isFavorite ? "heart.fill" : "heart"), for: .normal)
            self.favoriteButton.tintColor = self.isFavorite ? .red : .black
        }, completion: nil)
    }
    
    func loadFavoriteStatus() {
//        guard let id = place.id else {
//            print("Error: placeId is nil")
//            return
//        }
        let placeId = String(place.id)
        
        Task{
            do{
                self.isFavorite = try await self.placeViewModel.loadFavoriteStatus(placeId: placeId)
            }
            catch{
                self.showAlert(title: "Error", message: "\(error.localizedDescription)")
            }
        }
    }
    
    func saveFavoriteStatus(){
//        guard let id = placeItem?.id else {
//            print("Error: placeId is nil")
//            return
//        }
        let placeId = String(place.id)
        
        Task{
            do{
                try await placeViewModel.saveFavoriteStatus(placeId: placeId, isFavorite: isFavorite)
            }
            catch{
                showAlert(title: "Error", message: "Error saving favorite status: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func didTapBack() {
        // Regresar a la vista anterior
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func toggleFavorite() {
        isFavorite.toggle()
        saveFavoriteStatus()
        
    }
}

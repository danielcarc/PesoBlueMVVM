//
//  PlacesListViewController.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 08/01/2025.
//

import UIKit
import Foundation
import CoreData

final class PlacesListViewController: UIViewController  {

    var onSelect: ((PlaceItem) -> Void)?
    var placesListViewModel: PlacesListViewModelProtocol
    private let placeListCollectionViewModel: PlaceListCollectionViewModel
    private let selectedPlaces: [PlaceItem]
    private let selectedCity: String
    private(set) var placeType: PlaceType
    private var filters: [DiscoverItem] = []

    private var placesListView: PlacesListView {
        guard let placesListView = view as? PlacesListView else {
            AppLogger.error("Expected view to be of type PlacesListView")
            let errorVC = ErrorViewController(
                message: NSLocalizedString(
                    "places_list_view_load_error_message",
                    comment: "Error message when PlacesListView fails to load"
                )
            )
            DispatchQueue.main.async { [weak self] in
                self?.present(errorVC, animated: true)
            }
            return PlacesListView(filterCView: FilterCollectionView(), placesListCView: PlacesListCollectionView())
        }
        return placesListView
    }

    init(placesListViewModel: PlacesListViewModelProtocol,
         selectedPlaces: [PlaceItem],
         selectedCity: String,
         placeType: PlaceType) {
        self.placesListViewModel = placesListViewModel
        self.placeListCollectionViewModel = PlaceListCollectionViewModel(placesListViewModel: placesListViewModel)
        self.selectedPlaces = selectedPlaces
        self.selectedCity = selectedCity
        self.placeType = placeType
        super.init(nibName: nil, bundle: nil)
    }

    /// This view controller is intended to be instantiated programmatically.
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }

    override func loadView() {
        let filterView = FilterCollectionView()
        let placesView = PlacesListCollectionView()
        self.view = PlacesListView(filterCView: filterView, placesListCView: placesView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false

        navigationItem.title = String(
            format: NSLocalizedString(
                "places_in_city_title",
                comment: "Navigation title for places in a specific city"
            ),
            selectedCity
        )
      
        let backButton = UIBarButtonItem(image: UIImage(named: "nav-arrow-left"), style: .plain, target: self, action: #selector(didTapBack))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton

        placesListView.placesListCView.delegate = self
        placesListView.filterCView.delegate = self
        setCollectionViews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.applyVerticalGradientBackground(colors: [
            UIColor(red: 236/255, green: 244/255, blue: 255/255, alpha: 1),
            UIColor(red: 213/255, green: 229/255, blue: 252/255, alpha: 1)
        ])
    }
}

extension PlacesListViewController  {
    func setCollectionViews() {
        filters = placesListViewModel.fetchFilterItems()
        placesListView.filterCView.update(with: filters, selectedType: placeType)
        let items = placeListCollectionViewModel.makeItems(from: selectedPlaces, filter: placeType)
        placesListView.placesListCView.updateData(with: items)
    }
}

    // MARK: - PlacesListCollectionViewDelegate
extension PlacesListViewController: PlacesListCollectionViewDelegate  {
    func placesListCollectionViewDidFailToLoadImage(_ collectionView: PlacesListCollectionView, error: any Error) {
        showAlert(title: NSLocalizedString("image_error_title", comment: "Image loading error title"),
                  message: NSLocalizedString("image_error_message", comment: "Image loading error message"))
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
        placesListView.collectionViewHeightConstraint.constant = totalHeight

        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
        }
    }
}

    // MARK: - FilterCollectionViewDelegate
extension PlacesListViewController: FilterCollectionViewDelegate  {
    func didSelectFilter(_ filter: DiscoverItem) {
        guard let type = PlaceType(rawValue: filter.name) else { return }
        placeType = type
        placesListView.filterCView.update(with: filters, selectedType: placeType)
        let items = placeListCollectionViewModel.makeItems(from: selectedPlaces, filter: placeType)
        placesListView.placesListCView.updateData(with: items)
    }
}

    // MARK: - Alert Methods
extension PlacesListViewController  {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok_action", comment: "Dismiss alert action"),
                                      style: .default))
        present(alert, animated: true)
    }
}

    // MARK: - Button Methods
extension PlacesListViewController  {
    @objc func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}


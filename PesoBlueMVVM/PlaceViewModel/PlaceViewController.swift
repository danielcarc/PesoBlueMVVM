//
//  PlaceViewController.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 29/01/2025.
//

import UIKit
import MapKit

class PlaceViewController: UIViewController {
    
    var placeItem: PlaceItem?
    private lazy var placeView = PlaceView()
    
    
    private lazy var scrollView : UIScrollView = {
        var sview = UIScrollView()
        sview.showsVerticalScrollIndicator = true
        sview.bounces = true
        //scrollView.contentInsetAdjustmentBehavior = .never
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
    
    private func setupUI() {
        view.backgroundColor = UIColor(hex: "F0F8FF")
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(placeView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        placeView.translatesAutoresizingMaskIntoConstraints = false
        
        setupConstraints()
        if let placeItem = placeItem {
            placeView.setData(item: placeItem)
        }
        
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

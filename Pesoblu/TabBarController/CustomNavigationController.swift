//
//  CustomNavigationController.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 11/04/2025.
//

import UIKit

class CustomNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Activar prefersLargeTitles
        navigationBar.prefersLargeTitles = true
        
        // Configurar el UINavigationBar como opaco
        navigationBar.isTranslucent = false
        navigationBar.backgroundColor = .white
    }
}

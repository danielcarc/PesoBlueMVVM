//
//  PesoBlueTabBarControllerViewController.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 23/04/2024.
//

import UIKit

class PesoBlueTabBarControllerViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTabs()
    }
    

    private func configureTabs(){
        
        let vc1 = ChangeViewController()
        let vc2 = CurrencyViewController()
        
        // Set Tab Images
        vc1.tabBarItem.image = UIImage(systemName: "dollarsign.square.fill")
        vc2.tabBarItem.image = UIImage(systemName: "arrow.left.arrow.right.square.fill")
        
        // Set Titles
        vc1.title = "Cambio"
        vc2.tabBarItem.title = "Calcular"
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        
        setViewControllers([nav1, nav2], animated: false)
    }
    

}

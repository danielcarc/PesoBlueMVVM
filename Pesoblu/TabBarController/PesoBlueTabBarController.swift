//
//  PesoBlueTabBarControllerViewController.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 23/04/2024.
//
import UIKit

class PesoBlueTabBarController: UITabBarController {

    init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

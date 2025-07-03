//
//  MainTabCoordinator.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 03/07/2025.
//
import UIKit

class MainTabCoordinator: Coordinator {

    var window: UIWindow
    var navigationController: UINavigationController = UINavigationController()

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let tabBarController = PesoBlueTabBarController()
        // Podés inyectar coordinadores hijos para cada tab si querés
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}

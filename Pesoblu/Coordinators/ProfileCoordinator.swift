//
//  ProfileCoordinator.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 03/07/2025.
//
import UIKit
import SwiftUI

class ProfileCoordinator: Coordinator {

    var navigationController: UINavigationController
    let userService: UserServiceProtocol
    weak var parentCoordinator: MainTabCoordinator?
    

    init(navigationController: UINavigationController,
         userService: UserServiceProtocol) {
        self.navigationController = navigationController
        self.userService = userService
    }
    
    func start() {
        let viewModel = UserProfileViewModel(userService: UserService())
        let profileView = UserProfileView(viewModel: viewModel) { [weak self] in
            self?.handleSignOut()
        }

        let hostingVC = UIHostingController(rootView: profileView)
        hostingVC.title = "Perfil"
        hostingVC.tabBarItem = UITabBarItem(title: "Perfil", image: UIImage(named: "user-square"), tag: 3)
        navigationController.setViewControllers([hostingVC], animated: false)
    }

    private func handleSignOut() {
        // Volver al login u otra acción del flujo
        parentCoordinator?.didSignOutFromProfile()
    }
}

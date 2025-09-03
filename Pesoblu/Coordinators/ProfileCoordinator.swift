//
//  ProfileCoordinator.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 03/07/2025.
//
import UIKit
import SwiftUI
import GoogleSignIn

class ProfileCoordinator: Coordinator {

    var navigationController: UINavigationController
    let userService: UserServiceProtocol
    let gidSignIn: GIDSignIn
    weak var parentCoordinator: MainTabCoordinator?
    

    init(navigationController: UINavigationController,
         userService: UserServiceProtocol,
         gidSignIn: GIDSignIn) {
        self.navigationController = navigationController
        self.userService = userService
        self.gidSignIn = gidSignIn
    }
    
    func start() {
        let viewModel = UserProfileViewModel(gidSignIn: gidSignIn, userService: UserService())
        let profileView = UserProfileView(viewModel: viewModel) { [weak self] in
            self?.handleSignOut()
        }

        let hostingVC = UIHostingController(rootView: profileView)
        let title = NSLocalizedString("profile_title", comment: "")
        hostingVC.title = title
        hostingVC.tabBarItem = UITabBarItem(title: title, image: UIImage(named: "user-square"), tag: 3)
        navigationController.setViewControllers([hostingVC], animated: false)
    }

    private func handleSignOut() {
        // Volver al login u otra acción del flujo
        parentCoordinator?.didSignOutFromProfile()
    }
}

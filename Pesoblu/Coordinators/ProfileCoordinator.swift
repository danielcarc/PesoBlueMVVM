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
    weak var appCoordinator: AppCoordinator?

    init(navigationController: UINavigationController,
         userService: UserServiceProtocol,
         appCoordinator: AppCoordinator? = nil) {
        self.navigationController = navigationController
        self.userService = userService
        self.appCoordinator = appCoordinator
    }

    func start() {
        let viewModel = UserProfileViewModel(userService: userService)

        let profileView = UserProfileView(viewModel: viewModel) {
            self.appCoordinator?.showLogin() // ✅ Reemplazá por el flujo correcto
        }

        let hostingController = UIHostingController(rootView: profileView)
        navigationController.pushViewController(hostingController, animated: true)
    }
}

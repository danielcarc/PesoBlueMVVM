//
//  LoginCoordinator.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 03/07/2025.
//
import UIKit
import FirebaseCore
import GoogleSignIn

protocol LoginNavigationDelegate: AnyObject {
    func didLoginSuccessfully()
}

class LoginCoordinator: Coordinator {

    var navigationController: UINavigationController
    weak var delegate: LoginNavigationDelegate?

    let firebaseApp: FirebaseApp
    let gidSignIn: GIDSignIn
    let userService: UserService
    
    init(navigationController: UINavigationController,
         firebaseApp: FirebaseApp,
         gidSignIn: GIDSignIn,
         userService: UserService) {
        self.navigationController = navigationController
        self.firebaseApp = firebaseApp
        self.gidSignIn = gidSignIn
        self.userService = userService
    }
    
    func start() {
        let viewModel = AuthenticationViewModel(firebaseApp: firebaseApp, gidSignIn: gidSignIn, userService: userService)
        
        let loginVC = LoginViewController.create(
            authVM: viewModel,
            userService: userService,
            coordinator: self
        )

        navigationController.setViewControllers([loginVC], animated: false)
    }
}

extension LoginCoordinator: LoginNavigationDelegate{
    func didLoginSuccessfully() {
        delegate?.didLoginSuccessfully()
    }
    
    
}

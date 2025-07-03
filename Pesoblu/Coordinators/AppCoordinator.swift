//
//  AppCoordinators.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 03/07/2025.
//
import UIKit

class AppCoordinator: Coordinator{
    var window: UIWindow
    var navigationController: UINavigationController
    var childCoordinator: Coordinator?
    
    init(window: UIWindow){
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        showLogin()
    }
    
    func showLogin() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let firebaseApp = appDelegate.firebaseApp,
              let gidSignIn = appDelegate.gidSignIn,
              let userService = appDelegate.userService else {
            fatalError("Dependencies not set")
        }
        
        let loginCoordinator = LoginCoordinator(
            navigationController: navigationController,
            firebaseApp: firebaseApp,
            gidSignIn: gidSignIn,
            userService: userService
        )
        
        loginCoordinator.delegate = self
        childCoordinator = loginCoordinator
        loginCoordinator.start()
    }
    
    private func showMainApp(){
        let tabCoordinator = MainTabCoordinator(window: window)
        childCoordinator = tabCoordinator
        tabCoordinator.start()
    }
    
}

extension AppCoordinator: LoginNavigationDelegate {
    func didLoginSuccessfully() {
        showMainApp()
    }
}

extension AppCoordinator{
    func showProfile() {
        let userService = UserService()
        let profileCoordinator = ProfileCoordinator(
            navigationController: navigationController,
            userService: userService,
            appCoordinator: self
        )
        profileCoordinator.start()
        childCoordinator = profileCoordinator
    }
}

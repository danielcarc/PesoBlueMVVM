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
    weak var mainTabCoordinator: MainTabCoordinator?
    
    init(window: UIWindow){
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        // Verificar estado de autenticación
        let userService = UserService()
        if userService.loadUser() != nil {
            showMainApp()
        } else {
            showLogin()
        }
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
        let transition = CATransition()
        transition.duration = 0.35
        transition.type = .push
        transition.subtype = .fromRight
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        window.layer.add(transition, forKey: kCATransition)
        window.rootViewController = navigationController
        
        loginCoordinator.start()
    }
    
    func showMainApp() {
        let tabCoordinator = MainTabCoordinator(window: window, appCoordinator: self)
        mainTabCoordinator = tabCoordinator
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
            userService: userService
        )
        profileCoordinator.start()
        childCoordinator = profileCoordinator
    }
    
    func didFinishSession() {
        // Limpiar coordinadores actuales
        childCoordinator = nil
        mainTabCoordinator = nil
        
        // También reiniciamos el UINavigationController, por si fue usado en algún tab
        navigationController = UINavigationController()
        window.rootViewController = navigationController
        
        // Mostrar login
        showLogin()
    }

}

//
//  NavigationCoordinator.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 22/06/2025.
//
import UIKit

class NavigationCoordinator {
    func showLoginScreen() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            // Reutilizar las instancias existentes o crearlas desde un contenedor
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
               let firebaseApp = appDelegate.firebaseApp,
               let gidSignIn = appDelegate.gidSignIn,
               let userService = appDelegate.userService {
                let authVM = AuthenticationViewModel(firebaseApp: firebaseApp, gidSignIn: gidSignIn, userService: userService)
                let coordinator = NavigationCoordinator()
                let loginVC = LoginViewController.create(authVM: authVM, userService: userService, coordinator: coordinator)
                window.rootViewController = loginVC
                window.makeKeyAndVisible()
                
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
            }
        }
    }
    
    func showTabBar(from window: UIWindow? = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first){
        let tabBarController = PesoBlueTabBarController()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        UIView.transition(with: window!, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
}

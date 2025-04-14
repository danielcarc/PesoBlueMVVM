//
//  LoginViewController.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 14/10/2024.
//

import UIKit
import FirebaseAnalytics

class LoginViewController: UIViewController {
    
    let authVM = AuthenticationViewModel()
    let loggedUser = UserService()
    
    var loginView : LoginView!
    
    override func loadView() {
        loginView = LoginView()
        self.view = loginView
        loginView.onGoogleSignInTap = { [weak self] in
            Task{
                await self?.didTapSignUpGoogle()
            }
        }
        
        loginView.onAppleSignInTap = { [weak self] in
            self?.didTapSignUpApple()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("Superview frame: \(self.view.frame)")
        
        // Registrar pantalla en Firebase Analytics
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: "Login Screen",
            AnalyticsParameterScreenClass: String(describing: type(of: self))
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

//MARK: - Sign in Methods

extension LoginViewController {
    
    func didTapSignUpGoogle() async {
        do {
            if try await authVM.singInWithGoogle() {
                let user = loggedUser.loadUser()
                Analytics.logEvent("user_logged_in", parameters: [
                    "user_email": "\(user?.email ?? "unknown")"
                ])
                print("User tapped Google Sign-In")
                
                let tabBarController = PesoBlueTabBarController()
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    window.rootViewController = tabBarController
                    window.makeKeyAndVisible()
                    
                    UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
                }
            } else {
                print("Error signing in with Google")
            }
        } catch let error as AuthenticationViewModel.AuthError {
            print("AuthError: \(error.localizedDescription)")
            // Aquí puedes mostrar una alerta con error.localizedDescription al usuario
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
            // Maneja errores inesperados si es necesario
        }
    }
    
    
    // el sign in with apple se agrega apenas antes de publicar la app
    func didTapSignUpApple() {
         Analytics.logEvent("user_logged_in", parameters: [
                 "user_email": "user@example.com"
             ])
             print("User tapped Apple Sign-In")
     }
}


//#Preview("LoginViewController", traits: .defaultLayout, body: { LoginViewController()})


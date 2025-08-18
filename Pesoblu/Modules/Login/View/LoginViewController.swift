//
//  LoginViewController.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 14/10/2024.
//

import UIKit
import FirebaseAnalytics
import Combine

protocol LoginViewProtocol: AnyObject  {
    func didTapSignUpGoogle() async
    func didTapSignUpApple()
}

class LoginViewController: UIViewController, LoginViewProtocol  {
    
    var authVM : AuthenticationViewModelProtocol
    let userService : UserService
    private let coordinator: LoginNavigationDelegate
    private var cancellables = Set<AnyCancellable>()
    
    var loginView : LoginView!
    private var activityIndicator: UIActivityIndicatorView!
    
    init(authVM: AuthenticationViewModelProtocol, userService: UserService, coordinator: LoginNavigationDelegate) {
        self.authVM = authVM
        self.userService = userService
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    /// This view controller is intended to be instantiated programmatically.
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }
    
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
        
        authVM.onAuthenticationSuccess = { [weak self] in
            guard let self = self else { return }
            let user = self.userService.loadUser()
            Analytics.logEvent("user_logged_in", parameters: [
                "user_email": "\(user?.email ?? "unknown")"
            ])
            coordinator.didLoginSuccessfully()
        }
        authVM.delegate = self // Configurar el delegate para errores
        
        setupStateObservation()
        setupActivityIndicator()
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupStateObservation() {
        authVM.authenticationState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .authenticating:
                    self.activityIndicator.startAnimating()
                case .authenticated, .unauthenticated:
                    self.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Registrar pantalla en Firebase Analytics
              Analytics.logEvent(AnalyticsEventScreenView, parameters: [
              AnalyticsParameterScreenName: NSLocalizedString("login_screen_name", comment: ""),
            AnalyticsParameterScreenClass: String(describing: type(of: self))
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: - Sign in Methods

extension LoginViewController  {
    
    func didTapSignUpGoogle() async {
        do {
            try await authVM.singInWithGoogle()
        } catch let error as AuthenticationViewModel.AuthError {
            AppLogger.error("AuthError: \(error.localizedDescription)")
            showErrorAlert(error)
        } catch {
            AppLogger.error("Unexpected error: \(error.localizedDescription)")
            showErrorAlert(AuthenticationViewModel.AuthError.unknown)
        }
    }
    
    
    // el sign in with apple se agrega apenas antes de publicar la app
    func didTapSignUpApple() {
        Analytics.logEvent("user_logged_in", parameters: [
            "user_email": "user@example.com"
        ])
        AppLogger.debug("User tapped Apple Sign-In")
    }
}

extension LoginViewController: AuthenticationDelegate {
    private func showErrorAlert(_ error: AuthenticationViewModel.AuthError) {
          let alert = UIAlertController(title: NSLocalizedString("error_title", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: NSLocalizedString("ok_action", comment: ""), style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showError(_ error: Error) {
        if let authError = error as? AuthenticationViewModel.AuthError {
            showErrorAlert(authError)
        } else {
            showErrorAlert(AuthenticationViewModel.AuthError.unknown)
        }
    }

}

extension LoginViewController  {
    static func create(authVM: AuthenticationViewModel,
                       userService: UserService,
                       coordinator: LoginNavigationDelegate) -> LoginViewController {
        let vc = LoginViewController(authVM: authVM, userService: userService, coordinator: coordinator)
        return vc
    }
}



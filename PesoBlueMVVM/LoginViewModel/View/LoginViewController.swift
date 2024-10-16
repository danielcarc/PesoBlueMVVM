//
//  LoginViewController.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 14/10/2024.
//

import UIKit

class LoginViewController: UIViewController {
    
   
    var loginView : LoginView!
    
    override func loadView() {
        loginView = LoginView()
        self.view = loginView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loginView.setupUI()
    }

    
}



//#Preview("LoginViewController", traits: .defaultLayout, body: { LoginViewController()})


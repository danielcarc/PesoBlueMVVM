//
//  LoginView.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 16/10/2024.
//

import UIKit

class LoginView: UIView  {
    
    private lazy var scrollView: UIScrollView = {
        var sview = UIScrollView()
        sview.translatesAutoresizingMaskIntoConstraints = false
     
        return sview
        
    }()
    
    private lazy var contentView: UIView = {
        var contentMode = UIView()
        
        contentMode.translatesAutoresizingMaskIntoConstraints = false
        
        return contentMode
    }()
    
    //Agregar una imagen que represente a Argentina, sea descargada o de las propias
    private lazy var photoImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "Obelisco")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: LayoutConstants.imageHeight)
                ])
        
        return imageView
    }()
    
    private lazy var headerStack: UIStackView = {
        var view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.backgroundColor = .white
        
        return view
    }()
    
    private lazy var welcomeLabel: UILabel = {
        var label = UILabel()
          label.text = NSLocalizedString("login_welcome", comment: "")
        label.font = .boldSystemFont(ofSize: 22)
        
        label.textAlignment = .center
        //label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        var label = UILabel()

          label.text = NSLocalizedString("login_description", comment: "")

        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var buttonStack: UIStackView = {
        var view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.backgroundColor = .white
        
        return view
    }()
    
    var onGoogleSignInTap: (() -> Void)?
    
    private lazy var googleButton: UIButton = {
        
        var button = UIButton()
        
        // Ajusta el espacio entre imagen y texto
        //button.semanticContentAttribute = .forceRightToLeft
        button.backgroundColor = UIColor(red: 0.91, green: 0.94, blue: 0.96, alpha: 1.0)
        //button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector (googleButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                    button.heightAnchor.constraint(equalToConstant: 48)
                ])
        
        return button
    }()
    
    //agregar el logo de google al boton
    private lazy var googleButtonLabel: UILabel = {
        var label = UILabel()
          label.text = NSLocalizedString("login_continue_google", comment: "")
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .black
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var googleLogoImageView: UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "googlelogo"))
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalToConstant: 24)
        ])
        imageView.isUserInteractionEnabled = false
        
        return imageView
    }()
    
    private lazy var googleButtonStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [googleLogoImageView, googleButtonLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    var onAppleSignInTap: (() -> Void)?
    
    private lazy var appleButton: UIButton = {
        var button = UIButton()
        
        // Ajusta el espacio entre imagen y texto
        //button.semanticContentAttribute = .forceRightToLeft
        button.backgroundColor = UIColor(red: 0.91, green: 0.94, blue: 0.96, alpha: 1.0)
        //button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector (appleButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                    button.heightAnchor.constraint(equalToConstant: 48)
                ])
        
        return button
    }()
    
    private lazy var appleButtonLabel: UILabel = {
        var label = UILabel()
          label.text = NSLocalizedString("login_continue_apple", comment: "")
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .black
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var appleLogoImageView: UIImageView = {
        var imageView = UIImageView(image: UIImage(systemName: "apple.logo"))
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalToConstant: 24)
        ])
        imageView.isUserInteractionEnabled = false
        
        return imageView
    }()
    
    private lazy var appleButtonStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [appleLogoImageView, appleButtonLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    /// This view is intended to be instantiated programmatically.
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }
        
}

private extension LoginView {
     func setupUI() {
        self.backgroundColor = UIColor(red: 0.95, green: 0.97, blue: 0.98, alpha: 1.0)
        
        addSubViews()
        setupConstraints()
         
    }
    
    private func addSubViews() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(photoImageView)
        contentView.addSubview(headerStack)
        contentView.addSubview(buttonStack)
        
        headerStack.addArrangedSubview(welcomeLabel)
        headerStack.addArrangedSubview(descriptionLabel)
        
        buttonStack.addArrangedSubview(googleButton)
        buttonStack.addArrangedSubview(appleButton)
        
        googleButton.addSubview(googleButtonStackView)
        appleButton.addSubview(appleButtonStackView)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            //contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),
            
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            //photoImageView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            headerStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            headerStack.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 16),
            headerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            //headerStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            // Asegurarse de que el ancho del contenido sea igual al ancho del contentview
            headerStack.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -32),
            
            buttonStack.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 32),
            buttonStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            buttonStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            buttonStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
            buttonStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            googleButton.topAnchor.constraint(equalTo: buttonStack.topAnchor),
            googleButton.heightAnchor.constraint(equalToConstant: LayoutConstants.buttonHeight),
            googleButton.widthAnchor.constraint(equalTo: buttonStack.widthAnchor),
            
            googleButtonStackView.leadingAnchor.constraint(equalTo: googleButton.leadingAnchor, constant: 10),
            googleButtonStackView.trailingAnchor.constraint(equalTo: googleButton.trailingAnchor, constant: -34),
            googleButtonStackView.topAnchor.constraint(equalTo: googleButton.topAnchor),
            googleButtonStackView.bottomAnchor.constraint(equalTo: googleButton.bottomAnchor),
            
            //googleButton.trailingAnchor.constraint(equalTo: buttonStack.trailingAnchor),
            
            appleButton.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: 16),
            appleButton.heightAnchor.constraint(equalToConstant: LayoutConstants.buttonHeight),
            appleButton.leadingAnchor.constraint(equalTo: buttonStack.leadingAnchor),
            appleButton.trailingAnchor.constraint(equalTo: buttonStack.trailingAnchor),
            
            appleButtonStackView.leadingAnchor.constraint(equalTo: appleButton.leadingAnchor, constant: 10),
            appleButtonStackView.trailingAnchor.constraint(equalTo: appleButton.trailingAnchor, constant: -34),
            appleButtonStackView.topAnchor.constraint(equalTo: appleButton.topAnchor),
            appleButtonStackView.bottomAnchor.constraint(equalTo: appleButton.bottomAnchor)
            
        ])
    }
    
    @objc func googleButtonTapped() {
        onGoogleSignInTap?()
    }
    
    @objc func appleButtonTapped() {
        onAppleSignInTap?()
    }
    
}

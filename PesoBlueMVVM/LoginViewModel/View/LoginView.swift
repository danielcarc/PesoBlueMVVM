//
//  LoginView.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 16/10/2024.
//

import UIKit

class LoginView: UIView {
    
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
        NSLayoutConstraint.activate([
                    imageView.heightAnchor.constraint(equalToConstant: 300)
                ])
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
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
        label.text = "Welcome to Argentina"
        label.font = .boldSystemFont(ofSize: 22)
        
        label.textAlignment = .center
        //label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        var label = UILabel()

        label.text = "Descubrí una nueva forma de explorar la Argentina con nuestra guía turística del editor y nuestro conversor de monedas en tiempo real."

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
        button.setTitle("Continuar con Google", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector (googleButtonTapped), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 0.91, green: 0.94, blue: 0.96, alpha: 1.0)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 10
        NSLayoutConstraint.activate([
                    button.heightAnchor.constraint(equalToConstant: 48)
                ])
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
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
        
        NSLayoutConstraint.activate([
                    button.heightAnchor.constraint(equalToConstant: 48)
                ])
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var appleButtonLabel: UILabel = {
        var label = UILabel()
        label.text = "Continuar con Apple"
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
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalToConstant: 24)
        ])
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}

private extension LoginView{
     func setupUI() {
        self.backgroundColor = UIColor(red: 0.95, green: 0.97, blue: 0.98, alpha: 1.0)
        
        addSubViews()
        setupConstraints()
         //print("Gesture Recognizers: \(googleButton.gestureRecognizers ?? [])")  // Imprime los reconocedores

         
    }
    
//    internal override func layoutSubviews() {
//        super.layoutSubviews()
//        print("Button frame: \(googleButton.frame)")  // Comprueba el frame
//        print("Button interaction enabled: \(googleButton.isUserInteractionEnabled)")
//        print("Superview interaction enabled: \(self.isUserInteractionEnabled)")
//        print("StackView frame: \(buttonStack.frame)")
//        print("ScrollView frame: \(scrollView.frame)")
//        if let superview = buttonStack.superview {
//            print("Subviews of superview: \(superview.subviews)")
//        }
//        print("Is stack view hidden: \(buttonStack.isHidden)")
//
//
//
//    }
    
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
                    googleButton.heightAnchor.constraint(equalToConstant: 48),
                    googleButton.widthAnchor.constraint(equalTo: buttonStack.widthAnchor),
                    //googleButton.trailingAnchor.constraint(equalTo: buttonStack.trailingAnchor),
                    
                    appleButton.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: 16),
                    appleButton.heightAnchor.constraint(equalToConstant: 48),
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

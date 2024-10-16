//
//  LoginViewController.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 14/10/2024.
//

import UIKit

class LoginViewController: UIViewController {
    
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
        view.distribution = .fillEqually
        view.spacing = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.backgroundColor = .white
        
        return view
    }()
    
    private lazy var googleButton: UIButton = {
        var button = UIButton()
        button.setTitle("Continuar con Google", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor(red: 0.91, green: 0.94, blue: 0.96, alpha: 1.0)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 10
        NSLayoutConstraint.activate([
                    button.heightAnchor.constraint(equalToConstant: 48)
                ])
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var appleButton: UIButton = {
        var button = UIButton()
        
        // Ajusta el espacio entre imagen y texto
        //button.semanticContentAttribute = .forceRightToLeft
        button.backgroundColor = UIColor(red: 0.91, green: 0.94, blue: 0.96, alpha: 1.0)
        //button.setTitleColor(UIColor.black, for: .normal)
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
        
        return imageView
    }()
    
    private lazy var appleButtonStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [appleLogoImageView, appleButtonLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.97, blue: 0.98, alpha: 1.0)
        
        addSubViews()
        setupConstraints()
        
    }
    private func addSubViews() {
        view.addSubview(scrollView)
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
                    scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                    scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                    scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                    scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                    
                    contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                    contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                    contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                    contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                    contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                    
                    photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                    photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                    photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                    //photoImageView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
                    
                    headerStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                    headerStack.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 16),
                    headerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                    headerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
                    //headerStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
                    
                    // Asegurarse de que el ancho del contenido sea igual al ancho del scrollView
                    headerStack.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -32),
                    
                    buttonStack.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 32),
                    buttonStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                    buttonStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                    
                    appleButtonStackView.leadingAnchor.constraint(equalTo: appleButton.leadingAnchor, constant: 10),
                    appleButtonStackView.trailingAnchor.constraint(equalTo: appleButton.trailingAnchor, constant: -34),
                    appleButtonStackView.topAnchor.constraint(equalTo: appleButton.topAnchor),
                    appleButtonStackView.bottomAnchor.constraint(equalTo: appleButton.bottomAnchor)
                    
                ])
    }
}
//    private func setupUI() {
//        // Establecer fondo y color general
//        view.backgroundColor = UIColor(red: 0.95, green: 0.97, blue: 0.98, alpha: 1.0)
//
//        // ScrollView para asegurar que todo sea visible en pantallas pequeñas
//        let scrollView = UIScrollView()
//        view.addSubview(scrollView)
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//
//        // Encabezado con botón y título
//        let headerStack = UIStackView(arrangedSubviews: [backButton(), titleLabel()])
//        headerStack.axis = .horizontal
//        headerStack.alignment = .center
//        headerStack.distribution = .fill
//        headerStack.spacing = 12
//        scrollView.addSubview(headerStack)
//
//        // Texto de bienvenida
//        let welcomeLabel = createLabel(
//            text: "Bienvenido a Buenos Aires",
//            fontSize: 28,
//            weight: .bold
//        )
//        let descriptionLabel = createLabel(
//            text: "Descubre una nueva forma de explorar la ciudad con nuestra guía turística personalizada.",
//            fontSize: 16,
//            weight: .regular
//        )
//        scrollView.addSubview(welcomeLabel)
//        scrollView.addSubview(descriptionLabel)
//
//        // Botones
//        let googleButton = createButton(title: "Continuar con Google", bgColor: UIColor(red: 0.91, green: 0.94, blue: 0.96, alpha: 1.0))
//        let appleButton = createButton(title: "Continuar con Apple", bgColor: UIColor(red: 0.91, green: 0.94, blue: 0.96, alpha: 1.0))
//        let registerButton = createButton(title: "Registrarse gratis", bgColor: .clear, textColor: .black)
//        registerButton.layer.borderWidth = 1
//        registerButton.layer.borderColor = UIColor.black.cgColor
//        let loginButton = createButton(title: "Iniciar sesión", bgColor: UIColor(red: 0.11, green: 0.63, blue: 0.95, alpha: 1.0), textColor: .white)
//
//        // Añadir acciones a los botones
//        googleButton.addTarget(self, action: #selector(handleGoogleLogin), for: .touchUpInside)
//        appleButton.addTarget(self, action: #selector(handleAppleLogin), for: .touchUpInside)
//        registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
//        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
//
//        // Contenedor de botones
//        let buttonStack = UIStackView(arrangedSubviews: [googleButton, appleButton, registerButton, loginButton])
//        buttonStack.axis = .vertical
//        buttonStack.spacing = 10
//        buttonStack.alignment = .fill
//        buttonStack.distribution = .fillEqually
//        scrollView.addSubview(buttonStack)
//
//        // Pie de página
//        let termsLabel = createLabel(
//            text: "Al continuar, aceptas los Términos de servicio y la Política de privacidad de Buenos Aires.",
//            fontSize: 12,
//            weight: .regular,
//            textColor: UIColor(red: 0.28, green: 0.49, blue: 0.61, alpha: 1.0)
//        )
//        scrollView.addSubview(termsLabel)
//
//        // Constraints
//        headerStack.translatesAutoresizingMaskIntoConstraints = false
//        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
//        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
//        buttonStack.translatesAutoresizingMaskIntoConstraints = false
//        termsLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            headerStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
//            headerStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
//            headerStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
//
//            welcomeLabel.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 32),
//            welcomeLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
//
//            descriptionLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 8),
//            descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
//            descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
//
//            buttonStack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
//            buttonStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
//            buttonStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
//
//            termsLabel.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 16),
//            termsLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
//            termsLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16)
//        ])
//    }
//
//    private func backButton() -> UIButton {
//        let button = UIButton(type: .system)
//        let image = UIImage(systemName: "arrow.left")?.withRenderingMode(.alwaysTemplate)
//        button.setImage(image, for: .normal)
//        button.tintColor = UIColor.black
//        button.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
//        return button
//    }
//
//    private func titleLabel() -> UILabel {
//        let label = UILabel()
//        label.text = "Inicio de sesión"
//        label.font = UIFont.boldSystemFont(ofSize: 18)
//        label.textColor = UIColor.black
//        label.textAlignment = .center
//        return label
//    }
//
//    private func createLabel(text: String, fontSize: CGFloat, weight: UIFont.Weight, textColor: UIColor = .black) -> UILabel {
//        let label = UILabel()
//        label.text = text
//        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
//        label.textColor = textColor
//        label.numberOfLines = 0
//        label.textAlignment = .center
//        return label
//    }
//
//    private func createButton(title: String, bgColor: UIColor, textColor: UIColor = .black) -> UIButton {
//        let button = UIButton(type: .system)
//        button.setTitle(title, for: .normal)
//        button.backgroundColor = bgColor
//        button.setTitleColor(textColor, for: .normal)
//        button.layer.cornerRadius = 10
//        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
//        return button
//    }
//
//    // Acciones de los botones
//    @objc private func handleBackButton() {
//        navigationController?.popViewController(animated: true)
//    }
//
//    @objc private func handleGoogleLogin() {
//        print("Login con Google")
//    }
//
//    @objc private func handleAppleLogin() {
//        print("Login con Apple")
//    }
//
//    @objc private func handleRegister() {
//        print("Registrarse")
//    }
//
//    @objc private func handleLogin() {
//        print("Iniciar sesión")
//    }
//}



//#Preview("LoginViewController", traits: .defaultLayout, body: { LoginViewController()})


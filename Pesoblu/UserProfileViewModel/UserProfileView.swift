//
//  UserProfileView.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 06/04/2025.
//

import SwiftUI
import Kingfisher
import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct UserProfileView: View {
    
    @State private var isSignedIn: Bool = true
    @State private var errorMessage: String?
    
    // Estado para la moneda preferida y su edición
    @State private var preferredCurrency: String = "BR"
    @State private var isEditingCurrency: Bool = false
    private let currencyOptions = ["ARS", "USD", "BRL", "EUR"] // Opciones de monedas
    
    private let userProfileViewModel: UserProfileViewModelProtocol
    init(userProfileViewModel: UserProfileViewModelProtocol){
        self.userProfileViewModel = userProfileViewModel
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Foto de perfil
                if let user = userProfileViewModel.loadUser(){
                    KFImage.url(user.photoURL)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .foregroundColor(.blue)
                        .frame(width: 160, height: 160)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 3))
                        .padding(.top, 16) // Reducir padding superior para mover la foto más arriba
                    
                    // Espacio adicional entre la foto y los textos
                    Spacer()
                        .frame(height: 32)
                    
                    // Contenedor opaco para los textos
                    VStack(spacing: 12) {
                        HStack {
                            Text("Nombre: ")
                                .bold()
                            Text(user.displayName ?? "")
                            Spacer()
                        }
                        
                        HStack {
                            Text("Email: ")
                                .bold()
                            Text(user.email ?? "")
                            Spacer()
                        }
                        
                    }
                    .padding()
                    .background(Color.white.opacity(0.8)) // Fondo opaco
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
                    .padding(.horizontal, 16)
                    
                    // Sección de Moneda preferida (editable)
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Moneda preferida: ")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            
                            if isEditingCurrency {
                                Picker("Moneda", selection: $preferredCurrency) {
                                    ForEach(currencyOptions, id: \.self) { currency in
                                        Text(currency).tag(currency)
                                    }
                                }
                                .pickerStyle(.menu)
                                .onChange(of: preferredCurrency, initial: false) { oldValue, newValue in
                                    isEditingCurrency = false // Cerrar el picker al seleccionar una nueva moneda
                                }
                            } else {
                                Text(user.preferredCurrency ?? "")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                
                                Button(action: {
                                    isEditingCurrency = true
                                }) {
                                    Image(systemName: "pencil")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        
                        Text("Último acceso: 11")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white.opacity(0.8)) // Fondo opaco
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
                    .padding(.horizontal, 16)
                    .padding(.top, 32)
                    
                    // Botón "Cómprame un cafecito"
                    Link(destination: URL(string: "https://cafecito.app/danielcarcacha")!) {
                        Label("Invitame un Cafecito", image: "coffee") // Usar imagen desde assets
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue) // Fondo azul
                            .clipShape(RoundedRectangle(cornerRadius: 8)) // Aplicar cornerRadius al fondo
                            .padding(.top, 32)
                            .padding(.horizontal, 16)
                    }
                    
                    // Boton "Cerrar sesión"
                    Button(action: {
                        GIDSignIn.sharedInstance.signOut()
                        isSignedIn = false
                        
                        errorMessage = nil
                        
                        // Volver a la pantalla de login
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let window = windowScene.windows.first {
                            let loginVC = LoginViewController()
                            window.rootViewController = loginVC
                            window.makeKeyAndVisible()
                            
                            // Animación de transición
                            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
                        }
                    }) {
                        Text("Cerrar sesión")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 16)
                    
                    Spacer()
                }
            }
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let userProfileViewModel = UserProfileViewModel(userService: UserService())
            
        UserProfileView(userProfileViewModel: userProfileViewModel)
    }
}


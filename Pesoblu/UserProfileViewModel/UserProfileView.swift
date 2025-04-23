//
//  UserProfileView.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 06/04/2025.
//

import SwiftUI
import Kingfisher
import GoogleSignIn
import GoogleSignInSwift

enum CurrencyOptions: String, CaseIterable {
    case ARS = "Peso Argentino"
    case USD = "Dolar Americano"
    case BRL = "Real Brasileiro"
    case EUR = "Euro"
    case UYU = "Peso Uruguayo"
    case CLP = "Peso Chileno"
}

struct UserProfileView: View {
    private let userProfileViewModel: UserProfileViewModelProtocol
    
    @State private var state: UserProfileState = .loading
    @State private var preferredCurrency: String
    @State private var isEditingCurrency: Bool = false
    private let currencyOptions: [CurrencyOptions] = CurrencyOptions.allCases
    
    init(userProfileViewModel: UserProfileViewModelProtocol) {
        self.userProfileViewModel = userProfileViewModel
        self._preferredCurrency = State(initialValue: userProfileViewModel.preferredCurrency)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                switch state {
                case .loading:
                    Text("Cargando perfil...")
                        .foregroundColor(.gray)
                        .padding(.top, 32)
                    
                case .error(let message):
                    Text(message)
                        .foregroundColor(.red)
                        .padding(.top, 32)
                    
                case .loaded(let user):
                    // Foto de perfil
                    KFImage.url(user.photoURL)
                        .placeholder {
                            Image(systemName: "person.circle")
                                .resizable()
                                .foregroundColor(.blue)
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 160, height: 160)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 3))
                        .padding(.top, 16)
                    
                    // Espacio adicional entre la foto y los textos
                    Spacer()
                        .frame(height: 32)
                    
                    // Contenedor para Nombre y Email
                    VStack(spacing: 12) {
                        HStack {
                            Text("Nombre: ")
                                .bold()
                            Text(user.displayName ?? "Sin nombre")
                            Spacer()
                        }
                        
                        HStack {
                            Text("Email: ")
                                .bold()
                            Text(user.email ?? "Sin email")
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
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
                                        Text(currency.rawValue).tag(currency.rawValue)
                                    }
                                }
                                .pickerStyle(.menu)
                                .onChange(of: preferredCurrency) {oldValue, newValue in
                                    userProfileViewModel.savePreferredCurrency(newValue)
                                    isEditingCurrency = false
                                    // Actualizamos el estado para reflejar el cambio
                                    state = userProfileViewModel.getState()
                                }
                            } else {
                                Text(preferredCurrency)
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
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
                    .padding(.horizontal, 16)
                    .padding(.top, 32)
                    
                    // Botón "Invítame un Cafecito"
                    Link(destination: URL(string: "https://cafecito.app/danielcarcacha")!) {
                        Label("Invítame un Cafecito", image: "coffee")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(8)
                            .padding(.top, 32)
                            .padding(.horizontal, 16)
                    }
                    
                    // Botón "Cerrar sesión"
                    Button(action: {
                        userProfileViewModel.signOut()
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
        .background(Color(UIColor(hex: "F0F8FF")))
        .navigationTitle("Perfil")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            userProfileViewModel.loadUserData()
            state = userProfileViewModel.getState()
            preferredCurrency = userProfileViewModel.preferredCurrency//se sincroniza despues de cargar al user
        }
        .onChange(of: isEditingCurrency) {
            state = userProfileViewModel.getState()
            preferredCurrency = userProfileViewModel.preferredCurrency //sincronizamos despues de cambios
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let userService = UserService()
        let viewModel = UserProfileViewModel(userService: userService)
        UserProfileView(userProfileViewModel: viewModel)
    }
}

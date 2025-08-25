//
//  UserProfileView.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 06/04/2025.
//

import SwiftUI
import Kingfisher

/// A view that displays and manages the user's profile settings, including loading states, user info, and preferences.
struct UserProfileView: View {
    @ObservedObject var viewModel: UserProfileViewModel
    let onSignOut: () -> Void
    @State private var isEditingCurrency = false
    @State private var showToast = false
    
    var body: some View {
        ZStack { // Usamos ZStack para manejar el fondo y el toast por separado
            LinearGradient(
                colors: [
                    Color(red: 236/255, green: 244/255, blue: 255/255), // #ECF4FF
                    Color(red: 213/255, green: 229/255, blue: 252/255)  // #D5E5FC
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all) // Asegura que el fondo ocupe todo, incluso safe areas
            
            ScrollView {
                VStack(spacing: 0) {
                    switch viewModel.state {
                    case .loading:
                        Text(NSLocalizedString("profile_loading", comment: ""))
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
                                Text(NSLocalizedString("name_label", comment: ""))
                                    .bold()
                                Text(user.displayName ?? NSLocalizedString("no_name", comment: ""))
                                Spacer()
                            }
                            
                            HStack {
                                Text(NSLocalizedString("email_label", comment: ""))
                                    .bold()
                                Text(user.email ?? NSLocalizedString("no_email", comment: ""))
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
                                Text(NSLocalizedString("preferred_currency_label", comment: ""))
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                
                                if isEditingCurrency {
                                    Picker(NSLocalizedString("currency_picker_title", comment: ""), selection: $viewModel.preferredCurrency) {
                                        ForEach(CurrencyOptions.allCases, id: \.self) { currency in
                                            Text(currency.rawValue).tag(currency.rawValue)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    .onChange(of: viewModel.preferredCurrency) {
                                        viewModel.savePreferredCurrency(viewModel.preferredCurrency)
                                        isEditingCurrency = false
                                    }
                                } else {
                                    Text(viewModel.preferredCurrency)
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
                        }
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
                        .padding(.horizontal, 16)
                        .padding(.top, 32)
                        
                        // Botón "Invítame un Cafecito"
                        Link(destination: URL(string: "https://cafecito.app/danielcarcacha")!) {
                            Label(NSLocalizedString("invite_coffee_button", comment: ""), image: "coffee")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(8)
                                .padding(.top, 32)
                                .padding(.horizontal, 16)
                        }
                        
                        Button(action: {
                            viewModel.showSignOutAlert = true
                        }) {
                            Text(NSLocalizedString("sign_out_button", comment: ""))
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
                        
                        Spacer() // Empuja el contenido hacia arriba
                    }
                }
            }
            .overlay(toastView()) // El toast se superpone al ScrollView
            
        }
        .navigationTitle(NSLocalizedString("profile_title", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadUserData()
        }
        .onChange(of: viewModel.didSignOut) {
            
            showToast = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                
                onSignOut()
            }
            
        }
        .alert(NSLocalizedString("sign_out_confirm_message", comment: ""), isPresented: $viewModel.showSignOutAlert) {
            Button(NSLocalizedString("cancel_action", comment: ""), role: .cancel) { }
            Button(NSLocalizedString("sign_out_button", comment: ""), role: .destructive) {
                signOutConfirmed()
            }
        }
    }
}

extension UserProfileView {
    #if DEBUG
    // Para que el test pueda invocarlo con ViewInspector
    func signOutConfirmed() {
        viewModel.signOut()
    }
    #else
    private func signOutConfirmed() {
        viewModel.signOut()
    }
    #endif
    
    @ViewBuilder
    private func toastView() -> some View {
        if showToast {
            VStack {
                Spacer() // Centra verticalmente
                Text(NSLocalizedString("sign_out_success", comment: ""))
                    .font(.subheadline)
                    .fixedSize(horizontal: true, vertical: false) // Fuerza una sola línea
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.9))
                    .foregroundColor(.black) // Color actual, evaluaremos alternativas
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                    .padding(.bottom, 350)
                    .id("toastLabel")
                    .accessibilityIdentifier("toastLabel")
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    .animation(.easeInOut(duration: 0.3), value: showToast)
            }
            .frame(minWidth: 0, maxWidth: .infinity) // Ancho adaptable al contenido
            .background(Color.clear)
        }
    }
    
    enum CurrencyOptions: String, CaseIterable, Identifiable {
        var id: String { rawValue }
        case usd = "USD"
        case eur = "EUR"
        case gbp = "GBP"
    }
}

#Preview {
    UserProfileView(viewModel: UserProfileViewModel(userService: UserService()), onSignOut: {})
        .onAppear {}
}

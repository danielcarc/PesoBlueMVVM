//
//  UserProfileView.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 06/04/2025.
//
import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct UserProfileView: View {
    @State private var userName: String = "Daniel Carcacha"
    @State private var userEmail: String = "daniel@carcacha.com"
    @State private var loginMethod: String = "Google"
    @State private var isSignedIn: Bool = false
    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Encabezado
                VStack(spacing: 16) {
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .foregroundColor(.blue)
                        .frame(width: 125, height: 125)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 3))

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.system(size: 14))
                            .padding()
                    }

                    if isSignedIn {
                        HStack {
                            Text("Name: ")
                                .bold()
                            Text(userName)
                        }

                        HStack {
                            Text("Email: ")
                                .bold()
                            Text(userEmail)
                        }

                        HStack {
                            Text("Proveedor de Servicio: ")
                                .bold()
                            Text(loginMethod)
                        }
                    } else {
                        GoogleSignInButton(action: signInWithGoogle)
                            .frame(width: 200, height: 44)
                            .padding()
                    }
                }
                .padding(.top, 32)

                // Sección de información
                VStack(alignment: .leading, spacing: 8) {
                    Text("Moneda preferida: \("BR")")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                    Text("Último acceso: \("11")")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
                .padding(.horizontal, 16)
                .padding(.top, 24)

                if isSignedIn {
                    Button(action: {
                        GIDSignIn.sharedInstance.signOut()
                        isSignedIn = false
                        userName = "Daniel Carcacha"
                        userEmail = "daniel@carcacha.com"
                        errorMessage = nil
                    }) {
                        Text("Cerrar sesión")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.red)
                    }
                    .padding(.top, 16)
                }

                Spacer()
            }
        }
        .background(Color(.systemGray6))
        .ignoresSafeArea(edges: .bottom)
    }

    private func signInWithGoogle() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            errorMessage = "No se pudo obtener el rootViewController"
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                errorMessage = "Error al iniciar sesión: \(error.localizedDescription)"
                return
            }

            guard let user = result?.user else {
                errorMessage = "No se pudo obtener el usuario"
                return
            }

            userName = user.profile?.name ?? "Usuario"
            userEmail = user.profile?.email ?? "Sin email"
            loginMethod = "Google"
            isSignedIn = true
            errorMessage = nil
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UserProfileView()
        }
    }
}

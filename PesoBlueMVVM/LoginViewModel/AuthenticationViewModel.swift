//
//  AuthenticationViewModel.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 24/10/2024.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift


class AuthenticationViewModel{
    enum AuthenticationState {
      case unauthenticated
      case authenticating
      case authenticated
    }
    
}


//MARK: - Google Sign In

extension AuthenticationViewModel{
    
    enum AuthenticationError: Error{
        case tokenError(message: String)
    }
    
    enum AuthError: Error {
        case networkError
        case invalidCredentials
        case userCancelled
        case unknown
        
        var localizedDescription: String {
            switch self {
            case .networkError:
                return "No hay conexión a Internet."
            case .invalidCredentials:
                return "Las credenciales son inválidas."
            case .userCancelled:
                return "El usuario canceló el inicio de sesión."
            case .unknown:
                return "Ocurrió un error desconocido."
            }
        }
    }
    
    func singInWithGoogle() async throws -> Bool{
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No Client ID found in Firebase Configuration")
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            print("There is no root view controller")
            throw AuthError.unknown
            //return false
        }
        
        do{
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user =  userAuthentication.user
            guard let idToken = user.idToken else {
                throw AuthenticationError.tokenError(message: "Id token missing")
            }
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            //usamos la credencial para loguearnos en firebase, toma la credencial y devuelve un usuario de firebase
            let result = try await Auth.auth().signIn(with: credential)
            //Extraemos el usuario de result
            let firebaseUser = result.user
            print("User \(firebaseUser.uid) sign in with email \(firebaseUser.email ?? "unknown")")
            return true
        }
        catch let error as AuthError {
            print("AuthError: \(error.localizedDescription)")
            throw error
        } catch {
            print("Unexpected Error: \(error.localizedDescription)")
            throw AuthError.unknown
        }
        
    }
}


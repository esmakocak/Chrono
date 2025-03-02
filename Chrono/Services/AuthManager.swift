//
//  AuthManager.swift
//  Chrono
//
//  Created by Esma Koçak on 1.03.2025.
//

import Foundation
import FirebaseAuth

class AuthManager: ObservableObject {
    @Published var user: User?

    init() {
        self.user = Auth.auth().currentUser

        // Firebase Auth değişikliklerini dinle
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.user = user
            }
        }
    }

    // Kullanıcı Kayıt Olma
    func signUp(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(false, error.localizedDescription)
                } else {
                    self.user = result?.user
                    completion(true, nil)
                }
            }
        }
    }

    // Kullanıcı Giriş Yapma
    func signIn(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(false, error.localizedDescription)
                } else {
                    self.user = result?.user
                    completion(true, nil)
                }
            }
        }
    }

    // Kullanıcı Çıkış Yapma
    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.user = nil
            }
        } catch {
            print("Çıkış yapılamadı: \(error.localizedDescription)")
        }
    }
}

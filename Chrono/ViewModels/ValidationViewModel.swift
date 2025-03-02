//
//  ValidationViewModel.swift
//  Chrono
//
//  Created by Esma Koçak on 2.03.2025.
//

import Foundation
import SwiftUI

class ValidationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var emailError: String?
    @Published var passwordError: String?
    @Published var confirmPasswordError: String?

    func validateForm(isSignUp: Bool) -> Bool {
        // Hata mesajlarını sıfırla
        emailError = nil
        passwordError = nil
        confirmPasswordError = nil

        var isValid = true
        
        // **Email Doğrulama**
        if email.isEmpty {
            emailError = "Please fill out this field."
            isValid = false
        } else if !isValidEmail(email) {
            emailError = "Please enter a valid e-mail address."
            isValid = false
        }

        // **Şifre Doğrulama**
        if password.isEmpty {
            passwordError = "Please fill out this field."
            isValid = false
        } else if password.count < 6 {
            passwordError = "Password must be at least 6 characters."
            isValid = false
        }

        // **Şifre Tekrarı Doğrulama (Sadece Kayıt Olurken)**
        if isSignUp {
            if confirmPassword.isEmpty {
                confirmPasswordError = "Please fill out this field."
                isValid = false
            } else if password != confirmPassword {
                confirmPasswordError = "Passwords do not match!"
                isValid = false
            }
        }

        return isValid
    }

    /// **E-posta formatının geçerli olup olmadığını kontrol eder**
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}

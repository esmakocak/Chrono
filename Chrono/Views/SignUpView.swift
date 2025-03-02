//
//  SignUpView.swift
//  Chrono
//
//  Created by Esma Koçak on 27.01.2025.
//

import SwiftUI

struct SignUpView: View {
    @StateObject var authManager = AuthManager()
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color("BgColor")
                .ignoresSafeArea()
                .navigationBarBackButtonHidden()
            
            VStack(spacing: 15) {
                Spacer()
                
                Text("Create Account")
                    .font(.system(size: 25))
                    .fontWeight(.heavy)
                    .foregroundStyle(Color("Burgundy"))
                    .padding()
                    .padding(.leading, 10)
                    .padding(.bottom, 30)
                
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .bold()
                    .textFieldStyle(.plain)
                    .padding(.leading, 80)
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundStyle(Color("Burgundy"))
                    .padding(.bottom, 30)
                
                SecureField("Password", text: $password)
                    .bold()
                    .textFieldStyle(.plain)
                    .padding(.leading, 80)
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundStyle(Color("Burgundy"))
                    .padding(.bottom, 30)
                
                SecureField("Confirm Password", text: $password)
                    .bold()
                    .textFieldStyle(.plain)
                    .padding(.leading, 80)
                
                // Hata Mesajı
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundStyle(Color("Burgundy"))
                    .padding(.bottom, 20)
                
                
                // Kayıt Ol Butonu
                Button {
                    authManager.signUp(email: email, password: password) { success, error in
                        if success {
                            print("Kayıt başarılı!")
                        } else {
                            self.errorMessage = error
                        }
                    }
                } label: {
                    Text("Sign Up")
                        .font(.system(size: 25))
                        .fontWeight(.medium)
                        .foregroundColor(Color("BgColor"))
                        .frame(width: 240, height: 35)
                        .padding()
                        .background(Color("Burgundy"))
                        .cornerRadius(50)
                        .padding(.top, 5)
                }
                .padding()
                
                NavigationLink("Already have an account? Log in", destination: LoginView())
                    .fontWeight(.semibold)
                    .foregroundColor(Color("Burgundy"))
                
                Spacer()
            }
            .offset(y: -100)
            
            WaveShape()
                .fill(Color("Peachy").opacity(0.3))
                .frame(width: 500 , height: 225)
                .scaleEffect(x: -1) // Dalga ters çevrildi
                .offset(x: 130)
            
            WaveShape()
                .fill(Color("Pinky"))
                .frame(width: 500 , height: 225)
                .rotationEffect(.degrees(10))
            
            WaveShape()
                .fill(Color("Peachy"))
                .frame(height: 200)
                .rotationEffect(.degrees(5))
            
            WaveShape()
                .fill(Color("Burgundy"))
                .frame(height: 150)
        }
        .edgesIgnoringSafeArea(.bottom)
        
    }
}


#Preview {
    SignUpView()
}

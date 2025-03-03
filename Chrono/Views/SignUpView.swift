//
//  SignUpView.swift
//  Chrono
//
//  Created by Esma Koçak on 27.01.2025.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authManager: AuthManager
    @StateObject private var validationVM = ValidationViewModel()
    @State private var isLoading = false
    
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
                
                TextField("Email", text: $validationVM.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .bold()
                    .textFieldStyle(.plain)
                    .padding(.leading, 80)
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundStyle(Color("Burgundy"))
                
                Text(validationVM.emailError ?? " ")
                         .foregroundColor(.red)
                         .font(.caption)
                         .frame(height: 15)
                         .padding(.leading, 80)
                         .frame(maxWidth: .infinity, alignment: .leading)

                SecureField("Password", text: $validationVM.password)
                    .bold()
                    .textFieldStyle(.plain)
                    .padding(.leading, 80)
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundStyle(Color("Burgundy"))
                
                Text(validationVM.passwordError ?? " ")
                         .foregroundColor(.red)
                         .font(.caption)
                         .frame(height: 15)
                         .padding(.leading, 80)
                         .frame(maxWidth: .infinity, alignment: .leading)
                
                SecureField("Confirm Password", text: $validationVM.confirmPassword)
                    .bold()
                    .textFieldStyle(.plain)
                    .padding(.leading, 80)

                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundStyle(Color("Burgundy"))
                
                Text(validationVM.confirmPasswordError ?? " ")
                         .foregroundColor(.red)
                         .font(.caption)
                         .frame(height: 15)
                         .padding(.leading, 80)
                         .frame(maxWidth: .infinity, alignment: .leading)
                
                Button {
                    if validationVM.validateForm(isSignUp: true) {
                        isLoading = true
                        authManager.signUp(email: validationVM.email, password: validationVM.password) { success, error in
                            DispatchQueue.main.async {
                                isLoading = false
                                if !success {
                                    validationVM.emailError = error 
                                }
                            }
                        }
                    }
                } label: {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(width: 240, height: 35)
                            .padding()
                            .background(Color("Burgundy").opacity(0.6))
                            .cornerRadius(50)
                    } else {
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
                }
                .disabled(isLoading)
                .padding()
                
                NavigationLink("Already have an account? Log in", destination: LoginView())
                    .fontWeight(.semibold)
                    .foregroundColor(Color("Burgundy"))
                
                Spacer()
            }
            .offset(y: -80)
            
            WaveShape()
                .fill(Color("Peachy").opacity(0.3))
                .frame(width: 500 , height: 225)
                .scaleEffect(x: -1)
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

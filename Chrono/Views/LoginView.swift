//
//  LoginView.swift
//  Chrono
//
//  Created by Esma Koçak on 1.02.2025.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authManager: AuthManager
    @StateObject private var validationVM = ValidationViewModel()
    @State private var isLoading = false
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            Color("BgColor")
                .ignoresSafeArea()
                .navigationBarBackButtonHidden()
            
            VStack {
                
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .foregroundStyle(Color("Burgundy"))
                            .font(.system(size: 25))
                    }
                    .padding(.leading, 20)
                    .padding(.top, 10)
                    Spacer()
                }
                
                Spacer()
                
                VStack(spacing: 15) {
                    Text("Log In to Your Account")
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
                        .padding(.leading, 30)
                    
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundStyle(Color("Burgundy"))
                    
                    Text(validationVM.emailError ?? " ")
                             .foregroundColor(.red)
                             .font(.caption)
                             .frame(height: 15)
                             .padding(.leading,30)
                             .frame(maxWidth: .infinity, alignment: .leading)
                    
                    SecureField("Password", text: $validationVM.password)
                        .bold()
                        .textFieldStyle(.plain)
                        .padding(.leading, 30)
                    
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundStyle(Color("Burgundy"))
                    
                    Text(validationVM.passwordError ?? " ")
                             .foregroundColor(.red)
                             .font(.caption)
                             .frame(height: 15)
                             .padding(.leading,30)
                             .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Spacer()
                        Button {
                            print("Şifremi unuttum tıklandı")
                        } label: {
                            Text("Forget password")
                                .fontWeight(.semibold)
                                .foregroundColor(Color("Burgundy"))
                        }
                        .padding(.trailing, 30)
                        .padding(.bottom, 30)
                    }
                    
                    // MARK: Log In Button
                    Button {
                        if validationVM.validateForm(isSignUp: false) {
                            isLoading = true
                            authManager.signIn(email: validationVM.email, password: validationVM.password) { success, error in
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
                            Text("Log In")
                                .font(.system(size: 25))
                                .fontWeight(.medium)
                                .foregroundColor(Color("BgColor"))
                                .frame(width: 240, height: 35)
                                .padding()
                                .background(Color("Burgundy"))
                                .cornerRadius(50)
                        }
                    }
                    .disabled(isLoading)
                }
                .offset(y: -100)
                
                Spacer()
            }
            .padding()
            .padding(.horizontal,30)
            
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
    LoginView()
}

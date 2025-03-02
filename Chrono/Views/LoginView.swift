//
//  LoginView.swift
//  Chrono
//
//  Created by Esma Koçak on 1.02.2025.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var authManager = AuthManager()
    @State var email = ""
    @State var password = ""
    @State private var errorMessage: String?
    @State private var isAuthenticated = false
    
    var body: some View {
        
        NavigationStack {
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

                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .bold()
                            .textFieldStyle(.plain)
                            .padding(.leading, 30)

                        Rectangle()
                            .frame(width: 350, height: 1)
                            .foregroundStyle(Color("Burgundy"))
                            .padding(.bottom, 30)

                        SecureField("Password", text: $password)
                            .bold()
                            .textFieldStyle(.plain)
                            .padding(.leading, 30)

                        // Hata Mesajı
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                        }

                        Rectangle()
                            .frame(width: 350, height: 1)
                            .foregroundStyle(Color("Burgundy"))

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
                            authManager.signIn(email: email, password: password) { success, error in
                                if success {
                                    print("Giriş başarılı!")
                                    isAuthenticated = true
                                } else {
                                    self.errorMessage = error
                                }
                            }
                        } label: {
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
                    .offset(y: -100)

                    Spacer()
                }
                .navigationDestination(isPresented: $isAuthenticated) {
                    MainTaskView() // Kullanıcı giriş yapınca buraya yönlenecek
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
}

#Preview {
    LoginView()
}

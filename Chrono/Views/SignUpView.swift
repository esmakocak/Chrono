//
//  SignUpView.swift
//  Chrono
//
//  Created by Esma Koçak on 27.01.2025.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            Color("BgColor")
                .ignoresSafeArea()
                .navigationBarBackButtonHidden()
            
            VStack(spacing: 40) {
                // MARK: Back Button (Chevron)
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .foregroundStyle(Color("Burgundy"))
                            .font(.system(size: 25))
                    }
                    .padding(.leading, 20)
                    .padding(.top, 40)
                    
                    Spacer()
                }
                
                
                Text("Create Account")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundStyle(Color("Burgundy"))
                    .padding()
                
                
                VStack(spacing: 20) {
                    TextField("Email", text: $email)
                        .bold()
                        .textFieldStyle(.plain)
                        .padding(.leading, 30)
                    
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundStyle(Color("Burgundy"))
                    
                    SecureField("Password", text: $password)
                        .bold()
                        .textFieldStyle(.plain)
                        .padding(.leading, 30)
                    
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundStyle(Color("Burgundy"))
                }
                
                
                // MARK: Sign Up Button
                NavigationLink{
                    Text("sa")
                } label: {
                    Text("Sign Up")
                        .font(.system(size: 25))
                        .fontWeight(.medium)
                        .foregroundColor(Color("BgColor"))
                        .frame(width: 260, height: 40)
                        .padding()
                    
                        .background(Color("Burgundy"))
                        .cornerRadius(50)
                }
                
                Text("Already have an account? Log in")
                    .fontWeight(.semibold)
                    .foregroundColor(Color("Burgundy"))
                
                
                Spacer()
                
            }
        }
    }
}


#Preview {
    SignUpView()
}

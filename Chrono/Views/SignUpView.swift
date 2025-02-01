//
//  SignUpView.swift
//  Chrono
//
//  Created by Esma Koçak on 27.01.2025.
//

import SwiftUI

struct SignUpView: View {
    @State var username = ""
    @State var email = ""
    @State var password = ""

    
    var body: some View {
        ZStack {
            Color("BgColor")
                .ignoresSafeArea()
                .navigationBarBackButtonHidden()
            
            VStack(spacing: 40) {
                
                Spacer()
                
                Text("Create Account")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundStyle(Color("Burgundy"))
                    .padding()
                
                VStack(spacing: 20) {
                    TextField("Name", text: $username)
                        .bold()
                        .textFieldStyle(.plain)
                        .padding(.leading, 30)
                    
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundStyle(Color("Burgundy"))
                    
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
                Button {
                    
                } label: {
                    Text("Sign In")
                        .font(.system(size: 25))
                        .fontWeight(.medium)
                        .foregroundColor(Color("BgColor"))
                        .frame(width: 260, height: 40)
                        .padding()
                    
                        .background(Color("Burgundy"))
                        .cornerRadius(50)
                }
                
                NavigationLink("Already have an account? Log in", destination: LoginView())
                    .fontWeight(.semibold)
                    .foregroundColor(Color("Burgundy"))
                
                
                Spacer()
                
            }
            .offset(y: -60)
        }
    }
}


#Preview {
    SignUpView()
}

//
//  LoginView.swift
//  Chrono
//
//  Created by Esma Koçak on 1.02.2025.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        
        ZStack {
            Color("BgColor")
                .ignoresSafeArea()
                .navigationBarBackButtonHidden()
            
            
            VStack(spacing: 20) {
                
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
                    .padding(.top, 80)
                    
                    Spacer()
                }
                
                
                HStack {
                    Text("Log In")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundStyle(Color("Burgundy"))
                        .padding()
                        .padding(.leading, 10)
                    Spacer()
                }
                
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
                
                // MARK: Sign Up Button
                Button {
                    
                } label: {
                    Text("Log In")
                        .font(.system(size: 25))
                        .fontWeight(.medium)
                        .foregroundColor(Color("BgColor"))
                        .frame(width: 260, height: 40)
                        .padding()
                    
                        .background(Color("Burgundy"))
                        .cornerRadius(50)
                }
                
                Spacer()
            }
        }
        .offset(y: -60)
        
    }
}

#Preview {
    LoginView()
}

//
//  WelcomeView.swift
//  Chrono
//
//  Created by Esma Koçak on 27.01.2025.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color("BgColor")
                    .ignoresSafeArea()
                
                VStack{
                    Spacer()

                    // MARK: Welcome Text
                    VStack(alignment: .leading) {
                        Group {
                            Text("Welcome to")
                                .fontWeight(.medium)
                            Text("Chrono.")
                                .fontWeight(.heavy)
                        }
                        .foregroundStyle(Color("Burgundy"))
                        .font(.largeTitle)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 70)
                    
                    Spacer()
                    
                    // MARK: Image
                    Image("welcomeIllustration")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 450)
                    
                    // MARK: Description
                    Text("""
                        Get things done, one task at a time.
                        Set your time interval and start!
                        """) .multilineTextAlignment(.center)
                        .foregroundStyle(Color("Burgundy"))
                        .font(.system(size: 15))
                        .padding(.top)
                    
                    Spacer()

                    // MARK: Get Started Button
                    NavigationLink{
                        SignUpView()
                    } label: {
                        Text("Get Started")
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
        }
    }
}

#Preview {
    WelcomeView()
}

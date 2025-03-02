//
//  MainTaskView.swift
//  Chrono
//
//  Created by Esma Koçak on 1.03.2025.
//

import SwiftUI

struct MainTaskView: View {
    var body: some View {
        
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Hoşgeldin")
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
            
            
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
    MainTaskView()
}

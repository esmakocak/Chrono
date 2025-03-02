//
//  WaveShape.swift
//  Chrono
//
//  Created by Esma Koçak on 2.03.2025.
//

import Foundation
import SwiftUI

struct WaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            
            path.addQuadCurve(
                to: CGPoint(x: rect.midX, y: rect.midY),
                control: CGPoint(x: rect.width * 0.25, y: rect.height * 0.25))
            
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX, y: rect.midY),
                control: CGPoint(x: rect.width * 0.75, y: rect.height * 0.75))
            
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY) )
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY) )
        }
    }
}

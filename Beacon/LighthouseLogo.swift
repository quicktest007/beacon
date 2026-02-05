//
//  LighthouseLogo.swift
//  Beacon
//
//  Created by JD Hadley on 1/15/26.
//

import SwiftUI

struct LighthouseLogo: View {
    var size: CGFloat = 50
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Conical roof
                Triangle()
                    .fill(Color.white)
                    .frame(width: size * 0.35, height: size * 0.15)
                    .overlay(
                        Triangle()
                            .stroke(Color(red: 0.3, green: 0.3, blue: 0.35), lineWidth: size * 0.01)
                    )
                    .offset(y: -size * 0.05)
                
                // Main cylindrical tower (slightly wider at bottom)
                ZStack {
                    // Tower body (trapezoid for slight taper)
                    Trapezoid()
                        .fill(Color.white)
                        .frame(width: size * 0.4, height: size * 0.5)
                        .overlay(
                            Trapezoid()
                                .stroke(Color(red: 0.3, green: 0.3, blue: 0.35), lineWidth: size * 0.01)
                        )
                    
                    // Door at bottom of tower
                    RoundedRectangle(cornerRadius: size * 0.01)
                        .fill(Color(red: 0.3, green: 0.3, blue: 0.35))
                        .frame(width: size * 0.1, height: size * 0.12)
                        .offset(y: size * 0.15)
                    
                    // Two horizontal accent bands
                    // First band near bottom
                    Rectangle()
                        .fill(Color(red: 0.3, green: 0.3, blue: 0.35))
                        .frame(width: size * 0.4, height: size * 0.006)
                        .offset(y: size * 0.08)
                    
                    // Second band above midpoint
                    Rectangle()
                        .fill(Color(red: 0.3, green: 0.3, blue: 0.35))
                        .frame(width: size * 0.4, height: size * 0.006)
                        .offset(y: -size * 0.05)
                }
                
                // Rectangular base
                RoundedRectangle(cornerRadius: size * 0.01)
                    .fill(Color.white)
                    .frame(width: size * 0.5, height: size * 0.1)
                    .overlay(
                        RoundedRectangle(cornerRadius: size * 0.01)
                            .stroke(Color(red: 0.3, green: 0.3, blue: 0.35), lineWidth: size * 0.01)
                    )
                    .offset(y: size * 0.05)
            }
            
            // Small light glow at apex
            Circle()
                .fill(Color(red: 1.0, green: 0.98, blue: 0.7))
                .frame(width: size * 0.08, height: size * 0.08)
                .offset(y: -size * 0.42)
        }
        .frame(width: size, height: size)
    }
}

// Custom shapes for lighthouse
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct Trapezoid: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let topWidth = rect.width * 0.7
        let bottomWidth = rect.width
        
        path.move(to: CGPoint(x: rect.midX - topWidth / 2, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX + topWidth / 2, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX + bottomWidth / 2, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX - bottomWidth / 2, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    ZStack {
        Circle()
            .fill(
                LinearGradient(
                    colors: [
                        Color(red: 1.0, green: 0.7, blue: 0.2),
                        Color(red: 1.0, green: 0.9, blue: 0.4)
                    ],
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
            .frame(width: 100, height: 100)
        
        LighthouseLogo(size: 70)
    }
    .padding()
}

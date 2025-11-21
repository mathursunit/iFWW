//
//  ConfettiView.swift
//  SunSar
//
//  Confetti animation for win state
//

import SwiftUI

struct ConfettiView: View {
    @State private var animate = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<50, id: \.self) { index in
                    ConfettiPiece()
                        .offset(
                            x: animate ? CGFloat.random(in: -geometry.size.width/2...geometry.size.width/2) : 0,
                            y: animate ? geometry.size.height + 100 : -100
                        )
                        .animation(
                            .easeOut(duration: Double.random(in: 0.8...1.2))
                            .delay(Double.random(in: 0...0.5)),
                            value: animate
                        )
                }
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct ConfettiPiece: View {
    let colors: [Color] = [.tileCorrect, .tilePresent, .logoYellow, .logoBlue, .white]
    let color = Color.tileCorrect
    
    var body: some View {
        Rectangle()
            .fill(colors.randomElement() ?? .tileCorrect)
            .frame(width: 8, height: 8)
            .rotationEffect(.degrees(Double.random(in: 0...360)))
    }
}


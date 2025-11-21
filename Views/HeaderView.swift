//
//  HeaderView.swift
//  SunSar
//
//  Header with logo and buttons
//

import SwiftUI

struct HeaderView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { viewModel.showStatsModal = true }) {
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color.appText.opacity(0.8))
                        .frame(width: 44, height: 44)
                        .background(Color.panelBackground.opacity(0.6))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                VStack(spacing: 2) {
                    HStack(spacing: 8) {
                        HStack(spacing: 2) {
                            Text("Sun")
                                .foregroundColor(.logoYellow)
                            Text("Sar")
                                .foregroundColor(.logoBlue)
                        }
                        .font(.custom("FredokaOne-Regular", size: 24))
                        .tracking(0.5)
                        
                        Image(systemName: "sun.max.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.logoYellow)
                            .rotationEffect(.degrees(viewModel.now.timeIntervalSince1970.truncatingRemainder(dividingBy: 8) * 45))
                            .animation(.linear(duration: 8).repeatForever(autoreverses: false), value: viewModel.now)
                    }
                    
                    Text("FUN WITH WORDS")
                        .font(.system(size: 10, weight: .medium))
                        .tracking(4.48)
                        .foregroundColor(Color.appText.opacity(0.6))
                }
                
                Spacer()
                
                Button(action: { viewModel.useHint() }) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 20))
                        .foregroundColor(viewModel.gameState.usedHint ? Color.logoYellow.opacity(0.4) : Color.logoYellow)
                        .frame(width: 44, height: 44)
                        .background(Color.panelBackground.opacity(0.6))
                        .clipShape(Circle())
                }
                .disabled(viewModel.gameState.usedHint)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.panelBackground)
            
            HStack {
                Spacer()
                Text("SunSar · v2.0")
                    .font(.system(size: 12))
                    .foregroundColor(Color.appText.opacity(0.6))
                    .padding(.trailing, 16)
                    .padding(.bottom, 8)
            }
        }
    }
}


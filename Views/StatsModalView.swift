//
//  StatsModalView.swift
//  SunSar
//
//  Statistics modal
//

import SwiftUI

struct StatsModalView: View {
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ModalView {
            VStack(spacing: 24) {
                Text("Statistics")
                    .font(.system(size: 18, weight: .semibold))
                    .tracking(0.5)
                
                HStack(spacing: 12) {
                    StatItem(title: "Played", value: "\(viewModel.stats.played)")
                    StatItem(title: "Won", value: "\(viewModel.stats.wins)")
                    StatItem(title: "Streak", value: "\(viewModel.stats.streak)")
                    StatItem(title: "Max Streak", value: "\(viewModel.stats.maxStreak)")
                }
                
                Button(action: { dismiss() }) {
                    Text("Close")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color.tileAbsent)
                        .cornerRadius(8)
                }
            }
            .padding(24)
        }
    }
}

struct StatItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 24, weight: .bold))
            Text(title.uppercased())
                .font(.system(size: 10))
                .tracking(1.2)
                .foregroundColor(Color.appText.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }
}


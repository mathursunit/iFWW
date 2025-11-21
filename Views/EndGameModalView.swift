//
//  EndGameModalView.swift
//  SunSar
//
//  End game modal
//

import SwiftUI

struct EndGameModalView: View {
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ModalView {
            VStack(spacing: 16) {
                Text(viewModel.gameState.isWin ? "Congratulations!" : "Nice Try!")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(viewModel.gameState.isWin ? Color.tileCorrect.opacity(0.8) : Color.appText)
                
                Text(viewModel.gameState.isWin ? "You guessed the word correctly." : "Better luck next time!")
                    .font(.system(size: 14))
                    .foregroundColor(Color.appText.opacity(0.7))
                
                if !viewModel.gameState.isWin {
                    Text("The word was: \(viewModel.gameState.solution)")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color.appText)
                        .padding(.top, 8)
                }
                
                Divider()
                    .background(Color.tileAbsent)
                    .padding(.vertical, 8)
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("NEXT WORD IN")
                            .font(.system(size: 10))
                            .tracking(2.88)
                            .foregroundColor(Color.appText.opacity(0.6))
                        Text(viewModel.formatTime(viewModel.nextWordTime()))
                            .font(.system(size: 24, weight: .bold))
                            .tracking(0.5)
                    }
                    Spacer()
                }
                
                Button(action: {
                    viewModel.shareResults()
                }) {
                    Text("Share Results")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color.tileCorrect)
                        .cornerRadius(8)
                        .shadow(color: Color.tileCorrect.opacity(0.4), radius: 8, x: 0, y: 4)
                }
                .padding(.top, 8)
            }
            .padding(24)
        }
    }
}

struct ModalView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            Color.modalBackdrop
                .ignoresSafeArea()
                .onTapGesture {
                }
            
            VStack {
                Spacer()
                
                content
                    .background(Color.modalBackground)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.65), radius: 25, x: 0, y: 12)
                    .padding(.horizontal, 20)
                
                Spacer()
            }
        }
    }
}


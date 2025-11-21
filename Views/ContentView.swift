//
//  ContentView.swift
//  SunSar
//
//  Main content view
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HeaderView(viewModel: viewModel)
                
                ScrollView {
                    VStack(spacing: 24) {
                        GameGridView(viewModel: viewModel)
                            .padding(.top, 24)
                        
                        KeyboardView(viewModel: viewModel)
                            .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 16)
                }
            }
            
            if let toast = viewModel.toastMessage {
                VStack {
                    ToastView(message: toast)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    Spacer()
                }
            }
            
            if viewModel.gameState.isWin && viewModel.gameState.isComplete {
                ConfettiView()
                    .allowsHitTesting(false)
            }
        }
        .sheet(isPresented: $viewModel.showStatsModal) {
            StatsModalView(viewModel: viewModel)
        }
        .sheet(isPresented: $viewModel.showEndModal) {
            EndGameModalView(viewModel: viewModel)
        }
        .onAppear {
            setupKeyboardHandling()
        }
    }
    
    private func setupKeyboardHandling() {
        // Keyboard input is handled through the virtual keyboard
        // Physical keyboard support can be added here if needed
    }
    }
}


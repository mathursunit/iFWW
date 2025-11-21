//
//  GameGridView.swift
//  SunSar
//
//  Game grid with tiles
//

import SwiftUI

struct GameGridView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<viewModel.maxGuesses, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(0..<viewModel.wordLength, id: \.self) { col in
                        TileView(
                            letter: letterForTile(row: row, col: col),
                            status: statusForTile(row: row, col: col),
                            shouldFlip: shouldFlip(row: row, col: col)
                        )
                    }
                }
            }
        }
        .frame(maxWidth: min(420, UIScreen.main.bounds.width * 0.92))
    }
    
    private func letterForTile(row: Int, col: Int) -> String {
        if row < viewModel.gameState.guesses.count {
            let guess = viewModel.gameState.guesses[row]
            if col < guess.count {
                return String(guess[guess.index(guess.startIndex, offsetBy: col)])
            }
        } else if row == viewModel.gameState.guesses.count {
            if col < viewModel.currentGuess.count {
                return String(viewModel.currentGuess[viewModel.currentGuess.index(viewModel.currentGuess.startIndex, offsetBy: col)])
            }
        }
        return ""
    }
    
    private func statusForTile(row: Int, col: Int) -> TileStatus {
        if row < viewModel.gameState.guesses.count {
            let guess = viewModel.gameState.guesses[row]
            let statuses = WordListManager.shared.evaluateGuess(guess, viewModel.gameState.solution)
            if col < statuses.count {
                return statuses[col]
            }
        } else if row == viewModel.gameState.guesses.count && !viewModel.currentGuess.isEmpty {
            if col < viewModel.currentGuess.count {
                return .editing
            }
        }
        return .empty
    }
    
    private func shouldFlip(row: Int, col: Int) -> Bool {
        return row == viewModel.gameState.guesses.count - 1 &&
               col <= viewModel.revealIndex &&
               viewModel.revealIndex >= 0
    }
}

struct TileView: View {
    let letter: String
    let status: TileStatus
    let shouldFlip: Bool
    
    @State private var flipAngle: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(borderColor, lineWidth: 1)
                    )
                
                Text(letter)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(textColor)
                    .textCase(.uppercase)
            }
            .rotation3DEffect(
                .degrees(flipAngle),
                axis: (x: 1, y: 0, z: 0),
                perspective: 0.5
            )
            .onChange(of: shouldFlip) { newValue in
                if newValue && flipAngle == 0 {
                    // Flip animation: 0 -> -90 -> 0 (550ms total, matches web)
                    withAnimation(.easeInOut(duration: 0.275)) {
                        flipAngle = -90
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.275) {
                        withAnimation(.easeInOut(duration: 0.275)) {
                            flipAngle = 0
                        }
                    }
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    private var backgroundColor: Color {
        switch status {
        case .correct:
            return .tileCorrect
        case .present:
            return .tilePresent
        case .absent:
            return .tileAbsent
        case .editing:
            return Color.clear
        case .empty:
            return Color.clear
        }
    }
    
    private var borderColor: Color {
        switch status {
        case .editing:
            return .tileEditingBorder
        case .correct, .present, .absent:
            return backgroundColor
        case .empty:
            return .tileBorder
        }
    }
    
    private var textColor: Color {
        switch status {
        case .present:
            return .tilePresentText
        case .absent:
            return .tileAbsentText
        default:
            return .white
        }
    }
}


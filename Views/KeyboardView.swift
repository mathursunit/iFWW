//
//  KeyboardView.swift
//  SunSar
//
//  Virtual keyboard
//

import SwiftUI

struct KeyboardView: View {
    @ObservedObject var viewModel: GameViewModel
    
    private let keyboardRows = [
        ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
        ["ENTER", "Z", "X", "C", "V", "B", "N", "M", "BACK"]
    ]
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<keyboardRows.count, id: \.self) { rowIndex in
                HStack(spacing: 6) {
                    ForEach(keyboardRows[rowIndex], id: \.self) { key in
                        KeyboardKeyView(
                            key: key,
                            status: keyStatus(for: key),
                            isSpecial: key == "ENTER" || key == "BACK",
                            action: { viewModel.onKeyPress(key) }
                        )
                        .frame(maxWidth: key == "ENTER" || key == "BACK" ? nil : .infinity)
                    }
                }
            }
        }
        .frame(maxWidth: min(420, UIScreen.main.bounds.width * 0.92))
    }
    
    private func keyStatus(for key: String) -> KeyStatus {
        guard key.count == 1, let char = key.first else {
            return .normal
        }
        return viewModel.keyboardStatuses[char] ?? .normal
    }
}

struct KeyboardKeyView: View {
    let key: String
    let status: KeyStatus
    let isSpecial: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(key == "BACK" ? "⌫" : key)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(backgroundColor)
                .cornerRadius(6)
        }
        .buttonStyle(KeyboardKeyStyle())
    }
    
    private var backgroundColor: Color {
        switch status {
        case .correct:
            return .tileCorrect
        case .present:
            return .tilePresent
        case .absent:
            return .tileAbsent
        case .normal:
            return .keyBackground
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

struct KeyboardKeyStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}


//
//  GameViewModel.swift
//  SunSar
//
//  Game view model
//

import Foundation
import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    @Published var gameState: GameState
    @Published var currentGuess: String = ""
    @Published var revealIndex: Int = -1
    @Published var stats: GameStats
    @Published var showStatsModal: Bool = false
    @Published var showEndModal: Bool = false
    @Published var toastMessage: String?
    @Published var now: Date = Date()
    
    private let wordManager = WordListManager.shared
    private let storageManager = StorageManager.self
    private var cancellables = Set<AnyCancellable>()
    private var timer: Timer?
    
    let today: (solution: String, hint: String, gameDateId: String)
    let maxGuesses = 5
    let wordLength = 5
    
    init() {
        today = wordManager.getTodayGame()
        
        // Load saved game state
        if let saved = storageManager.loadGameState(for: today.gameDateId) {
            gameState = saved
        } else {
            gameState = GameState(
                solution: today.solution,
                hint: today.hint,
                gameDateId: today.gameDateId,
                guesses: [],
                usedHint: false,
                isComplete: false,
                isWin: false
            )
        }
        
        stats = storageManager.loadStats()
        showEndModal = gameState.isComplete
        
        // Timer for next word countdown
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.now = Date()
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    var gameOver: Bool {
        gameState.isComplete
    }
    
    var keyboardStatuses: [Character: KeyStatus] {
        var statuses: [Character: KeyStatus] = [:]
        for guess in gameState.guesses {
            let tileStatuses = wordManager.evaluateGuess(guess, gameState.solution)
            for (index, char) in guess.enumerated() {
                let tileStatus = tileStatuses[index]
                let keyStatus: KeyStatus
                switch tileStatus {
                case .correct:
                    keyStatus = .correct
                case .present:
                    keyStatus = .present
                case .absent:
                    keyStatus = .absent
                default:
                    continue
                }
                
                // Only update if better status
                if let existing = statuses[char] {
                    if existing == .absent && keyStatus != .absent {
                        statuses[char] = keyStatus
                    } else if existing == .present && keyStatus == .correct {
                        statuses[char] = keyStatus
                    }
                } else {
                    statuses[char] = keyStatus
                }
            }
        }
        return statuses
    }
    
    func onKeyPress(_ key: String) {
        guard !gameOver else { return }
        
        if key == "ENTER" {
            submitGuess()
            return
        }
        
        if key == "BACK" {
            if !currentGuess.isEmpty {
                currentGuess.removeLast()
            }
            return
        }
        
        if key.count == 1 && currentGuess.count < wordLength {
            currentGuess += key.uppercased()
        }
    }
    
    func submitGuess() {
        let guess = currentGuess
        guard guess.count == wordLength else {
            showToast("Not enough letters")
            return
        }
        
        guard wordManager.isValidWord(guess) else {
            showToast("Not in word list")
            return
        }
        
        var newGuesses = gameState.guesses
        newGuesses.append(guess)
        currentGuess = ""
        revealIndex = -1
        
        let statuses = wordManager.evaluateGuess(guess, gameState.solution)
        
        // Animate reveal
        for (index, _) in statuses.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.15) { [weak self] in
                self?.revealIndex = index
            }
        }
        
        let isWin = guess == gameState.solution
        let isComplete = isWin || newGuesses.count >= maxGuesses
        
        gameState.guesses = newGuesses
        gameState.isComplete = isComplete
        gameState.isWin = isWin
        
        storageManager.saveGameState(gameState)
        
        if isComplete {
            updateStats(isWin: isWin)
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(wordLength) * 0.15 + 0.25) { [weak self] in
                self?.showEndModal = true
                // Trigger confetti for win
                if isWin {
                    // Confetti is handled in ContentView
                }
            }
        }
    }
    
    func updateStats(isWin: Bool) {
        stats.played += 1
        if isWin {
            stats.wins += 1
            stats.streak += 1
            if stats.streak > stats.maxStreak {
                stats.maxStreak = stats.streak
            }
        } else {
            stats.streak = 0
        }
        storageManager.saveStats(stats)
    }
    
    func useHint() {
        guard !gameState.usedHint else { return }
        showToast(gameState.hint.isEmpty ? "No hint available" : gameState.hint, duration: 4.0)
        gameState.usedHint = true
        storageManager.saveGameState(gameState)
    }
    
    func showToast(_ message: String, duration: Double = 2.0) {
        toastMessage = message
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.toastMessage = nil
        }
    }
    
    func shareResults() {
        guard gameState.isComplete else {
            showToast("Finish the game to share")
            return
        }
        
        let dateStr = today.gameDateId
        let score = gameState.isWin ? "\(gameState.guesses.count)/\(maxGuesses)" : "X/\(maxGuesses)"
        var lines: [String] = []
        
        for guess in gameState.guesses {
            let statuses = wordManager.evaluateGuess(guess, gameState.solution)
            let row = statuses.map { status in
                switch status {
                case .correct: return "🟪"
                case .present: return "💠"
                default: return "⬛"
                }
            }.joined()
            lines.append(row)
        }
        
        let text = "SunSar \(dateStr)\n\(score)\n\(lines.joined(separator: "\n"))"
        
        UIPasteboard.general.string = text
        showToast("Copied to clipboard!")
    }
    
    func nextWordTime() -> TimeInterval {
        let calendar = Calendar.current
        var target = calendar.startOfDay(for: now)
        if calendar.component(.hour, from: now) >= 8 {
            target = calendar.date(byAdding: .day, value: 1, to: target) ?? target
        }
        target = calendar.date(bySettingHour: 8, minute: 0, second: 0, of: target) ?? target
        return target.timeIntervalSince(now)
    }
    
    func formatTime(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        let seconds = Int(interval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}


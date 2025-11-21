//
//  WordListManager.swift
//  SunSar
//
//  Manages word list and validation
//

import Foundation

class WordListManager {
    static let shared = WordListManager()
    
    private var wordEntries: [WordEntry] = []
    private var validWords: Set<String> = []
    
    private init() {
        loadWords()
    }
    
    private func loadWords() {
        // Parse the word list
        let wordCSV = WordListData.wordCSV
        let lines = wordCSV.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)
        
        wordEntries = lines.compactMap { line in
            let parts = line.components(separatedBy: ",")
            guard parts.count >= 2 else { return nil }
            let word = parts[0].trimmingCharacters(in: .whitespaces).uppercased()
            let hint = parts.dropFirst().joined(separator: ",").trimmingCharacters(in: .whitespaces)
            guard word.count == 5 else { return nil }
            return WordEntry(word: word, hint: hint)
        }
        
        validWords = Set(wordEntries.map { $0.word })
    }
    
    func getTodayGame() -> (solution: String, hint: String, gameDateId: String) {
        let now = Date()
        let calendar = Calendar.current
        var gameDay = calendar.startOfDay(for: now)
        
        // Use 8 AM cutoff
        if calendar.component(.hour, from: now) < 8 {
            gameDay = calendar.date(byAdding: .day, value: -1, to: gameDay) ?? gameDay
        }
        
        let baseDate = calendar.date(from: DateComponents(year: 2025, month: 1, day: 1)) ?? Date()
        let dayIndex = calendar.dateComponents([.day], from: baseDate, to: gameDay).day ?? 0
        let gameIndex = max(0, dayIndex)
        
        let entry = wordEntries[gameIndex % wordEntries.count]
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        let gameDateId = formatter.string(from: gameDay)
        
        return (solution: entry.word, hint: entry.hint, gameDateId: gameDateId)
    }
    
    func isValidWord(_ word: String) -> Bool {
        return validWords.contains(word.uppercased())
    }
    
    func evaluateGuess(_ guess: String, _ solution: String) -> [TileStatus] {
        let guessChars = Array(guess.uppercased())
        let solChars = Array(solution.uppercased())
        var result = Array(repeating: TileStatus.absent, count: 5)
        var solCounts: [Character: Int] = [:]
        
        // Count solution characters
        for ch in solChars {
            solCounts[ch, default: 0] += 1
        }
        
        // Mark correct positions
        for i in 0..<5 {
            if guessChars[i] == solChars[i] {
                result[i] = .correct
                solCounts[guessChars[i], default: 0] -= 1
            }
        }
        
        // Mark present (but not correct) positions
        for i in 0..<5 {
            if result[i] != .correct {
                let ch = guessChars[i]
                if solCounts[ch, default: 0] > 0 {
                    result[i] = .present
                    solCounts[ch, default: 0] -= 1
                }
            }
        }
        
        return result
    }
}


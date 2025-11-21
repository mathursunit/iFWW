//
//  StorageManager.swift
//  SunSar
//
//  Manages local storage
//

import Foundation

class StorageManager {
    private static let gameStateKey = "sunsar-state"
    private static let statsKey = "sunsar-stats"
    
    static func loadGameState(for gameDateId: String) -> GameState? {
        guard let data = UserDefaults.standard.data(forKey: gameStateKey),
              let state = try? JSONDecoder().decode(GameState.self, from: data),
              state.gameDateId == gameDateId else {
            return nil
        }
        return state
    }
    
    static func saveGameState(_ state: GameState) {
        if let data = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(data, forKey: gameStateKey)
        }
    }
    
    static func loadStats() -> GameStats {
        guard let data = UserDefaults.standard.data(forKey: statsKey),
              let stats = try? JSONDecoder().decode(GameStats.self, from: data) else {
            return GameStats()
        }
        return stats
    }
    
    static func saveStats(_ stats: GameStats) {
        if let data = try? JSONEncoder().encode(stats) {
            UserDefaults.standard.set(data, forKey: statsKey)
        }
    }
}


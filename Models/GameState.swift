//
//  GameState.swift
//  SunSar
//
//  Game state model
//

import Foundation

struct GameState: Codable {
    var solution: String
    var hint: String
    var gameDateId: String
    var guesses: [String]
    var usedHint: Bool
    var isComplete: Bool
    var isWin: Bool
}

struct GameStats: Codable {
    var played: Int = 0
    var wins: Int = 0
    var streak: Int = 0
    var maxStreak: Int = 0
}

enum TileStatus {
    case empty
    case editing
    case correct
    case present
    case absent
}

enum KeyStatus {
    case normal
    case correct
    case present
    case absent
}


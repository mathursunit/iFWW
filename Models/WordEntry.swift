//
//  WordEntry.swift
//  SunSar
//
//  Word entry model
//

import Foundation

struct WordEntry: Codable, Identifiable {
    let id = UUID()
    let word: String
    let hint: String
    
    enum CodingKeys: String, CodingKey {
        case word, hint
    }
}


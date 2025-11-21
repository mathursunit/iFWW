//
//  AppColors.swift
//  SunSar
//
//  Color definitions matching the web app
//

import SwiftUI

extension Color {
    static let appBackground = Color(hex: "0F172A")
    static let panelBackground = Color(hex: "111827")
    static let appText = Color(hex: "E2E8F0")
    static let tileCorrect = Color(hex: "8B5CF6")
    static let tilePresent = Color(hex: "2DD4BF")
    static let tileAbsent = Color(hex: "4B5563")
    static let keyBackground = Color(hex: "4B5563")
    static let tileBorder = Color(hex: "4B5563")
    static let tileEditingBorder = Color(hex: "9CA3AF")
    static let tilePresentText = Color(hex: "022C22")
    static let tileAbsentText = Color(hex: "CBD5F5")
    static let logoYellow = Color(hex: "FBBF24") // Tailwind yellow-400
    static let logoBlue = Color(hex: "60A5FA") // Tailwind blue-400
    static let modalBackground = Color(hex: "020617")
    static let toastBackground = Color(hex: "4B5563")
    static let modalBackdrop = Color(hex: "0F172A").opacity(0.75)
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


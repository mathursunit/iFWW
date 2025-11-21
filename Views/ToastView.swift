//
//  ToastView.swift
//  SunSar
//
//  Toast notification view
//

import SwiftUI

struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.toastBackground)
            .cornerRadius(999)
            .shadow(color: .black.opacity(0.35), radius: 10, x: 0, y: 5)
            .padding(.top, 20)
    }
}


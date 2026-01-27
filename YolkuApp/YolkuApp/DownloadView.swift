//
//  DownloadView.swift
//  YolkuApp
//
//  Created by Yolku Team on 2026-01-27.
//

import SwiftUI

struct DownloadView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 20) {
                Text("Download Yolku Today")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Available on iOS and Android")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                
                HStack(spacing: 16) {
                    StoreButton(icon: "📱", title: "App Store")
                    StoreButton(icon: "🤖", title: "Google Play")
                }
                .padding(.top, 10)
            }
            .padding(.vertical, 60)
        }
    }
}

struct StoreButton: View {
    let icon: String
    let title: String
    
    var body: some View {
        Button(action: {
            // Store action
        }) {
            HStack(spacing: 8) {
                Text(icon)
                    .font(.system(size: 28))
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.2))
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 2)
            )
            .cornerRadius(10)
        }
    }
}

#Preview {
    DownloadView()
}

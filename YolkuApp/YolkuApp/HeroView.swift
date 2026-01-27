//
//  HeroView.swift
//  YolkuApp
//
//  Created by Yolku Team on 2026-01-27.
//

import SwiftUI

struct HeroView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 20) {
                Text("Welcome to Yolku")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Connecting medical professionals with healthcare facilities")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.95))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                HStack(spacing: 16) {
                    Button("Download Now") {
                        // Download action
                    }
                    .buttonStyle(WhiteButtonStyle())
                    
                    Button("Learn More") {
                        // Learn more action
                    }
                    .buttonStyle(OutlineWhiteButtonStyle())
                }
                .padding(.top, 10)
            }
            .padding(.vertical, 80)
        }
    }
}

#Preview {
    HeroView()
}

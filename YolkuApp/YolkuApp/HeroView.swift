//
//  HeroView.swift
//  YolkuApp
//
//  Created by Yolku Team on 2026-01-27.
//

import SwiftUI

struct HeroView: View {
    @State private var showHealthcareWorkerSignUp = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 20) {
                Text("Yolku")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Connecting medical professionals with healthcare facilities")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.95))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                HStack(spacing: 16) {
                    Button("I'm a Healthcare Worker") {
                        showHealthcareWorkerSignUp = true
                    }
                    .buttonStyle(WhiteButtonStyle())
                    
                    Button("I'm a Healthcare Facility") {
                        // Healthcare facility action
                    }
                    .buttonStyle(OutlineWhiteButtonStyle())
                }
                .padding(.top, 10)
            }
            .padding(.vertical, 80)
        }
        .sheet(isPresented: $showHealthcareWorkerSignUp) {
            HealthcareWorkerSignUpView()
        }
    }
}

#Preview {
    HeroView()
}

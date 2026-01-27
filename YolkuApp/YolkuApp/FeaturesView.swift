//
//  FeaturesView.swift
//  YolkuApp
//
//  Created by Yolku Team on 2026-01-27.
//

import SwiftUI

struct FeatureCard: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}

struct FeaturesView: View {
    let features = [
        FeatureCard(
            icon: "🏥",
            title: "Instant Connections",
            description: "Match with healthcare facilities in real-time. Find shifts that fit your schedule and expertise instantly."
        ),
        FeatureCard(
            icon: "🔒",
            title: "Secure & Compliant",
            description: "HIPAA-compliant platform ensuring your data and patient information remain secure and protected."
        ),
        FeatureCard(
            icon: "📱",
            title: "Simple Scheduling",
            description: "Manage shifts and availability with ease. Update your schedule on the go with our intuitive mobile app."
        )
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Why Choose Yolku?")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(Color(hex: "333333"))
                .padding(.top, 60)
            
            VStack(spacing: 20) {
                ForEach(features) { feature in
                    FeatureCardView(feature: feature)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 60)
        }
        .background(Color(hex: "f8f9fa"))
    }
}

struct FeatureCardView: View {
    let feature: FeatureCard
    @State private var isHovered = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(feature.icon)
                .font(.system(size: 48))
            
            Text(feature.title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color(hex: "667eea"))
            
            Text(feature.description)
                .font(.system(size: 15))
                .foregroundColor(Color(hex: "666666"))
                .lineSpacing(6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: isHovered)
        .onTapGesture {
            isHovered.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isHovered = false
            }
        }
    }
}

#Preview {
    FeaturesView()
}

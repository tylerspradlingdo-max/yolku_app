//
//  AppPreviewView.swift
//  YolkuApp
//
//  Created by Yolku Team on 2026-01-27.
//

import SwiftUI

struct AppPreviewView: View {
    var body: some View {
        VStack(spacing: 40) {
            VStack(alignment: .leading, spacing: 20) {
                Text("Healthcare Staffing Made Simple")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color(hex: "333333"))
                
                Text("Whether you're a nurse, doctor, or allied health professional, Yolku connects you with healthcare facilities that need your expertise. Our platform streamlines the staffing process, making it easier than ever to find shifts that match your skills and schedule.")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "666666"))
                    .lineSpacing(6)
                
                Text("Join thousands of medical professionals who trust Yolku for their staffing needs.")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "666666"))
                    .lineSpacing(6)
                
                Button("Get Started") {
                    // Get started action
                }
                .buttonStyle(GradientButtonStyle())
                .padding(.top, 10)
            }
            .padding(.horizontal, 20)
            
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 400)
                
                VStack {
                    Text("📱")
                        .font(.system(size: 60))
                    Text("App Preview Coming Soon")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 60)
        .background(Color.white)
    }
}

#Preview {
    AppPreviewView()
}

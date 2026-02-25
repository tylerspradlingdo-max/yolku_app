//
//  HeroView.swift
//  YolkuApp
//
//  Created by Yolku Team on 2026-01-27.
//

import SwiftUI

struct GetStartedPopup: View {
    @Binding var isPresented: Bool
    @Binding var showHealthcareWorkerSignUp: Bool
    @Binding var showHealthcareFacilitySignUp: Bool

    var body: some View {
        VStack(spacing: 24) {
            Text("Get Started")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(hex: "333333"))

            Text("Choose how you'd like to join Yolku")
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "666666"))
                .multilineTextAlignment(.center)

            VStack(spacing: 16) {
                Button(action: {
                    isPresented = false
                    showHealthcareWorkerSignUp = true
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "stethoscope")
                            .font(.system(size: 20))
                        Text("I'm a Healthcare Worker")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(GradientButtonStyle())

                Button(action: {
                    isPresented = false
                    showHealthcareFacilitySignUp = true
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "building.2")
                            .font(.system(size: 20))
                        Text("I'm a Healthcare Facility")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(OutlineButtonStyle())
            }

            Button("Cancel") {
                isPresented = false
            }
            .font(.system(size: 15))
            .foregroundColor(Color(hex: "999999"))
            .padding(.top, 4)
        }
        .padding(32)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 8)
        .padding(.horizontal, 32)
    }
}

struct HeroView: View {
    @State private var showGetStarted = false
    @State private var showHealthcareWorkerSignUp = false
    @State private var showHealthcareFacilitySignUp = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 20) {
                // LOGO: White version for purple gradient background
                Image("AppLogoWhite")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 60)
                    .accessibilityLabel("Yolku logo")
                
                Text("Connecting medical professionals with healthcare facilities")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.95))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Button("Get Started") {
                    showGetStarted = true
                }
                .buttonStyle(WhiteButtonStyle())
                .padding(.top, 10)
            }
            .padding(.vertical, 80)

            if showGetStarted {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showGetStarted = false
                    }

                GetStartedPopup(
                    isPresented: $showGetStarted,
                    showHealthcareWorkerSignUp: $showHealthcareWorkerSignUp,
                    showHealthcareFacilitySignUp: $showHealthcareFacilitySignUp
                )
            }
        }
        .sheet(isPresented: $showHealthcareWorkerSignUp) {
            HealthcareWorkerSignUpView()
        }
        .sheet(isPresented: $showHealthcareFacilitySignUp) {
            HealthcareFacilitySignUpView()
        }
    }
}

#Preview {
    HeroView()
}

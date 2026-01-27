//
//  ContentView.swift
//  YolkuApp
//
//  Created by Yolku Team on 2026-01-27.
//

import SwiftUI

struct ContentView: View {
    @State private var showMenu = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    HeroView()
                    FeaturesView()
                    AppPreviewView()
                    DownloadView()
                    FooterView()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Yolku")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 12) {
                        Button("Sign In") {
                            // Sign in action
                        }
                        .buttonStyle(OutlineButtonStyle())
                        
                        Button("Sign Up") {
                            // Sign up action
                        }
                        .buttonStyle(GradientButtonStyle())
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

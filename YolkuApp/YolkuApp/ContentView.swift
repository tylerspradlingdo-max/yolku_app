//
//  ContentView.swift
//  YolkuApp
//
//  Created by Yolku Team on 2026-01-27.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var showMenu = false
    @State private var showSignIn = false
    
    var body: some View {
        if isLoggedIn {
            DashboardView()
        } else {
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
                        Button("Sign In") {
                            showSignIn = true
                        }
                        .buttonStyle(OutlineButtonStyle())
                    }
                }
                .sheet(isPresented: $showSignIn) {
                    SignInView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

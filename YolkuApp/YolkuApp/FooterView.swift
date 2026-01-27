//
//  FooterView.swift
//  YolkuApp
//
//  Created by Yolku Team on 2026-01-27.
//

import SwiftUI

struct FooterView: View {
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 30) {
                FooterLink(title: "Facebook")
                FooterLink(title: "Twitter")
                FooterLink(title: "LinkedIn")
                FooterLink(title: "Instagram")
            }
            
            Text("© 2026 Yolku. All rights reserved.")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "a0aec0"))
        }
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity)
        .background(Color(hex: "2d3748"))
    }
}

struct FooterLink: View {
    let title: String
    
    var body: some View {
        Button(action: {
            // Social link action
        }) {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.white)
        }
    }
}

#Preview {
    FooterView()
}

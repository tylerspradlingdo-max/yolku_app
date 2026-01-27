//
//  ProfileView.swift
//  YolkuApp
//
//  Created by Yolku Team on 2026-01-27.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    let firstName: String
    let email: String
    let profession: String
    let onLogout: () -> Void
    
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingDocuments = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack(spacing: 16) {
                        // Profile Picture with Upload
                        Button(action: { showingImagePicker = true }) {
                            ZStack(alignment: .bottomTrailing) {
                                // Profile Image or Placeholder
                                if let selectedImage = selectedImage {
                                    Image(uiImage: selectedImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                } else {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 100, height: 100)
                                    
                                    Text(firstName.prefix(1).uppercased())
                                        .font(.system(size: 40, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                
                                // Camera Icon Overlay
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 32, height: 32)
                                    
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(hex: "667eea"))
                                }
                                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                                .offset(x: -2, y: -2)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        VStack(spacing: 4) {
                            Text(firstName)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(profession)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Text(email)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 20)
                    
                    // Profile Stats
                    HStack(spacing: 20) {
                        ProfileStat(value: "0", label: "Shifts")
                        
                        Divider()
                            .frame(height: 40)
                        
                        ProfileStat(value: "5.0", label: "Rating")
                        
                        Divider()
                            .frame(height: 40)
                        
                        ProfileStat(value: "$0", label: "Earned")
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
                    .padding(.horizontal, 24)
                    
                    // Profile Actions
                    VStack(spacing: 12) {
                        ProfileActionButton(
                            icon: "person.fill",
                            title: "Edit Profile",
                            action: {}
                        )
                        
                        ProfileActionButton(
                            icon: "doc.text.fill",
                            title: "Documents & Licenses",
                            action: { showingDocuments = true }
                        )
                        
                        ProfileActionButton(
                            icon: "bell.fill",
                            title: "Notifications",
                            action: {}
                        )
                        
                        ProfileActionButton(
                            icon: "questionmark.circle.fill",
                            title: "Help & Support",
                            action: {}
                        )
                        
                        ProfileActionButton(
                            icon: "gearshape.fill",
                            title: "Settings",
                            action: {}
                        )
                    }
                    .padding(.horizontal, 24)
                    
                    // Logout Button
                    Button(action: onLogout) {
                        HStack {
                            Image(systemName: "arrow.right.square.fill")
                                .font(.system(size: 20))
                            Text("Sign Out")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    
                    Spacer(minLength: 40)
                }
            }
            .background(Color(hex: "f5f5f5"))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
            .sheet(isPresented: $showingDocuments) {
                DocumentsView()
            }
            .onAppear {
                loadProfileImage()
            }
        }
    }
    
    // Load saved profile image
    private func loadProfileImage() {
        if let imageData = UserDefaults.standard.data(forKey: "profileImage"),
           let uiImage = UIImage(data: imageData) {
            selectedImage = uiImage
        }
    }
    
    // Save profile image
    private func saveProfileImage(_ image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 0.7) {
            UserDefaults.standard.set(imageData, forKey: "profileImage")
        }
    }
}

// Image Picker using UIKit
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                parent.selectedImage = editedImage
                saveImage(editedImage)
            } else if let originalImage = info[.originalImage] as? UIImage {
                parent.selectedImage = originalImage
                saveImage(originalImage)
            }
            
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
        
        private func saveImage(_ image: UIImage) {
            if let imageData = image.jpegData(compressionQuality: 0.7) {
                UserDefaults.standard.set(imageData, forKey: "profileImage")
            }
        }
    }
}

// Profile Stat Component
struct ProfileStat: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "333333"))
            
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

// Profile Action Button Component
struct ProfileActionButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "667eea"))
                    .frame(width: 40, height: 40)
                    .background(Color(hex: "667eea").opacity(0.1))
                    .cornerRadius(8)
                
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "333333"))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
        }
    }
}

#Preview {
    ProfileView(
        firstName: "John",
        email: "john@example.com",
        profession: "Registered Nurse (RN)",
        onLogout: {}
    )
}

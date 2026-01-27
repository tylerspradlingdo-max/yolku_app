//
//  DocumentsView.swift
//  YolkuApp
//
//  Created by Copilot on 1/27/26.
//

import SwiftUI
import UniformTypeIdentifiers

// MARK: - Document Model
struct Document: Identifiable, Codable {
    let id: UUID
    let name: String
    let type: DocumentType
    let fileURL: String
    let uploadDate: Date
    let fileSize: Int64
    
    init(id: UUID = UUID(), name: String, type: DocumentType, fileURL: String, fileSize: Int64) {
        self.id = id
        self.name = name
        self.type = type
        self.fileURL = fileURL
        self.uploadDate = Date()
        self.fileSize = fileSize
    }
}

// MARK: - Document Types
enum DocumentType: String, Codable, CaseIterable {
    case medicalLicense = "Medical License"
    case nursingLicense = "Nursing License"
    case certification = "Certification"
    case resume = "Resume/CV"
    case immunization = "Immunization Records"
    case backgroundCheck = "Background Check"
    case identification = "ID/Passport"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .medicalLicense, .nursingLicense:
            return "cross.case.fill"
        case .certification:
            return "rosette"
        case .resume:
            return "doc.text.fill"
        case .immunization:
            return "syringe.fill"
        case .backgroundCheck:
            return "checkmark.shield.fill"
        case .identification:
            return "person.text.rectangle.fill"
        case .other:
            return "doc.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .medicalLicense, .nursingLicense:
            return Color(hex: "667eea")
        case .certification:
            return Color(hex: "764ba2")
        case .resume:
            return .blue
        case .immunization:
            return .green
        case .backgroundCheck:
            return .orange
        case .identification:
            return .purple
        case .other:
            return .gray
        }
    }
}

// MARK: - Documents View
struct DocumentsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var documents: [Document] = []
    @State private var showingDocumentPicker = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var selectedDocumentType: DocumentType = .other
    @State private var showingTypePicker = false
    @State private var documentToDelete: Document?
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if documents.isEmpty {
                    emptyStateView
                } else {
                    documentsList
                }
            }
            .navigationTitle("Documents & Licenses")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingTypePicker = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                }
            }
            .sheet(isPresented: $showingTypePicker) {
                documentTypePicker
            }
            .sheet(isPresented: $showingDocumentPicker) {
                DocumentPicker(documentType: selectedDocumentType) { document in
                    addDocument(document)
                }
            }
            .alert("Document Uploaded", isPresented: $showingAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
            .alert("Delete Document", isPresented: $showingDeleteConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    if let doc = documentToDelete {
                        deleteDocument(doc)
                    }
                }
            } message: {
                Text("Are you sure you want to delete this document? This action cannot be undone.")
            }
            .onAppear {
                loadDocuments()
            }
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.badge.plus")
                .font(.system(size: 70))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("No Documents Yet")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Upload your professional documents,\nlicenses, and certifications")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
            
            Button(action: { showingTypePicker = true }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Upload Document")
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .background(
                    LinearGradient(
                        colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(25)
                .shadow(color: Color(hex: "667eea").opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .padding(.top, 10)
        }
        .padding()
    }
    
    // MARK: - Documents List
    private var documentsList: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(documents) { document in
                    DocumentCard(document: document) {
                        documentToDelete = document
                        showingDeleteConfirmation = true
                    }
                }
            }
            .padding()
        }
    }
    
    // MARK: - Document Type Picker
    private var documentTypePicker: some View {
        NavigationView {
            List(DocumentType.allCases, id: \.self) { type in
                Button(action: {
                    selectedDocumentType = type
                    showingTypePicker = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showingDocumentPicker = true
                    }
                }) {
                    HStack {
                        Image(systemName: type.icon)
                            .foregroundColor(type.color)
                            .frame(width: 30)
                        Text(type.rawValue)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Select Document Type")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        showingTypePicker = false
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    private func addDocument(_ document: Document) {
        documents.append(document)
        saveDocuments()
        alertMessage = "\(document.name) uploaded successfully!"
        showingAlert = true
    }
    
    private func deleteDocument(_ document: Document) {
        // Delete file from disk
        let fileURL = getDocumentsDirectory().appendingPathComponent(document.fileURL)
        try? FileManager.default.removeItem(at: fileURL)
        
        // Remove from array
        documents.removeAll { $0.id == document.id }
        saveDocuments()
    }
    
    private func saveDocuments() {
        if let encoded = try? JSONEncoder().encode(documents) {
            UserDefaults.standard.set(encoded, forKey: "uploadedDocuments")
        }
    }
    
    private func loadDocuments() {
        if let data = UserDefaults.standard.data(forKey: "uploadedDocuments"),
           let decoded = try? JSONDecoder().decode([Document].self, from: data) {
            documents = decoded
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

// MARK: - Document Card
struct DocumentCard: View {
    let document: Document
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 15) {
                // Icon
                ZStack {
                    Circle()
                        .fill(document.type.color.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: document.type.icon)
                        .font(.system(size: 24))
                        .foregroundColor(document.type.color)
                }
                
                // Document Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(document.name)
                        .font(.system(size: 16, weight: .semibold))
                        .lineLimit(1)
                    
                    Text(document.type.rawValue)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 10) {
                        Label(formatDate(document.uploadDate), systemImage: "calendar")
                        Label(formatFileSize(document.fileSize), systemImage: "doc")
                    }
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Delete Button
                Button(action: onDelete) {
                    Image(systemName: "trash.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.red)
                        .padding(10)
                }
            }
            .padding(16)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func formatFileSize(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
}

// MARK: - Document Picker
struct DocumentPicker: UIViewControllerRepresentable {
    let documentType: DocumentType
    let onDocumentPicked: (Document) -> Void
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf, .image, .jpeg, .png], asCopy: true)
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            
            // Copy file to app's documents directory
            let fileManager = FileManager.default
            let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileName = "\(UUID().uuidString)_\(url.lastPathComponent)"
            let destinationURL = documentsDirectory.appendingPathComponent(fileName)
            
            do {
                // Get file size
                let attributes = try fileManager.attributesOfItem(atPath: url.path)
                let fileSize = attributes[.size] as? Int64 ?? 0
                
                // Copy file
                try fileManager.copyItem(at: url, to: destinationURL)
                
                // Create document model
                let document = Document(
                    name: url.deletingPathExtension().lastPathComponent,
                    type: parent.documentType,
                    fileURL: fileName,
                    fileSize: fileSize
                )
                
                parent.onDocumentPicked(document)
            } catch {
                print("Error copying document: \(error)")
            }
        }
    }
}

// MARK: - Preview
struct DocumentsView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentsView()
    }
}

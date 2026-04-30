//
//  ChatConversationView.swift
//  YolkuApp
//
//  Individual conversation view with text-based messaging.
//

import SwiftUI

struct ChatConversationView: View {
    let conversation: ChatConversation
    
    @State private var messages: [ChatMessage] = []
    @State private var messageText = ""
    @State private var isLoading = false
    @State private var isSending = false
    @State private var errorMessage: String?
    @FocusState private var isInputFocused: Bool
    
    private var facilityName: String {
        conversation.facility?.name ?? "Conversation"
    }
    
    private var facilityLocation: String {
        conversation.facility?.location ?? ""
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header info bar
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 40, height: 40)
                    Text(String(facilityName.prefix(1)))
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(facilityName)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color(hex: "333333"))
                    Text(facilityLocation)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            
            // Messages list
            if isLoading {
                Spacer()
                ProgressView("Loading…")
                Spacer()
            } else {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                    .background(Color(hex: "f5f5f5"))
                    .onChange(of: messages.count) { _ in
                        if let last = messages.last {
                            withAnimation {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                    .onAppear {
                        if let last = messages.last {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Message input bar
            VStack(spacing: 0) {
                Divider()
                HStack(spacing: 10) {
                    TextField("Type a message…", text: $messageText, axis: .vertical)
                        .lineLimit(1...4)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color(hex: "f0f0f0"))
                        .cornerRadius(20)
                        .focused($isInputFocused)
                    
                    Button(action: sendMessage) {
                        if isSending {
                            ProgressView()
                                .frame(width: 36, height: 36)
                        } else {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 36))
                                .foregroundColor(
                                    messageText.trimmingCharacters(in: .whitespaces).isEmpty
                                    ? Color.gray.opacity(0.4)
                                    : Color(hex: "667eea")
                                )
                        }
                    }
                    .disabled(messageText.trimmingCharacters(in: .whitespaces).isEmpty || isSending)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.white)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(facilityName)
        .alert("Error", isPresented: .constant(errorMessage != nil), actions: {
            Button("OK") { errorMessage = nil }
        }, message: {
            Text(errorMessage ?? "")
        })
        .task {
            await loadMessages()
        }
    }
    
    private func loadMessages() async {
        isLoading = true
        defer { isLoading = false }
        let authToken = KeychainService.load(key: "authToken") ?? ""
        do {
            let detail = try await APIService.shared.getMessages(
                conversationId: conversation.id,
                token: authToken
            )
            messages = detail.messages ?? []
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func sendMessage() {
        let trimmed = messageText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        
        let optimisticMsg = ChatMessage(
            id: UUID().uuidString,
            conversationId: conversation.id,
            senderType: "user",
            senderId: "me",
            content: trimmed,
            isRead: false,
            createdAt: ISO8601DateFormatter().string(from: Date()),
            updatedAt: ISO8601DateFormatter().string(from: Date())
        )
        messages.append(optimisticMsg)
        messageText = ""
        
        Task {
            isSending = true
            defer { isSending = false }
            let authToken = KeychainService.load(key: "authToken") ?? ""
            do {
                let sent = try await APIService.shared.sendMessage(
                    conversationId: conversation.id,
                    content: trimmed,
                    token: authToken
                )
                // Replace optimistic message with the real one
                if let idx = messages.firstIndex(where: { $0.id == optimisticMsg.id }) {
                    messages[idx] = sent
                }
            } catch {
                // Remove the optimistic message on failure
                messages.removeAll { $0.id == optimisticMsg.id }
                errorMessage = "Failed to send message. Please try again."
            }
        }
    }
}

// MARK: - Message Bubble

struct MessageBubble: View {
    let message: ChatMessage
    
    private var isFromUser: Bool { message.senderType == "user" }
    
    var body: some View {
        HStack {
            if isFromUser { Spacer(minLength: 60) }
            
            VStack(alignment: isFromUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .font(.system(size: 15))
                    .foregroundColor(isFromUser ? .white : Color(hex: "333333"))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        isFromUser
                        ? LinearGradient(
                            colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                          )
                        : LinearGradient(
                            colors: [Color.white, Color.white],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                          )
                    )
                    .cornerRadius(18)
                    .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
                
                Text(message.formattedTime)
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 4)
            }
            
            if !isFromUser { Spacer(minLength: 60) }
        }
    }
}

#Preview {
    NavigationView {
        ChatConversationView(
            conversation: ChatConversation(
                id: "preview-conv",
                userId: "user-1",
                facilityId: "fac-1",
                user: ChatUser(id: "user-1", firstName: "Demo", lastName: "User", profession: "RN"),
                facility: ChatFacility(id: "fac-1", name: "General Hospital", city: "San Francisco", state: "CA", facilityType: "Hospital"),
                messages: [],
                createdAt: ISO8601DateFormatter().string(from: Date()),
                updatedAt: ISO8601DateFormatter().string(from: Date())
            )
        )
    }
}

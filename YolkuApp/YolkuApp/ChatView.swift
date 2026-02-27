//
//  ChatView.swift
//  YolkuApp
//
//  Messaging - list of conversations between healthcare workers and facilities.
//

import SwiftUI

struct ChatView: View {
    @AppStorage("authToken") private var authToken = ""
    @State private var conversations: [ChatConversation] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView("Loading messages…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if conversations.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "bubble.left.and.bubble.right")
                            .font(.system(size: 60))
                            .foregroundColor(Color(hex: "667eea").opacity(0.4))
                        Text("No conversations yet")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(hex: "333333"))
                        Text("When a facility contacts you, or you\nstart a conversation, it will appear here.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(conversations) { conversation in
                        NavigationLink(destination: ChatConversationView(conversation: conversation)) {
                            ConversationRow(conversation: conversation)
                        }
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .background(Color(hex: "f5f5f5"))
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.large)
            .alert("Error", isPresented: .constant(errorMessage != nil), actions: {
                Button("OK") { errorMessage = nil }
            }, message: {
                Text(errorMessage ?? "")
            })
            .task {
                await loadConversations()
            }
            .refreshable {
                await loadConversations()
            }
        }
    }
    
    private func loadConversations() async {
        isLoading = true
        defer { isLoading = false }
        do {
            conversations = try await APIService.shared.getConversations(token: authToken)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

// MARK: - Conversation Row

struct ConversationRow: View {
    let conversation: ChatConversation
    
    private var facilityName: String {
        conversation.facility?.name ?? "Unknown Facility"
    }
    
    private var facilityLocation: String {
        conversation.facility?.location ?? ""
    }
    
    private var lastMessagePreview: String {
        conversation.lastMessage?.content ?? "No messages yet"
    }
    
    private var lastMessageTime: String {
        conversation.lastMessage?.formattedTime ?? ""
    }
    
    private var hasUnread: Bool {
        guard let msg = conversation.lastMessage else { return false }
        return !msg.isRead && msg.senderType == "facility"
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Text(String(facilityName.prefix(1)))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(facilityName)
                        .font(.system(size: 16, weight: hasUnread ? .bold : .semibold))
                        .foregroundColor(Color(hex: "333333"))
                    Spacer()
                    Text(lastMessageTime)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                Text(facilityLocation)
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "667eea"))
                
                HStack {
                    Text(lastMessagePreview)
                        .font(.system(size: 14))
                        .foregroundColor(hasUnread ? Color(hex: "333333") : .gray)
                        .fontWeight(hasUnread ? .medium : .regular)
                        .lineLimit(1)
                    
                    if hasUnread {
                        Spacer()
                        Circle()
                            .fill(Color(hex: "667eea"))
                            .frame(width: 10, height: 10)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ChatView()
}

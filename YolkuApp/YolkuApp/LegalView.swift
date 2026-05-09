//
//  LegalView.swift
//  YolkuApp
//
//  Terms of Service and Privacy Policy
//

import SwiftUI

// MARK: - Legal Document Type

enum LegalDocument {
    case termsOfService
    case privacyPolicy
}

// MARK: - Legal View

struct LegalView: View {
    let document: LegalDocument
    @Environment(\.dismiss) var dismiss

    private var title: String {
        switch document {
        case .termsOfService: return "Terms of Service"
        case .privacyPolicy: return "Privacy Policy"
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    switch document {
                    case .termsOfService:
                        TermsOfServiceContent()
                    case .privacyPolicy:
                        PrivacyPolicyContent()
                    }
                }
                .padding(20)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(Color(hex: "667eea"))
                }
            }
        }
    }
}

// MARK: - Terms of Service Content

private struct TermsOfServiceContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            LegalSectionHeader(text: "Terms of Service")
            LegalParagraph(text: "Last updated: January 2026")

            LegalSectionHeader(text: "1. Acceptance of Terms")
            LegalParagraph(text: "By downloading, installing, or using the Yolku mobile application (\"App\"), you agree to be bound by these Terms of Service (\"Terms\"). If you do not agree to these Terms, do not use the App.")

            LegalSectionHeader(text: "2. Description of Service")
            LegalParagraph(text: "Yolku is a healthcare staffing platform that connects healthcare professionals (\"Workers\") with healthcare facilities (\"Facilities\"). The App facilitates the discovery, communication, and coordination of staffing arrangements.")

            LegalSectionHeader(text: "3. Eligibility")
            LegalParagraph(text: "You must be at least 18 years of age and legally permitted to work in your jurisdiction to use this App. By registering, you represent and warrant that you meet these requirements.")

            LegalSectionHeader(text: "4. User Accounts")
            LegalParagraph(text: "You are responsible for maintaining the confidentiality of your account credentials and for all activity that occurs under your account. You agree to notify Yolku immediately of any unauthorized use of your account.")

            LegalSectionHeader(text: "5. Professional Credentials")
            LegalParagraph(text: "Workers are solely responsible for ensuring that all credentials, licenses, and certifications submitted to the App are accurate, current, and valid. Yolku does not independently verify professional credentials and assumes no liability for errors or omissions.")

            LegalSectionHeader(text: "6. Prohibited Conduct")
            LegalParagraph(text: "You agree not to: (a) submit false or misleading information; (b) impersonate any person or entity; (c) use the App for any unlawful purpose; (d) attempt to gain unauthorized access to any portion of the App; or (e) interfere with the proper functioning of the App.")

            LegalSectionHeader(text: "7. Intellectual Property")
            LegalParagraph(text: "All content, trademarks, and other intellectual property in the App are owned by or licensed to Yolku. You may not reproduce, distribute, or create derivative works without express written permission.")

            LegalSectionHeader(text: "8. Disclaimer of Warranties")
            LegalParagraph(text: "The App is provided \"as is\" without warranty of any kind. Yolku makes no warranties, express or implied, regarding the accuracy, reliability, or availability of the App.")

            LegalSectionHeader(text: "9. Limitation of Liability")
            LegalParagraph(text: "To the fullest extent permitted by law, Yolku shall not be liable for any indirect, incidental, special, or consequential damages arising out of your use of the App.")

            LegalSectionHeader(text: "10. Termination")
            LegalParagraph(text: "Yolku reserves the right to suspend or terminate your account at any time, with or without notice, for violation of these Terms or for any other reason at Yolku's sole discretion.")

            LegalSectionHeader(text: "11. Governing Law")
            LegalParagraph(text: "These Terms shall be governed by and construed in accordance with the laws of the United States, without regard to its conflict of law provisions.")

            LegalSectionHeader(text: "12. Contact Us")
            LegalParagraph(text: "If you have questions about these Terms, please contact us at legal@yolku.com.")
        }
    }
}

// MARK: - Privacy Policy Content

private struct PrivacyPolicyContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            LegalSectionHeader(text: "Privacy Policy")
            LegalParagraph(text: "Last updated: January 2026")

            LegalSectionHeader(text: "1. Introduction")
            LegalParagraph(text: "Yolku (\"we\", \"our\", or \"us\") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use the Yolku mobile application.")

            LegalSectionHeader(text: "2. Information We Collect")
            LegalParagraph(text: "We collect the following categories of personal information:\n\n• Account information: name, email address, phone number, and password.\n• Professional information: profession, license numbers, credentials, state licenses, and board certifications.\n• Location data: state and city for job matching purposes.\n• Communications: messages exchanged between Workers and Facilities through the App.\n• Usage data: how you interact with the App, including features used and time spent.\n• Profile images: photos you voluntarily upload from your photo library.")

            LegalSectionHeader(text: "3. How We Use Your Information")
            LegalParagraph(text: "We use the information we collect to:\n\n• Create and manage your account.\n• Connect healthcare workers with healthcare facilities.\n• Provide AI-powered job matching recommendations.\n• Enable in-app messaging between Workers and Facilities.\n• Send important service notifications.\n• Improve and maintain the App.\n• Comply with legal obligations.")

            LegalSectionHeader(text: "4. Information Sharing")
            LegalParagraph(text: "We do not sell your personal information. We may share your information with:\n\n• Healthcare facilities when you apply to or express interest in a position.\n• Service providers who assist us in operating the App (subject to confidentiality obligations).\n• Law enforcement or regulatory authorities when required by law.\n• Successors in the event of a merger, acquisition, or sale of assets.")

            LegalSectionHeader(text: "5. Data Security")
            LegalParagraph(text: "We implement industry-standard security measures to protect your information, including encryption of authentication tokens and secure transmission over HTTPS. However, no method of transmission or storage is 100% secure.")

            LegalSectionHeader(text: "6. Data Retention")
            LegalParagraph(text: "We retain your personal information for as long as your account is active or as needed to provide services. You may request deletion of your account and associated data at any time through the App or by contacting us.")

            LegalSectionHeader(text: "7. Your Rights")
            LegalParagraph(text: "Depending on your jurisdiction, you may have the right to:\n\n• Access the personal information we hold about you.\n• Correct inaccurate information.\n• Delete your account and associated data.\n• Object to or restrict certain processing.\n• Data portability.\n\nTo exercise these rights, contact us at privacy@yolku.com or use the account deletion feature within the App.")

            LegalSectionHeader(text: "8. Children's Privacy")
            LegalParagraph(text: "The App is not intended for users under 18 years of age. We do not knowingly collect personal information from minors.")

            LegalSectionHeader(text: "9. Changes to This Policy")
            LegalParagraph(text: "We may update this Privacy Policy from time to time. We will notify you of material changes by updating the date at the top of this policy and, where appropriate, by in-app notification.")

            LegalSectionHeader(text: "10. Contact Us")
            LegalParagraph(text: "If you have questions or concerns about this Privacy Policy, please contact us at:\n\nYolku\nEmail: privacy@yolku.com\nsupport@yolku.com")
        }
    }
}

// MARK: - Supporting Views

private struct LegalSectionHeader: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(Color(hex: "333333"))
    }
}

private struct LegalParagraph: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 14))
            .foregroundColor(Color(hex: "555555"))
            .lineSpacing(4)
    }
}

// MARK: - Preview

#Preview {
    LegalView(document: .privacyPolicy)
}

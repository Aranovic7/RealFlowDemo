/*
   This code defines a FAQItem struct representing FAQ items with questions and answers,
   and a FAQScreen that displays a list of FAQ items where users can expand to view answers.
*/

import SwiftUI

struct FAQItem: Identifiable, Equatable {
    let id = UUID()
    let question: String
    let answer: String
}

let faqItems: [FAQItem] = [
    FAQItem(question: "How do I create an account?", answer: "To create an account, go to the Register screen, fill in your details, and press the 'Create account' button."),
    FAQItem(question: "How do I change my password?", answer: "To change your password, click on the 'Change password' link on the settings screen and follow the instructions."),
    FAQItem(question: "How do I change my profile picture?", answer: "To change your profile picture, go to your profile settings, tap on your current profile picture, and select a new image from your gallery."),
    FAQItem(question: "How do I send a message?", answer: "To send a message, go to the Chat section, select a friend, and type your message in the text box."),
    FAQItem(question: "How do I log out?", answer: "To log out, go to the settings menu and press the 'Log out' button."),
    FAQItem(question: "What should I do if I encounter a problem?", answer: "If you encounter a problem, contact our support team through the Help section or email us at support@realflow.com.")
]

struct FAQScreen: View {
    
    @State var showAnswers: Bool = false
    @State var selectedQuestion: FAQItem?
    @State var navigateBackBtn: Bool = false
    
    var body: some View {
        
        List(faqItems) { faqItem in
            VStack(alignment: .leading) {
                Text(faqItem.question)
                    .foregroundStyle(selectedQuestion == faqItem ? Color.red : .black)
                if selectedQuestion == faqItem {
                    Text(faqItem.answer)
                        .padding(.top, 5)
                        .foregroundStyle(.gray)
                }
            }
            .onTapGesture {
                withAnimation {
                    if selectedQuestion == faqItem {
                        selectedQuestion = nil
                    } else {
                        selectedQuestion = faqItem
                    }
                }
            }
            .padding(.vertical, 10)
        }
    }
}

#Preview {
    FAQScreen()
}

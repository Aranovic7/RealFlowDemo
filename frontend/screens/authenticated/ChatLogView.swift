import SwiftUI

struct ChatLogView: View {
    let user: UserData
    @EnvironmentObject var firebaseManager: FirebaseManager

    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    VStack {
                        ForEach(firebaseManager.messages) { message in
                            MessageView(message: message, isCurrentUser: message.senderID == firebaseManager.currentUserUID)
                        }
                        HStack { Spacer() }
                            .id("lastMessage")
                    }
                    .onAppear {
                        firebaseManager.fetchMessages(recipientID: user.userID) { messages in
                            firebaseManager.messages = messages
                        }
                        scrollViewProxy.scrollTo("lastMessage", anchor: .bottom)
                    }
                    .onChange(of: firebaseManager.messages) { _ in
                        withAnimation(.easeOut(duration: 0.5)) {
                            scrollViewProxy.scrollTo("lastMessage", anchor: .bottom)
                        }
                    }
                }
            }
            .background(Color.gray.opacity(0.2))
            .navigationTitle(user.username)
            .navigationBarTitleDisplayMode(.inline)

            ChatBarComponent(user: user)
        }
        .toolbar(.hidden, for: .tabBar)
    }
}



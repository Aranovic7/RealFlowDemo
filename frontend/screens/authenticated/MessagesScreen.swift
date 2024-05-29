/*
   MessagesScreen is a SwiftUI view that displays a list of recent conversations.
   Users can tap on a conversation to navigate to the chat log view with the selected user.
   The view refreshes recent messages and handles navigation within a navigation stack.
*/

import SwiftUI

struct MessagesScreen: View {
    
    @EnvironmentObject var firebaseManager: FirebaseManager
    @State private var selectedUser: UserData? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                TopNavBar()
                ScrollView {
                    VStack {
                        if firebaseManager.recentMessages.isEmpty {
                            Text("No conversations found.")
                                .padding()
                        } else {
                            ForEach(firebaseManager.recentMessages) { recentMessage in
                                messageRow(for: recentMessage)
                                
                            }
                        }
                    }.padding(.top)
                }
                .refreshable {
                    firebaseManager.fetchRecentMessages()
                }
            }
            .overlay(
                NewMessagesBtn(), alignment: .bottom
            )
            .onAppear {
                print("MessagesScreen appeared, fetching recent messages")
                firebaseManager.fetchRecentMessages()
            }
            .background(
                NavigationLink(destination: ChatLogView(user: selectedUser ?? UserData(username: "", profileImageURL: nil, userID: "")), isActive: Binding(
                    get: { self.selectedUser != nil },
                    set: { _ in self.selectedUser = nil }
                )) {
                    EmptyView()
                }
            )
        }
    }

    func messageRow(for recentMessage: RecentMessage) -> some View {
        HStack {
            if let imageURLString = recentMessage.profileImageURL, let imageURL = URL(string: imageURLString) {
                AsyncImage(url: imageURL) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                }
            } else {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 50, height: 50)
            }
            
            VStack(alignment: .leading) {
                Text(recentMessage.username)
                    .font(.headline)
                
                let messageText = recentMessage.text
                Text(truncatedText(messageText, limit: 25))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(timeAgoDisplay(recentMessage.timestamp.dateValue()))
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
        .padding(.horizontal)
        .onTapGesture {
            firebaseManager.fetchRecipientID(for: recentMessage.username) { userID in
                if let userID = userID {
                    let profileImageURL = recentMessage.profileImageURL.flatMap { URL(string: $0) }
                    self.selectedUser = UserData(username: recentMessage.username, profileImageURL: profileImageURL, userID: userID)
                }
            }
        }
    }

    func truncatedText(_ text: String, limit: Int) -> String {
        if text.count > limit {
            let endIndex = text.index(text.startIndex, offsetBy: limit)
            return String(text[..<endIndex]) + "..."
        } else {
            return text
        }
    }

    func timeAgoDisplay(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}


//import SwiftUI
//
//struct MessagesScreen: View {
//
//    @EnvironmentObject var firebaseManager: FirebaseManager
//    @State private var selectedUser: UserData? = nil
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                TopNavBar()
//                ScrollView {
//                    VStack {
//                        if firebaseManager.recentMessages.isEmpty {
//                            Text("No conversations found.")
//                                .padding()
//                        } else {
//                            ForEach(firebaseManager.recentMessages) { recentMessage in
//                                HStack {
//                                    if let imageURLString = recentMessage.profileImageURL, let imageURL = URL(string: imageURLString) {
//                                        AsyncImage(url: imageURL) { image in
//                                            image.resizable()
//                                                .aspectRatio(contentMode: .fill)
//                                                .frame(width: 50, height: 50)
//                                                .clipShape(Circle())
//                                        } placeholder: {
//                                            ProgressView()
//                                        }
//                                    } else {
//                                        Circle()
//                                            .fill(Color.gray)
//                                            .frame(width: 50, height: 50)
//                                    }
//
//                                    VStack(alignment: .leading) {
//                                        Text(recentMessage.username)
//                                            .font(.headline)
//
//                                        Text(truncatedText(recentMessage.imageURL != nil ? "sent an image" : recentMessage.text, limit: 50))
//                                                                                   .font(.subheadline)
//                                                                                   .foregroundColor(.gray)
//
//                                    }
//                                    Spacer()
//                                    Text(timeAgoDisplay(recentMessage.timestamp.dateValue()))
//                                        .font(.subheadline)
//                                        .foregroundColor(.gray)
//                                }
//                                .padding()
//                                .background(Color.white)
//                                .cornerRadius(8)
//                                .shadow(radius: 2)
//                                .padding(.horizontal)
//                                .onTapGesture {
//                                    firebaseManager.fetchRecipientID(for: recentMessage.username) { userID in
//                                        if let userID = userID {
//                                            let profileImageURL = recentMessage.profileImageURL.flatMap { URL(string: $0) }
//                                            self.selectedUser = UserData(username: recentMessage.username, profileImageURL: profileImageURL, userID: userID)
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }.padding(.top)
//                }
//            }
//            .overlay(
//                NewMessagesBtn(), alignment: .bottom
//            )
//            .onAppear {
//                print("MessagesScreen appeared, fetching recent messages")
//                firebaseManager.fetchRecentMessages()
//            }
//            // Lägg till NavigationLink här
//            .background(
//                NavigationLink(destination: ChatLogView(user: selectedUser ?? UserData(username: "", profileImageURL: nil, userID: "")), isActive: Binding(
//                    get: { self.selectedUser != nil },
//                    set: { _ in self.selectedUser = nil }
//                )) {
//                    EmptyView()
//                }
//            )
//        }
//    }
//
//    func timeAgoDisplay(_ date: Date) -> String {
//           let formatter = RelativeDateTimeFormatter()
//           formatter.unitsStyle = .short
//           return formatter.localizedString(for: date, relativeTo: Date())
//       }
//
//    func truncatedText(_ text: String, limit: Int) -> String {
//           if text.count > limit {
//               let endIndex = text.index(text.startIndex, offsetBy: limit)
//               return String(text[..<endIndex]) + "..."
//           } else {
//               return text
//           }
//       }
//}


//
//  CreateNewMessageView.swift
//  RealFlow
//
//  Created by Aran Ali on 2024-04-22.
//

/*
   CreateNewMessageView is a SwiftUI view that allows users to select a recipient for a new message.
   It displays a list of users fetched from Firebase, allowing navigation to a chat log view with the selected user.
   The view includes functionality to load user profile images and handles navigation within a navigation stack.
*/

import SwiftUI

struct CreateNewMessageView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var firebaseManager: FirebaseManager
    //@State var navigateToChatLogView: Bool = false
    
    var body: some View {
        NavigationStack{
            ScrollView{
                ForEach(firebaseManager.usersData) { user in
                    NavigationLink{
                        ChatLogView(user: user)
                      //  Button {
                        //    print("Selected user: \(user.username)")
                         //   navigateToChatLogView = true
                            //presentationMode.wrappedValue.dismiss()
                            
                        } label: {
                            HStack {
                                if let profileImageURL = user.profileImageURL {
                                    AsyncImage(url: profileImageURL) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 50, height: 50)
                                                .clipShape(Circle())
                                                .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color.black, style: .init(lineWidth: 1)))
                                        case .failure(let error):
                                            Text("Failed to load image: \(error.localizedDescription)")
                                        case .empty:
                                            ProgressView()
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                } else {
                                    // Om ingen profilbilds-URL finns
                                    Image(systemName: "person.circle")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                }
                                Text(user.username)
                                    .foregroundStyle(Color(.label))
                                Spacer()
                            }.padding(.horizontal)
                   //     }
                        
                        Divider()
                            .padding(.vertical, 8)
                    }
                }

            } .navigationTitle("New Message")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                        }
                    }
                }
        }
        .onAppear{
            firebaseManager.fetchAllUsers{ users in
                firebaseManager.usersData = users
            }
        }
       
    }
}

#Preview {
    CreateNewMessageView()
}


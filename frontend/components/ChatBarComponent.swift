/*
   ChatBarComponent is a SwiftUI view that provides a text input and image picker for sending messages.
   Users can type a message, select an image, and send the message with or without an image.
   The component integrates with Firebase to handle message sending and updates the UI accordingly.
*/

import SwiftUI

struct ChatBarComponent: View {
    
    
    let user: UserData
    @EnvironmentObject var firebaseManager: FirebaseManager
    
    @State private var isImagePickerPresented: Bool = false
    @State private var selectedImage: UIImage?
  
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Button(action: {
                    isImagePickerPresented = true
                }) {
                    Image(systemName: "photo.on.rectangle")
                        .font(.system(size: 24))
                        .foregroundStyle(Color(.darkGray))
                }
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(selectedImage: $selectedImage)
                }
                
                TextField("Description", text: $firebaseManager.chatText)
                
                Button {
                    if let image = selectedImage {
                        firebaseManager.handleSend(text: self.firebaseManager.chatText, image: image, recipientId: user.userID)
                        selectedImage = nil // Återställ vald bild efter skickad
                        firebaseManager.chatText = "" // Återställ textfältet efter skickad
                    } else {
                        firebaseManager.handleSend(text: self.firebaseManager.chatText, image: nil, recipientId: user.userID)
                        firebaseManager.chatText = "" // Återställ textfältet efter skickad
                    }
                } label: {
                    Text("Send")
                        .foregroundStyle(Color.white)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            if let selectedImage = selectedImage {
                HStack {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    Button(action: {
                        self.selectedImage = nil
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 24))
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}



////
////  ChatBarComponent.swift
////  RealFlow
////
////  Created by Aran Ali on 2024-04-24.
////
//
//import SwiftUI
//
//struct ChatBarComponent: View {
//
//
//    let user: UserData
//
//    @EnvironmentObject var firebaseManager: FirebaseManager
//
//    @State private var isImagePickerPresented: Bool = false
//    @State private var selectedImage: UIImage?
//
//    var body: some View {
//        HStack(spacing: 16){
//            Button(action: {
//                       isImagePickerPresented = true
//                   }) {
//                       Image(systemName: "photo.on.rectangle")
//                           .font(.system(size: 24))
//                           .foregroundStyle(Color(.darkGray))
//                   }
//                   .sheet(isPresented: $isImagePickerPresented) {
//                       ImagePicker(selectedImage: $selectedImage)
//                   }
//            TextField("Description", text: $firebaseManager.chatText)
//            Button {
//                           if let image = selectedImage {
//                               firebaseManager.handleSend(text: self.firebaseManager.chatText, image: image, recipientId: user.userID)
//                               selectedImage = nil // Återställ vald bild efter skickad
//                           } else {
//                               firebaseManager.handleSend(text: self.firebaseManager.chatText, image: nil, recipientId: user.userID)
//                           }
//                       } label: {
//                           Text("Send")
//                               .foregroundStyle(Color.white)
//                       }
//                       .padding(.horizontal)
//                       .padding(.vertical, 8)
//                       .background(Color.blue)
//                       .clipShape(RoundedRectangle(cornerRadius: 8))
////            Button{
////                firebaseManager.handleSend(text: self.firebaseManager.chatText, image: firebaseManager.profileImage, recipientId: user.userID)
////            } label: {
////                Text("Send")
////                    .foregroundStyle(Color.white)
////            }
////            .padding(.horizontal)
////            .padding(.vertical, 8)
////            .background(Color.blue)
////            .clipShape(.rect(cornerRadius: 8))
//        }
//        .padding(.horizontal)
//        .padding(.vertical, 8)
//    }
//}


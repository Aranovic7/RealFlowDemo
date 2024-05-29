//
//  ProfileScreen.swift
//  RealFlow
//
//  Created by Aran Ali on 2024-03-16.
//

/*
   ProfileScreen is a SwiftUI view that displays the user's profile information.
   Users can view and update their profile image and see their first name, last name, and username.
   The view integrates PhotosPicker for selecting and updating the profile image.
*/

import SwiftUI
import PhotosUI

struct ProfileScreen: View {
    
    @EnvironmentObject var firebaseManager: FirebaseManager
    
    @State var photosPickerItem: PhotosPickerItem?
    
    @State var isShowingPhotoPicker: Bool = false
    
    var body: some View {
        ScrollView{
            VStack{
                PhotosPicker(selection: $photosPickerItem, matching: .images) {
                    AsyncImage(url: firebaseManager.profileImageURL, content: { returnedImage in
                        returnedImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .overlay(alignment: .bottomTrailing){
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.title)
                                    .foregroundStyle(Color.blue)
                            }
                        
                    }, placeholder: {
                        Image(.maleAvatar)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                    })
                }
              
                
                HStack{
                    
                    Text("\(firebaseManager.firstName ?? "John")")
                        .bold()
                        .font(.title)
                    
                    Text("\(firebaseManager.lastName ?? "Doe")")
                        .bold()
                        .font(.title)
                        
                }.padding()
                
               
                
                Text("\(firebaseManager.username ?? "JohnDoe@gmail.com")")
                    .padding()
                    .font(.headline)
                
                
                
                
            }
            .onChange(of: photosPickerItem) { _ in
                if let photosPickerItem = photosPickerItem {
                    Task{
                        if let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                            if let image = UIImage(data: data) {
                                firebaseManager.changeProfileImage(image)
                                print("profileImageURL: \(firebaseManager.profileImageURL)")
                              
                            }
                        }
                    }
                }
              
                
            }
            .onAppear{
                firebaseManager.fetchUserData()
            }
           
        }
    }
}

#Preview {
    ProfileScreen()
}


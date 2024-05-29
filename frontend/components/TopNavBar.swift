//
//  TopNavBar.swift
//  RealFlow
//
//  Created by Aran Ali on 2024-02-28.
//

/*
   TopNavBar is a SwiftUI view that displays the user's profile information at the top of the screen.
   It shows the user's profile image, name, and online status.
   The view fetches user data from Firebase when it appears.
*/

import SwiftUI

struct TopNavBar: View {
    
    
    @EnvironmentObject var firebaseManager: FirebaseManager
    @State var shouldShowLogOutOption: Bool = false
    
    var body: some View {
        VStack{
            
            HStack(spacing: 16){
                
                AsyncImage(url: firebaseManager.profileImageURL, content: { returnedImage in
                    returnedImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                    
                }, placeholder: {
                    Image(.maleAvatar)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                })
                
                VStack(alignment: .leading, spacing: 4){
                    Text("\(firebaseManager.firstName ?? "USERNAME")")
                        .font(.system(size: 24, weight: .bold))
                    HStack{
                        Circle()
                            .foregroundStyle(.green)
                            .frame(width: 14, height: 14)
                        Text("online")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.gray)
                    }
                }
                Spacer()
                
            }
            .padding()
            
        }
        .onAppear{
            firebaseManager.fetchUserData()
        }
        
    }
}

#Preview {
    TopNavBar()
}


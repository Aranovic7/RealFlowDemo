//
//  NewMessagesBtn.swift
//  RealFlow
//
//  Created by Aran Ali on 2024-02-28.
//

/*
   NewMessagesBtn is a SwiftUI view that provides a button for creating a new message.
   When the button is tapped, it presents a full-screen modal to create a new message.
*/


import SwiftUI

struct NewMessagesBtn: View {
        
    @State var showNewMessagesScreen = false
    
    var body: some View {
        Button(action: {
            showNewMessagesScreen.toggle()
        }, label: {
            HStack{
                Spacer()
                Text("+ New Message")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundStyle(Color.white)
            .padding(.vertical)
            .background(Color.blue)
            .clipShape(.rect(cornerRadius: 32))
            .padding(.horizontal)
            .shadow(radius: 15)
            .padding(.bottom)
            
            
        })
        .fullScreenCover(isPresented: $showNewMessagesScreen) {
            CreateNewMessageView()
        }
    }
}

#Preview {
    NewMessagesBtn()
}


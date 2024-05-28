//
//  NewMessagesBtn.swift
//  RealFlow
//
//  Created by Aran Ali on 2024-02-28.
//

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


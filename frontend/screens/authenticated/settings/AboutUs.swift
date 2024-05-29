//
//  AboutUs.swift
//  RealFlow
//
//  Created by Aran Ali on 2024-03-29.
//

// This screen's purpose is to give information to the user about what the app is about

import SwiftUI

struct AboutUs: View {
    var body: some View {
        ScrollView{
            VStack{
                
                Image("teamOfOne")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200)
                    .padding(.leading, 40)
                    .padding(.top, 40)
                
                
                Spacer()
                
                VStack(alignment: .leading){
                    Text("RealFlow Messaging")
                        .font(.system(size: 28))
                        .bold()
                        .padding()
                    
                    
                    Text("RealFlow is a messenger app in real time that was created by only one person to analyse how techniqual and effective communication affects us in different ways. For example in terms of clarity in communicating, etc. This is also why the name of the app is RealFlow Messaging")
                        .font(.system(size: 20))
                        .padding()
                        
                }.padding(.vertical)
                
                Image("groupchat")
                    .resizable()
                    .scaledToFit()
                    .padding()
                
                VStack(alignment: .leading){
                    Text("For everyone")
                        .font(.system(size: 28))
                        .bold()
                        .padding()
                    
                    Text(" I believe that everyone should have the possibility to express their feelings or opinions regardless of ethnicity, race and religion. RealFlow is for everyone!")
                        .font(.system(size: 20))
                        .padding()
                        
                }.padding(.vertical)
                
                Image("monsterchat")
                    .resizable()
                    .scaledToFit()
                
                VStack(alignment: .trailing){
                    Text("Good luck!")
                        .font(.system(size: 28))
                        .bold()
                        .padding()
                    
                    Text("Now good luck building up old relations or finding new ones. Don't forget to send your frineds some gifs to make them laugh!")
                        .font(.system(size: 20))
                        .padding()
                        
                }.padding(.vertical)
                
               
                
                
                Spacer()
                
                
                
                
            }
        }
    }
}

#Preview {
    AboutUs()
}


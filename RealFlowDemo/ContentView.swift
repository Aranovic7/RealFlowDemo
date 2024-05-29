//
//  ContentView.swift
//  RealFlow
//
//  Created by Aran Ali on 2024-02-18.
//

/*
   ContentView is the main entry point of the RealFlow app.
   It displays different views based on the user's login status.
   Logged-in users can access Messages, Profile, and Settings tabs, while logged-out users see the LoginScreen.
*/

import SwiftUI

struct ContentView: View {
    
    @StateObject var firebaseManager = FirebaseManager()
   
    
    var body: some View {
        if firebaseManager.isLoggedIn {
           
            TabView{
                
                MessagesScreen()
                
                    .tabItem {
                        Image(systemName: "bubble")
                        Text("Messages")
                    }
                
                ProfileScreen()
                
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }
                
                SettingsScreen()
                
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
            }
            .environmentObject(firebaseManager)
           
            
        } else {
            NavigationStack{
                LoginScreen()
                    
            }
            .environmentObject(firebaseManager)
            
              
        }
        
    }
}
  

#Preview {
    ContentView()
        .environmentObject(FirebaseManager())
}


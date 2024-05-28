//
//  ContentView.swift
//  RealFlow
//
//  Created by Aran Ali on 2024-02-18.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var firebaseManager = FirebaseManager()
   
    
    var body: some View {
        if firebaseManager.isLoggedIn {
           
            TabView{
                
//                NavigationView{
//                    MessagesScreen(selectedUser: $selectedUser)
//                }
                
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


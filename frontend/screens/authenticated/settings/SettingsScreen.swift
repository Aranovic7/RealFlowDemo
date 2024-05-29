//
//  SettingsScreen.swift
//  RealFlow
//
//  Created by Aran Ali on 2024-03-16.
//

/*
 This screen will display different sheets with settings options
 It let's the user change a language, apply dark theme, change password, read FAQ, and sign out
 */

import SwiftUI

struct SettingsScreen: View {
    
    @State var navigateToLanguageSettings: Bool = false
    @State var navigateToNotifications: Bool = false
    @State var navigateToApperance: Bool = false
    @State var navigateToPrivacy: Bool = false
    @State var navigateToHelp: Bool = false
    @State var navigateToAbout: Bool = false
    @State var showChangePasswordView: Bool = false
    @EnvironmentObject var firebaseManager: FirebaseManager
    
    func openLanguageSettings() {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { success in
                    if success {
                        print("Successfully opened settings")
                    } else {
                        print("Failed to open settings")
                    }
                })
            }
        }
    
    var body: some View {
        
        VStack{
            
            Text("Settings")
                .font(.title)
                .bold()
                .padding()
            
            ScrollView{
                
            VStack (spacing: 30) {
                
                HStack{
                    Text("General:")
                        .bold()
                        .font(.title3)
                        .padding(.leading, 40)
                    
                    Spacer()
                    
                } .padding(.top)
               
                    
                    HStack{
                        
                        Image(systemName: "flag")
                            .padding(.leading, 43)
                        
                        Text("Language")
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right")
                            .padding(.trailing, 40)
                        
                    }
                    .onTapGesture {
                       openLanguageSettings()
                       
                    }
                    
                    
                    HStack{
                        
                        Image(systemName: "eye")
                            .padding(.leading, 40)
                        
                        Text("Apperance")
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right")
                            .padding(.trailing, 40)
                        
                    }
                    .onTapGesture {
                        navigateToApperance = true
                        
                    }
                
                    Divider()
                        .frame(width: 315)
                
                HStack{
                    Text("Security:")
                        .bold()
                        .font(.title3)
                        .padding(.leading, 40)
                    Spacer()
                }
                
                HStack{
                    Image(systemName: "lock")
                        .padding(.leading, 40)
                    
                    Text("Change password")
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .padding(.trailing, 40)
                } .onTapGesture {
                    showChangePasswordView = true
                }
                
                HStack{
                    Text("Help & Support:")
                        .bold()
                        .font(.title3)
                        .padding(.leading, 40)
                    Spacer()
                }
                
                    HStack{
                        
                        Image(systemName: "beats.headphones")
                            .padding(.leading, 40)
                        
                        Text("Contact us")
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right")
                            .padding(.trailing, 40)
                        
                    }
                    .onTapGesture {
                        navigateToHelp = true
                    }
                    
                    HStack{
                        
                        Image(systemName: "questionmark.circle")
                            .padding(.leading, 40)
                        
                        Text("About")
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right")
                            .padding(.trailing, 40)
                        
                    }
                    .onTapGesture {
                        navigateToAbout = true
                    }
                
                HStack{
                    Button(action: {
                        firebaseManager.logout()
                        print("signing out...")
                    }) {
                        Text("Sign out")
                        Image(systemName: "door.left.hand.open")
                    }
                    
                }
                .foregroundStyle(Color.red)
                .padding()
                    
                }
            }
        }
        .sheet(isPresented: $navigateToApperance) {
            ApperanceScreen()
        }
        .sheet(isPresented: $navigateToHelp) {
            ContactUsScreen()
        }
        .sheet(isPresented: $navigateToAbout) {
            AboutUs()
        }
        .sheet(isPresented: $showChangePasswordView, content: {
            ChangePasswordScreen()
        })
    }
}

#Preview("English") {
    SettingsScreen()
}
#Preview("Deutsch") {
    SettingsScreen()
        .environment(\.locale, Locale(identifier: "DE"))
}
#Preview("French") {
    SettingsScreen()
        .environment(\.locale, Locale(identifier: "FR"))
}
#Preview("Espanol") {
    SettingsScreen()
        .environment(\.locale, Locale(identifier: "ES"))
}
#Preview("Svenska") {
    SettingsScreen()
        .environment(\.locale, Locale(identifier: "SV"))
}


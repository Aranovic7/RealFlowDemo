//
//  ApperanceScreen.swift
//  RealFlow
//
//  Created by Aran Ali on 2024-03-19.
//

// In this ui file we let the user have the option to choose between light or dark mode

import SwiftUI

struct ApperanceScreen: View {
    
    @AppStorage("isDarkMode") var isDark: Bool = false
    
    var body: some View {
        VStack{
            
            Text(isDark ? "Dark Theme" : "Light Theme")
                .preferredColorScheme(isDark ? .dark : .light)
                .font(.title)
                .bold()
            
            Spacer()
            
            ZStack{
                
                Image(systemName: isDark ? "lightbulb.fill" : "lightbulb")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
            }
            
            Spacer()
            
            Toggle(isOn: $isDark) {
                
                Text(isDark ? "Activate Light Theme": "Activate Dark Theme")
                    .bold()
                
                Image(systemName: isDark ? "lightbulb.fill" : "lightbulb")
            }
            
        }
        // .tint(lightTheme ? Color.black : Color.white)
        .toggleStyle(.button)
        .padding()
        .environment(\.colorScheme, isDark ? .dark : .light)
        
        
    }
    
    
    
}


#Preview {
    ApperanceScreen()
}


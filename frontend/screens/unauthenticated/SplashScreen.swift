//
//  SplashScreen.swift
//  RealFlow
//
//  Created by Aran Ali on 2024-03-07.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack{
            VStack{
                
                Text("RealFlow")
                    .font(.system(size: 36))
                    .bold()
                    .padding()
                
                Spacer()
                
                Image("IllustrationSplash")
                    .resizable()
                    .scaledToFit()
                    .padding()
                
                Spacer()
                
                Text("Loading.....")
                    .font(.title2)
                    .bold()
                    .padding()
                
                ProgressView()
                    .scaleEffect(2)
                
                
                Spacer()
            }
            
            
            
        }
    }
}

#Preview {
    SplashScreen()
}


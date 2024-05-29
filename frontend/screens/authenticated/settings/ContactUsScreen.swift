//
//  ContactUsScreen.swift
//  RealFlow
//
//  Created by Aran Ali on 2024-03-24.
//

import SwiftUI

struct ContactUsScreen: View {
    
    @State var navigateToFAQ: Bool = false
    @State var navigateToSupportChat: Bool = false
    
    var body: some View {
        VStack{
            
            // Title and instructions
            
            Text("Do you have any questions, or need help? We are here to help you.")
                .font(.title3)
                .bold()
                .padding(30)
            
            // Options to read FAQ or contact support
            
            VStack(spacing: 40){
                
                ZStack{
                    
                        Rectangle()
                            .frame(width: 360, height: 100)
                            .foregroundStyle(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black.opacity(0.3))
                            )
                            .overlay(
                                Image(systemName: "questionmark.bubble")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(.circle)
                                    .padding(.trailing, 270)
                            )
                    
                    VStack(alignment: .leading){
                        
                        Text("Read FAQ")
                            .bold()
                            .padding(.bottom, 2)
                        
                        Text("Read our answers to most commonly asked questions")
                            .font(.system(size: 14))
                        
                    } .padding(.leading, 65)
                    
                } .onTapGesture {
                    print("help")
                    navigateToFAQ = true
                }
                
                
                ZStack{
                    
                    Rectangle()
                        .frame(width: 360, height: 100)
                        .foregroundStyle(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black.opacity(0.3))
                        )
                        .overlay(
                            Image(systemName: "bubble.left.and.bubble.right")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .clipShape(.circle)
                                .padding(.trailing, 270)
                        )
                
                VStack(alignment: .leading){
                    
                    Text("Contact us")
                        .bold()
                        .padding(.bottom, 2)
                    
                    Text("Contact us thorugh email")
                        .font(.system(size: 14))
                    
                } .padding(.trailing)
                    
                } .onTapGesture {
                   navigateToSupportChat = true
                    print("navigateToSupportChat: \(navigateToSupportChat)")
                }
                
            }
            
            Spacer()
            
               
        }
        .sheet(isPresented: $navigateToFAQ) {
            FAQScreen()
        }
        .sheet(isPresented: $navigateToSupportChat) {
            SupportMailView()
        }
      
    }
}

#Preview {
    ContactUsScreen()
}


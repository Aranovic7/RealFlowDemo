//
//  ChangePasswordScreen.swift
//  RealFlow
//
//  Created by Aran Ali on 2024-04-15.
//

import SwiftUI

struct ChangePasswordScreen: View {
    
    @State var value: String = ""
    @State var showPassword: Bool = false
    @State var newPassword: String = ""
    @EnvironmentObject var firebaseManager: FirebaseManager
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack{
            
            Image("lock.illustrations")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
            
            Text("Reset Password")
                .font(.title)
                .bold()
                .padding()
            
            
            HStack{
                Image(systemName: "lock")
                    .foregroundStyle(.gray)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 8, content: {
                    if showPassword {
                        TextField("Current Password", text: $value)
                    } else {
                        SecureField("Current Password", text: $value)
                    }
                    
                    Divider()
                })
                .overlay(alignment: .trailing) {
                    Button(action: {
                        withAnimation{
                            showPassword.toggle()
                        }
                    }, label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundStyle(Color.gray)
                            .padding(10)
                            .contentShape(.rect)
                    })
                }
            }.padding()
             .padding(.top, 40)
            
            HStack{
                Image(systemName: "lock")
                    .foregroundStyle(.gray)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 8, content: {
                    if showPassword {
                        TextField("New Password", text: $newPassword)
                    } else {
                        SecureField("New Password", text: $newPassword)
                    }
                    
                    Divider()
                })
                .overlay(alignment: .trailing) {
                    Button(action: {
                        withAnimation{
                            showPassword.toggle()
                        }
                    }, label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundStyle(Color.gray)
                            .padding(10)
                            .contentShape(.rect)
                    })
                }
            } .padding()
            
            HStack{
                Image(systemName: "lock")
                    .foregroundStyle(.gray)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 8, content: {
                    if showPassword {
                        TextField("Repeat New Password", text: $newPassword)
                    } else {
                        SecureField("Repeat New Password", text: $newPassword)
                    }
                    
                    Divider()
                })
                .overlay(alignment: .trailing) {
                    Button(action: {
                        withAnimation{
                            showPassword.toggle()
                        }
                    }, label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundStyle(Color.gray)
                            .padding(10)
                            .contentShape(.rect)
                    })
                }
            } .padding()
            
            Button(action: {
                let currentPassword = self.value
                let newPassword = self.newPassword
                
                if currentPassword.isEmpty || newPassword.isEmpty {
                    showAlert = true
                    alertMessage = "Please fill in all required fields."
                } else if newPassword != self.newPassword {
                    print("Passwords don't match")
                } else {
                    firebaseManager.changePassword(currentPassword: currentPassword, newPassword: newPassword)
                }
             
                
               
                
            }, label: {
                Text("Change Password")
                    .foregroundStyle(Color.white)
                    .bold()
                    .frame(width: 170, height: 50)
                    .background(Color.black)
                    .clipShape(.rect(cornerRadius: 10))
                  
            }).padding()

             
            Spacer()
        } .alert(isPresented: $showAlert) {
            Alert(title: Text("Alert"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    ChangePasswordScreen()
}


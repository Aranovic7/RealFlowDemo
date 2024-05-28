import SwiftUI

struct LoginScreen: View {
    
    @State var navigateToRegisterScreen: Bool = false
    @State var errorMessage: String = ""
    
    @EnvironmentObject var firebaseManager: FirebaseManager
    
    var body: some View {
        VStack{
            
            VStack{
                
                Text("Welcome to RealFlow")
                    .font(.title)
                    .bold()
                    .padding()
                
                Spacer()
                
                Text("This app is made for you and your friends to have an easier communication!")
                    .bold()
                    .padding()
                
                Spacer()
                
                TextField("Username", text: $firebaseManager.usernameInput)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding()
                
                SecureField("Password", text: $firebaseManager.passwordInput)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding()
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Button(action: {
                    print("Button 'sign in' was pressed")
                    if validateInputs() {
                        firebaseManager.login(usernameInput: firebaseManager.usernameInput, passwordInput: firebaseManager.passwordInput)
                    }
                }, label: {
                    Text("Sign in")
                        .bold()
                        .font(.title2)
                        .foregroundStyle(.white)
                        .frame(width: 250, height: 40)
                        .background(Color.black)
                        .clipShape(Rectangle())
                        .cornerRadius(10)
                })
                
                Spacer()
                
                Text("Don't have an account? Register now")
                
                Button(action: {
                    print("Button 'register' was pressed")
                    navigateToRegisterScreen = true
                    
                }, label: {
                    Text("Register")
                        .bold()
                        .font(.title2)
                        .foregroundStyle(.white)
                        .frame(width: 250, height: 40)
                        .background(Color.black)
                        .clipShape(Rectangle())
                        .cornerRadius(10)
                })
                
                Spacer()
                
                Text("Made by Aran Ali")
            }
            
            NavigationLink(destination: RegisterScreen(), isActive: $navigateToRegisterScreen) {
                EmptyView()
            }
        }.navigationBarBackButtonHidden()
    }
    
    func validateInputs() -> Bool {
        errorMessage = ""
        
        if firebaseManager.usernameInput.isEmpty {
            errorMessage = "Username cannot be empty"
            return false
        }
        
        if firebaseManager.passwordInput.isEmpty {
            errorMessage = "Password cannot be empty"
            return false
        }
        
        // Additional validation checks can be added here
        
        return true
    }
    
}

#Preview {
    LoginScreen().environmentObject(FirebaseManager())
}


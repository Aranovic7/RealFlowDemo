import SwiftUI
import PhotosUI

struct RegisterScreen: View {
    
    @EnvironmentObject var firebaseManager: FirebaseManager
    
    @State var photosPickerItem: PhotosPickerItem?
    
    @State private var navigateToLoginScreen = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack{
        
                Text("Create your account")
                    .font(.title)
                    .bold()
                    .padding()
            
            HStack(spacing: 20){
                PhotosPicker(selection: $photosPickerItem, matching: .images) {
                    Image(uiImage: firebaseManager.profileImage ?? .maleAvatar)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(.circle)
                }
               
                
                VStack(alignment: .leading){
                    Text("John Doe")
                        .font(.largeTitle.bold())
                    
                    Text("iOS Developer")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                }
                
                Spacer()
                      
                     
            }
            .padding(.leading, 30)
            .onChange(of: photosPickerItem) { _, _ in
                Task {
                    if let photosPickerItem,
                       let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            firebaseManager.profileImage = image
                        }
                    }
                    
                    photosPickerItem = nil
                }
                
            }
            
            TextField("Firstname", text: $firebaseManager.firstName)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding()
            
            TextField("Lastname", text: $firebaseManager.lastName)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding()
                
            TextField("Username", text: $firebaseManager.registerUsernameInput)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding()
                
            SecureField("Password", text: $firebaseManager.registerPasswordInput)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding()
                
            SecureField("Repeat password", text: $firebaseManager.repeatPasswordInput)
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
                
            Text("Already have an account? Sign in")
                .foregroundStyle(.blue)
                .onTapGesture {
                    print("Go back to LoginScreen")
                }
                
            Spacer()
                
            Button(action: {
                if validateInputs() {
                    firebaseManager.registerUser(registerUsernameInput: firebaseManager.registerUsernameInput, registerPasswordInput: firebaseManager.registerPasswordInput, repeatPasswordInput: firebaseManager.repeatPasswordInput, firstName: firebaseManager.firstName, lastName: firebaseManager.lastName, profileImage: firebaseManager.profileImage)
                    
                    navigateToLoginScreen = true
                    
                    firebaseManager.resetRegisterFields()
                }
            }, label: {
                Text("Create account")
                    .bold()
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 250, height: 50)
                    .background(Color.black)
                    .clipShape(Rectangle())
                    .cornerRadius(10)
                    .padding()
            })
                
            Spacer()
        }
        .background(
            NavigationLink(destination: LoginScreen(), isActive: $navigateToLoginScreen) {
                            EmptyView()
                        }
        )
    }
    
    func validateInputs() -> Bool {
        errorMessage = ""
        
        if firebaseManager.firstName.isEmpty {
            errorMessage = "Firstname cannot be empty"
            return false
        }
        
        if firebaseManager.lastName.isEmpty {
            errorMessage = "Lastname cannot be empty"
            return false
        }
        
        if firebaseManager.registerUsernameInput.isEmpty {
            errorMessage = "Username cannot be empty"
            return false
        }
        
        if firebaseManager.registerPasswordInput.isEmpty {
            errorMessage = "Password cannot be empty"
            return false
        }
        
        if firebaseManager.registerPasswordInput != firebaseManager.repeatPasswordInput {
            errorMessage = "Passwords do not match"
            return false
        }
        
        // Additional validation checks can be added here
        
        return true
    }
}

#Preview {
    RegisterScreen().environmentObject(FirebaseManager())
}


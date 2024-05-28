//  FirebaseManager.swift
//  RealFlow
//
//  Created by Aran Ali on 2024-02-27.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct UserData: Identifiable {
    var id = UUID()
    var username: String
    var profileImageURL: URL?
    var userID: String
}

struct Message: Identifiable, Equatable {
    var id = UUID()
    var text: String
    var senderID: String
    var recipientID: String
    var timestamp: Date // Används för att ordna meddelandena efter tidpunkt
    var imageURL: String?
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
    
}

struct RecentMessage: Identifiable {
    var id: String { documentID }
    
    let documentID: String
    let text: String
    let username: String
    let senderID: String
    let recipientID: String
    let timestamp: Timestamp
    let profileImageURL: String?
    
    init(documentID: String, data: [String: Any]) {
        self.documentID = documentID
        self.text = data["message"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
        self.senderID = data["senderID"] as? String ?? ""
        self.recipientID = data["recipientID"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.profileImageURL = data["profileImageURL"] as? String
    }
}

class FirebaseManager: ObservableObject {
    
    var db = Firestore.firestore() // Creating first instance of database
    var auth = Auth.auth() // Creating first instance of authentication
    let USER_DATA_COLLECTION = "users" // name of collection in firestore
    let USER_IMAGES_COLLECTION = "images"
    let storage = Storage.storage() // Initialize firebase Storage
    let MESSAGES_COLLECTION = "messages"
    let RECENT_MESSAGES_COLLECTION = "recent_messages"
    
    @Published var isLoggedIn: Bool = false
    @Published var usernameInput: String = ""
    @Published var passwordInput: String = ""
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var username: String = ""
    
    @Published var registerUsernameInput: String = ""
    @Published var registerPasswordInput: String = ""
    @Published var repeatPasswordInput: String = ""
    
    @Published var profileImage: UIImage?
    @Published var profileImageURL: URL?
    
    @Published var usersData: [UserData] = []
    
    @Published var currentUserUID: String?
    
    var messagesListener: ListenerRegistration?
    
    @Published var chatText: String = ""
    @Published var messages: [Message] = []
    @Published var count: Int = 0
    
    @Published var recentMessages = [RecentMessage]()
    
   
    
   
        
        func handleSend(text: String?, image: UIImage?, recipientId: String) {
            saveMessage(text: text, image: image, recipientID: recipientId) { success in
                if success {
                    DispatchQueue.main.async {
                        if text != nil {
                            self.chatText = "" // Rensa textfältet efter att textmeddelandet har skickats
                        }
                    }
                    self.fetchMessages(recipientID: recipientId) { messages in
                        self.messages = messages
                    }
                } else {
                    print("Error trying to save message")
                }
            }
        }
        
        
        
        // Funktion för att registrera en användare
        func uploadImage(_ image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
            guard let imageData = image.jpegData(compressionQuality: 0.5) else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Fel vid konvertering av bild till data"])))
                return
            }
            
            let imageRef = storage.reference().child("images/\(UUID().uuidString).jpg")
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            imageRef.putData(imageData, metadata: metadata) { metadata, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    imageRef.downloadURL { url, error in
                        if let error = error {
                            completion(.failure(error))
                        } else if let url = url {
                            completion(.success(url))
                        } else {
                            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Ingen URL returnerad"])))
                        }
                    }
                }
            }
        }
        
        func registerUser(registerUsernameInput: String, registerPasswordInput: String, repeatPasswordInput: String, firstName: String, lastName: String, profileImage: UIImage?) {
            if registerPasswordInput == repeatPasswordInput {
                auth.createUser(withEmail: registerUsernameInput, password: registerPasswordInput) { authResult, error in
                    if let error = error {
                        print("Fel vid registrering av användare: \(error)")
                    } else {
                        print("Användare registrerad framgångsrikt")
                        
                        // lagra användarinformation i firestore
                        guard let userID = authResult?.user.uid else {
                            print("Användarens UID saknas")
                            return
                        }
                        
                        var userData: [String: Any] = [
                            "username": registerUsernameInput,
                            "password": registerPasswordInput,
                            "createdAt": FieldValue.serverTimestamp(),
                            "firstName": firstName,
                            "lastName": lastName,
                            "userID": userID
                        ]
                        
                        if let profileImage = profileImage {
                            // Ladda upp profilbilden
                            self.uploadImage(profileImage) { result in
                                switch result {
                                case .success(let url):
                                    // Spara bildens URL i användardatan
                                    userData["profileImageURL"] = url.absoluteString
                                    
                                    // Spara användarinformation i Firestore
                                    self.db.collection(self.USER_DATA_COLLECTION).document(userID).setData(userData) { error in
                                        if let error = error {
                                            print("Fel vid uppladdning av användardata till Firestore: \(error)")
                                        } else {
                                            print("Användardata uppladdad till Firestore")
                                            print("registerUsernameInput: \(registerUsernameInput)")
                                        }
                                    }
                                case .failure(let error):
                                    print("Fel vid uppladdning av profilbild: \(error)")
                                }
                            }
                        } else {
                            // Om ingen profilbild valdes, spara bara användarinformationen
                            self.db.collection(self.USER_DATA_COLLECTION).document(userID).setData(userData) { error in
                                if let error = error {
                                    print("Fel vid uppladdning av användardata till Firestore: \(error)")
                                } else {
                                    print("Användardata uppladdad till Firestore")
                                    print("registerUsernameInput: \(registerUsernameInput)")
                                }
                            }
                        }
                    }
                }
            } else {
                print("Lösenorden matchar inte")
            }
        }
        
        
        func login(usernameInput: String, passwordInput: String) {
            print("Attempting to log in with email: \(usernameInput) and password: \(passwordInput)")
            
            auth.signIn(withEmail: usernameInput, password: passwordInput) { authResult, error in
                if let error = error as NSError? {
                    if error.code == AuthErrorCode.invalidEmail.rawValue {
                        print("Invalid email format.")
                    } else if error.code == AuthErrorCode.wrongPassword.rawValue {
                        print("Wrong password.")
                    } else if error.code == AuthErrorCode.userNotFound.rawValue {
                        print("User not found.")
                    } else if error.code == AuthErrorCode.userDisabled.rawValue {
                        print("User account is disabled.")
                    } else if error.code == AuthErrorCode.invalidCredential.rawValue {
                        print("The supplied auth credential is malformed or has expired.")
                    } else {
                        print("Error: \(error.localizedDescription)")
                    }
                } else {
                    print("Log in success")
                    print("Logged in with: \(self.auth.currentUser?.email ?? "")")
                    self.isLoggedIn = true
                    print(self.isLoggedIn)
                }
            }
        }
        
    func resetRegisterFields() {
           registerUsernameInput = ""
           registerPasswordInput = ""
           repeatPasswordInput = ""
           firstName = ""
           lastName = ""
           profileImage = nil
       }
        
        
        
        func logout() {
            do {
                try auth.signOut()
                // återställ eventuell data
                usernameInput = ""
                passwordInput = ""
                firstName = ""
                lastName = ""
                isLoggedIn = false
            } catch let error {
                print("error trying to sign out: \(error)")
            }
        }
        
        
        func fetchUserData() {
            
            guard let currentUser = auth.currentUser?.uid else { return }
            
            self.currentUserUID = currentUser // Spara det inloggade användarkontots ID
            
            print("currentUser in fetchUserData: \(currentUser)")
            
            db.collection(USER_DATA_COLLECTION).document(currentUser).getDocument{ documentSnapshot, error in
                if let error = error {
                    print("Error fetching data: \(error)")
                } else if let document = documentSnapshot, document.exists {
                    if let data = document.data(), let firstName = data["firstName"] as? String, let lastName = data["lastName"] as? String, let username = data["username"] as? String {
                        self.firstName = firstName
                        self.lastName = lastName
                        self.username = username
                        
                        if let profileImageURLString = data["profileImageURL"] as? String {
                            self.profileImageURL = URL(string: profileImageURLString)
                        }
                    }
                }
            }
            
        }
        
        func changePassword(currentPassword: String, newPassword: String){
            
            guard let currentUser = auth.currentUser else {return}
            
            let credential = EmailAuthProvider.credential(withEmail: currentUser.email!, password: currentPassword)
            
            currentUser.updatePassword(to: newPassword) { error in
                if let error = error {
                    print("Error updating password: \(error)")
                } else {
                    print("Password updated successfully")
                }
                
            }
        }
        
    func changeProfileImage(_ image: UIImage) {
        
        guard let currentUser = auth.currentUser else {return}
        
        uploadImage(image) { result in
            switch result {
            case .success(let url):
                let userDataRef = self.db.collection(self.USER_DATA_COLLECTION).document(currentUser.uid)
                userDataRef.updateData(["profileImageURL": url.absoluteString]) { error in
                    if let error = error {
                        print("error updating data: \(error)")
                    } else {
                        print("Profile picture updated successfully")
                        self.profileImageURL = url
                        self.updateRecentMessagesProfileImageURL(forUserID: currentUser.uid, newProfileImageURL: url.absoluteString)
                                        
                    }
                }
            case.failure(let error):
                print("Fel vid uppladdning av profilbild: \(error)")
            }
            
        }
    }
    
    func updateRecentMessagesProfileImageURL(forUserID userID: String, newProfileImageURL: String) {
        // Uppdatera profilbilden för alla användare som har mottagit meddelanden från den aktuella användaren
        
        db.collectionGroup("messages").whereField("senderID", isEqualTo: userID).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("No recent messages documents found")
                return
            }
            
            for document in documents {
                document.reference.updateData(["profileImageURL": newProfileImageURL]) { error in
                    if let error = error {
                        print("Failed to update profile image URL in recent messages: \(error)")
                    } else {
                        print("Profile image URL updated successfully in recent messages")
                    }
                }
            }
        }
        
        // Uppdatera profilbilden för alla användare som har skickat meddelanden till den aktuella användaren
        db.collectionGroup("messages").whereField("recipientID", isEqualTo: userID).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("No recent messages documents found for recipientID")
                return
            }
            
            for document in documents {
                document.reference.updateData(["profileImageURL": newProfileImageURL]) { error in
                    if let error = error {
                        print("Failed to update profile image URL in recent messages: \(error)")
                    } else {
                        print("Profile image URL updated successfully in recent messages for recipientID")
                    }
                }
            }
        }
    }



        

         
        
        func fetchAllUsers(completion: @escaping ([UserData]) -> Void) {
            var usersData: [UserData] = [] // Skapa en tom array för att lagra användardata
            
            db.collection(USER_DATA_COLLECTION).getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error fetching all users: \(error)")
                    completion([])
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    completion([])
                    return
                }
                
                for document in documents {
                    let userData = document.data()
                    if let firstName = userData["firstName"] as? String,
                       let lastName = userData["lastName"] as? String,
                       let profileImageURLString = userData["profileImageURL"] as? String,
                       let profileImageURL = URL(string: profileImageURLString),
                       let username = userData["username"] as? String {
                        if document.documentID != self.currentUserUID {
                            let user = UserData(username: username, profileImageURL: profileImageURL, userID: document.documentID)
                            usersData.append(user)
                        }
                        
                    }
                }
                
                completion(usersData) // Skicka tillbaka den fyllda arrayen när alla användare har hämtats
            }
        }
        
        func fetchRecipientID(for username: String, completion: @escaping (String?) -> Void) {
            db.collection(USER_DATA_COLLECTION).whereField("username", isEqualTo: username).getDocuments { (snapshot, error) in
                guard let documents = snapshot?.documents, let document = documents.first else {
                    completion(nil)
                    return
                }
                let userID = document.documentID
                completion(userID)
            }
        }
    
    func saveMessage(text: String?, image: UIImage?, recipientID: String, completion: @escaping (Bool) -> Void) {
        guard let senderID = auth.currentUser?.uid else {
            completion(false)
            return
        }

        var messageData: [String: Any] = [
            "senderID": senderID,
            "recipientID": recipientID,
            "timestamp": FieldValue.serverTimestamp()
        ]

        if let image = image {
            print("Starting image upload...")
            uploadImage(image) { result in
                switch result {
                case .success(let url):
                    print("Image uploaded successfully: \(url)")
                    messageData["imageURL"] = url.absoluteString
                    
                    let document = self.db.collection(self.MESSAGES_COLLECTION)
                        .document(senderID)
                        .collection(recipientID)
                        .document()
                    
                    let recipientMessageDocument = self.db.collection(self.MESSAGES_COLLECTION)
                        .document(recipientID)
                        .collection(senderID)
                        .document()
                    
                    document.setData(messageData) { error in
                        if let error = error {
                            print("Error saving image message for sender: \(error)")
                            completion(false)
                        } else {
                            print("Image message saved for sender")
                            completion(true)
                            self.persistRecentMessages(toRecipientID: recipientID, text: text)
                        }
                    }
                    
                    recipientMessageDocument.setData(messageData) { error in
                        if let error = error {
                            print("Error saving image message for recipient: \(error)")
                            completion(false)
                        } else {
                            print("Image message saved for recipient")
                            completion(true)
                            self.persistRecentMessages(toRecipientID: recipientID, text: text)
                        }
                    }
                    
                case .failure(let error):
                    print("Error uploading image: \(error)")
                    completion(false)
                }
            }
        } else if let text = text, !text.isEmpty {
            print("Saving text message...")
            messageData["message"] = text
            
            let document = db.collection(MESSAGES_COLLECTION)
                .document(senderID)
                .collection(recipientID)
                .document()
            
            let recipientMessageDocument = self.db.collection(self.MESSAGES_COLLECTION)
                .document(recipientID)
                .collection(senderID)
                .document()
            
            document.setData(messageData) { error in
                if let error = error {
                    print("Error saving text message for sender: \(error)")
                    completion(false)
                } else {
                    print("Text message saved for sender")
                    completion(true)
                    self.persistRecentMessages(toRecipientID: recipientID, text: text)
                }
            }
            
            recipientMessageDocument.setData(messageData) { error in
                if let error = error {
                    print("Error saving text message for recipient: \(error)")
                    completion(false)
                } else {
                    print("Text message saved for recipient")
                    completion(true)
                    self.persistRecentMessages(toRecipientID: recipientID, text: text)
                }
            }
        } else {
            print("No message or image to save.")
            completion(false)
        }
    }


    
    func persistRecentMessages(toRecipientID: String, text: String?) {
        guard let senderID = auth.currentUser?.uid else {
            return
        }

        // Fetch recipient's profile image URL and username from Firestore
        let recipientDocumentRef = db.collection(USER_DATA_COLLECTION).document(toRecipientID)
        recipientDocumentRef.getDocument { recipientSnapshot, error in
            guard let recipientDocument = recipientSnapshot, recipientDocument.exists, let recipientData = recipientDocument.data() else {
                print("Error fetching recipient data: \(error?.localizedDescription ?? "No error description")")
                return
            }

            let recipientProfileImageURL = recipientData["profileImageURL"] as? String ?? ""
            let recipientUsername = recipientData["username"] as? String ?? "Unknown"

            // Fetch sender's profile image URL and username from Firestore
            let senderDocumentRef = self.db.collection(self.USER_DATA_COLLECTION).document(senderID)
            senderDocumentRef.getDocument { senderSnapshot, error in
                guard let senderDocument = senderSnapshot, senderDocument.exists, let senderData = senderDocument.data() else {
                    print("Error fetching sender data: \(error?.localizedDescription ?? "No error description")")
                    return
                }

                let senderProfileImageURL = senderData["profileImageURL"] as? String ?? ""
                let senderUsername = senderData["username"] as? String ?? "Unknown"

                // Prepare data to save for recipient
                let recipientRecentMessageData: [String: Any] = [
                    "timestamp": Timestamp(),
                    "senderID": senderID,
                    "username": senderUsername,
                    "recipientID": toRecipientID,
                    "profileImageURL": senderProfileImageURL,
                    "message": text ?? ""
                ]

                // Prepare data to save for sender
                let senderRecentMessageData: [String: Any] = [
                    "timestamp": Timestamp(),
                    "senderID": toRecipientID,
                    "username": recipientUsername,
                    "recipientID": senderID,
                    "profileImageURL": recipientProfileImageURL,
                    "message": text ?? ""
                ]

                // Save recent message for recipient
                let recipientRecentMessageDocument = self.db.collection(self.RECENT_MESSAGES_COLLECTION)
                    .document(toRecipientID)
                    .collection("messages")
                    .document(senderID)

                recipientRecentMessageDocument.setData(recipientRecentMessageData) { error in
                    if let error = error {
                        print("Failed to save recipient's recent messages: \(error)")
                        return
                    }
                }

                // Save recent message for sender
                let senderRecentMessageDocument = self.db.collection(self.RECENT_MESSAGES_COLLECTION)
                    .document(senderID)
                    .collection("messages")
                    .document(toRecipientID)

                senderRecentMessageDocument.setData(senderRecentMessageData) { error in
                    if let error = error {
                        print("Failed to save sender's recent messages: \(error)")
                        return
                    }
                }
            }
        }
    }
    
    func fetchMessages(recipientID: String, completion: @escaping ([Message]) -> Void) {
        guard let senderID = auth.currentUser?.uid else {
            return
        }

        db.collection(MESSAGES_COLLECTION)
            .document(senderID)
            .collection(recipientID)
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching messages: \(error)")
                    completion([])
                    return
                }
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    completion([])
                    return
                }

                var messages: [Message] = []
                for document in documents {
                    let messageData = document.data()
                    if let senderID = messageData["senderID"] as? String,
                       let recipientID = messageData["recipientID"] as? String,
                       let timestamp = messageData["timestamp"] as? Timestamp {
                        let text = messageData["message"] as? String ?? ""
                        let imageURL = messageData["imageURL"] as? String
                        let message = Message(text: text, senderID: senderID, recipientID: recipientID, timestamp: timestamp.dateValue(), imageURL: imageURL)
                        messages.append(message)
                    }
                }
                DispatchQueue.main.async {
                    completion(messages)
                }
            }
    }

    
    func fetchRecentMessages() {
        guard let currentUserID = auth.currentUser?.uid else {
            print("Error: No current user ID")
            return
        }

        print("Fetching recent messages for user ID: \(currentUserID)")

        // Lyssna på ändringar i recent_messages-samlingen för den aktuella användaren
        db.collection(RECENT_MESSAGES_COLLECTION)
            .document(currentUserID)
            .collection("messages")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Failed to listen for recent messages: \(error)")
                    return
                }

                var recentMessages = [RecentMessage]()

                snapshot?.documents.forEach { document in
                    let data = document.data()
                    let recentMessage = RecentMessage(documentID: document.documentID, data: data)
                    recentMessages.append(recentMessage)
                }

                DispatchQueue.main.async {
                    self.recentMessages = recentMessages
                    print("Updated recent messages: \(self.recentMessages)")
                }
            }
    }









    
        
        
        
        
        // Ny funktion för att hämta användare med konversationer
        
        
        
        
    }
    


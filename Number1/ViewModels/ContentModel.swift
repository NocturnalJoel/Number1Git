//
//  ContentModel.swift
//  Number1
//

import Foundation
import UserNotifications
import SwiftUI
import Firebase
import UIKit
import BackgroundTasks
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import FBSDKLoginKit
import FirebaseFirestore




class ContentModel: ObservableObject {
    
    //@Published var selectedProfiles: [Profile] = []
    
    @Published var profiles: [Profile] = []
    
    @Published var prompts: [Prompt] = []
    
    @Published var historyElements: [HistoryElement] = []
    
    @Published var promptOfTheDay: String = "No Prompt Yet"
    
    @Published var notificationsPermissionGranted = false
    
    @Published var showAlert = false
    
    @Published var currentUser: Profile?
    
    @Published var canSeeWhoVoted = false
    
    @Published var goOn = false
    
    @Published var loggedIn = false
    
    @Published var isLogInSuccessed = false
    
    @Published var communities: [String] = []
    
    init() {
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        
    }
    
    func getUsers() {
        
        let db = Firestore.firestore()
        
        let users = db.collection("Users")
        
        users.getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil {
                var profiles = [Profile]()
                
                for doc in snapshot!.documents {
                    
                    var p = Profile()
                    
                    p.id = doc.documentID as? String ?? UUID().uuidString
                    p.name = doc["name"] as? String ?? ""
                    p.numberOfVotesProfile = doc["numberOfVotesProfile"] as? Int ?? 0
                    p.listPosition = doc["listPosition"] as? Int ?? 0
                    p.hasVoted = doc["hasVoted"] as? Bool ?? false
                    p.hasVotedForPrompt = doc["hasVotedForPrompt"] as? Bool ?? false
                    p.greenDot = doc["greenDot"] as? Bool ?? false
                    p.isSelected = doc["isSelected"] as? Bool ?? false
                    p.votedForMe = doc["votedForMe"] as? [String] ?? []
                    p.fcmToken = doc["fcmToken"] as? String ?? ""
                    p.profileImageURL = doc["profileImageURL"] as? String ?? ""
                    
                    if let commentsArray = doc["comments"] as? [[String: Any]] {
                                        var comments = [Comment]()
                                        for commentData in commentsArray {
                                            var comment = Comment()
                                            comment.id = UUID().uuidString // You can also use a specific field from the comment data if it exists
                                            comment.name = commentData["name"] as? String ?? "Unknown"
                                            comment.comment = commentData["comment"] as? String ?? ""
                                            comment.profileImageURLComment = commentData["profileImageURLComment"] as? String
                                            comments.append(comment)
                                        }
                                        p.comments = comments
                                    }
                    
                    profiles.append(p)
                }
                DispatchQueue.main.async {
                    
                    self.profiles = profiles
                    
                }
            }
        }
        
    }
    
    func fetchCommunityNames() {
        
        var db = Firestore.firestore()
            // Access the "Communities" collection
            db.collection("Communities").getDocuments { (querySnapshot, err) in
                if let err = err {
                    // Handle any errors
                    print("Error getting documents: \(err)")
                } else {
                    // Clear the communities array
                    self.communities.removeAll()
                    
                    // Iterate through the documents returned
                    for document in querySnapshot!.documents {
                        // Get the "CommName" field as a string
                        let commName = document.get("CommName") as? String ?? ""
                        
                        // Append the community name to the communities array
                        self.communities.append(commName)
                    }
                    
                    // Dispatch to the main thread if any UI update is needed
                    DispatchQueue.main.async {
                        self.objectWillChange.send()
                    }
                }
            }
        }
    
    func fetchHistory() {
        
        let db = Firestore.firestore()
        
        db.collection("History").getDocuments { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                var fetchedHistoryElements: [HistoryElement] = []
                
                for document in querySnapshot!.documents {
                    
                    let data = document.data()
                    
                    var historyElement = HistoryElement()
                    
                    historyElement.id = document.documentID
                    historyElement.topPerson = data["topPerson"] as? String ?? ""
                    historyElement.dailyPrompt = data["dailyPrompt"] as? String ?? ""
                    
                    if let timestamp = data["date"] as? Timestamp {
                        let date = timestamp.dateValue()
                        
                        // Convert Date to String as per your formatting needs
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let dateString = dateFormatter.string(from: date)
                        
                        historyElement.date = dateString
                    }
                    
                    fetchedHistoryElements.append(historyElement)
                }
                
                DispatchQueue.main.async {
                    self.historyElements = fetchedHistoryElements
                }
                
            }
        }
    }
    
    func getPrompt() {
        let db = Firestore.firestore()
        let promptColl = db.collection("theDailyPrompt")
        
        promptColl.getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                
                var daPrompt = ""
                for doc in snapshot!.documents{
                    
                    daPrompt = doc["prompt"] as? String ?? ""
                    
                }
                DispatchQueue.main.async {
                    self.promptOfTheDay = daPrompt
                }
            }
        }
    }
    
    func getPrompts() {
        
        let db = Firestore.firestore()
        
        let prompts = db.collection("dailyPrompts")
        
        prompts.getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil {
                var prompts = [Prompt]()
                
                for doc in snapshot!.documents {
                    
                    var pr = Prompt()
                    
                    pr.id = doc.documentID as? String ?? UUID().uuidString
                    pr.content = doc["content"] as? String ?? ""
                    pr.promptNumberOfVotes = doc["promptNumberOfVotes"] as? Int ?? 0
                    pr.promptListPosition = doc["promptListPosition"] as? Int ?? 0
                    
                    
                    
                    prompts.append(pr)
                }
                DispatchQueue.main.async {
                    
                    self.prompts = prompts
                }
            }
        }
    }
    
    func toggleSelection(for profile: Profile) {
        
        if let index = profiles.firstIndex(where: { $0.id == profile.id }) {
            profiles[index].isSelected.toggle()
            
        }
    }
    
    
    func updateVotesAndListPosition(for profile: Profile) {
        // Increment numberOfVotesProfile for the inputted profile
        if let index = profiles.firstIndex(where: { $0.id == profile.id }) {
            profiles[index].numberOfVotesProfile += 1
            
            // Set isSelected to true for the inputted profile
            profiles[index].isSelected = true
            
            // Filter selected profiles and sort by numberOfVotesProfile in descending order
            let selectedProfiles = profiles.filter { $0.isSelected }
            var sortedProfiles = selectedProfiles.sorted(by: {
                $0.numberOfVotesProfile > $1.numberOfVotesProfile
            })
            
            // Assign listPosition based on sorted order of numberOfVotesProfile
            for (index, var sortedProfile) in sortedProfiles.enumerated() {
                sortedProfile.listPosition = index + 1
                sortedProfiles[index] = sortedProfile // Update the mutable list
                
                // Update Firebase with the updated listPosition
                let db = Firestore.firestore() // Assuming Firestore
                db.collection("Users").document(sortedProfile.id).updateData([
                    "listPosition": sortedProfile.listPosition
                ]) { error in
                    if let error = error {
                        print("Error updating Firebase: \(error)")
                    } else {
                        print("Firebase updated successfully")
                    }
                }
            }
            
            // Update Firebase with the changes for the inputted profile
            let db = Firestore.firestore() // Assuming Firestore
            db.collection("Users").document(profile.id).updateData([
                "numberOfVotesProfile": profiles[index].numberOfVotesProfile,
                "isSelected": true
            ]) { error in
                if let error = error {
                    print("Error updating Firebase: \(error)")
                } else {
                    print("Firebase updated successfully")
                }
            }
            
            print("List positions updated:", sortedProfiles.map { $0.listPosition })
        }
    }
    
    
    func requestNotificationsPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    
                    self.notificationsPermissionGranted = true
                } else if let error = error {
                    print("Error requesting notifications permission: \(error.localizedDescription)")
                } else {
                    print("Notifications permission denied")
                    self.showAlert = true
                }
            }
        }
    }
    
    
    func inviteFriends(completion: ((Bool) -> Void)? = nil) {
        let appStoreURL = URL(string: "https://testflight.apple.com/join/E5BRluLy")!
        let shareText = "Hey! Check cette app là si t'as 2 sec: \(appStoreURL)"
        
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            DispatchQueue.main.async {
                   completion?(completed)
               }
        }
        
        if let topViewController = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first?
            .windows
            .first?
            .rootViewController {
            
            topViewController.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    
    
    
    func selectOnly(profile selectedProfile: Profile) {
        
        // Iterate through all profiles
        for index in profiles.indices {
            if profiles[index].id == selectedProfile.id {
                // Select the profile that matches the selectedProfile
                profiles[index].greenDot = true
            } else {
                // Deselect all other profiles
                profiles[index].greenDot = false
            }
        }
    }
    
    func fetchCurrentUser() {
        if let userId = Auth.auth().currentUser?.uid {
            let db = Firestore.firestore()
            let usersCollection = db.collection("Users")
            usersCollection.document(userId).getDocument { document, error in
                if let document = document, document.exists {
                    if let profileData = document.data() {
                        // Map Firestore data to your Profile struct
                        let currentUserProfile = Profile(
                            id: userId,
                            name: profileData["name"] as? String ?? "",
                            numberOfVotesProfile: profileData["numberOfVotesProfile"] as? Int ?? 0,
                            listPosition: profileData["listPosition"] as? Int ?? 0,
                            isSelected: profileData["isSelected"] as? Bool ?? false,
                            hasVoted: profileData["hasVoted"] as? Bool ?? false,
                            hasVotedForPrompt: profileData["hasVotedForPrompt"] as? Bool ?? false,
                            votedForMe: profileData["votedForMe"] as? [String] ?? [],
                            fcmToken: profileData["fcmToken"] as? String ?? "",
                            profileImageURL: profileData["profileImageURL"] as? String ?? ""
                        )
                        DispatchQueue.main.async {
                            self.currentUser = currentUserProfile
                        }
                    }
                } else { }
            }
        }
    }
    
    func markCurrentUserAsHavingVoted() {
        if let userId = Auth.auth().currentUser?.uid {
            let db = Firestore.firestore()
            let usersCollection = db.collection("Users")
            
            // Update the 'hasVoted' field to true
            usersCollection.document(userId).updateData(["hasVoted": true]) { error in
                if let error = error {
                    print("Error updating 'hasVoted' field: \(error.localizedDescription)")
                } else {
                    print("User marked as voted successfully.")
                    // You can also update the currentUser variable if needed.
                    // For example, if 'currentUser' is a Published property in SwiftUI.
                    // self.currentUser.hasVoted = true
                }
            }
        }
    }
    
    func addUserToVotedForMe(of selectedUser: Profile) {
        if let currentUser = currentUser {
            // Assuming you have a reference to Firebase Firestore
            let db = Firestore.firestore()
            
            // Reference to the selected user's "Users" document
            let selectedUserDocRef = db.collection("Users").document(selectedUser.id)
            
            // Update the "votedForMe" field in the selected user's document
            db.runTransaction({ (transaction, errorPointer) -> Any? in
                do {
                    let selectedUserData = try transaction.getDocument(selectedUserDocRef).data()
                    
                    // Get the current "votedForMe" array or initialize it if it doesn't exist
                    var votedForMe = selectedUserData?["votedForMe"] as? [String] ?? []
                    
                    // Add the currentUser's name to the array if it's not already there
                    if !votedForMe.contains(currentUser.name) {
                        votedForMe.append(currentUser.name)
                        
                        // Update the "votedForMe" property in Firestore
                        transaction.updateData(["votedForMe": votedForMe], forDocument: selectedUserDocRef)
                    }
                    
                    return nil
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
            }) { _, error in
                if let error = error {
                    print("Transaction failed: \(error)")
                } else {
                    print("Name added to votedForMe successfully!")
                }
            }
        }
    }
    func updatePromptVotesAndListPosition(for prompt: Prompt) {
        // Increment numberOfVotesProfile for the inputted profile
        if let index = prompts.firstIndex(where: { $0.id == prompt.id }) {
            prompts[index].promptNumberOfVotes += 1
            
            
            
            // Filter selected profiles and sort by numberOfVotesProfile in descending order
            
            var sortedPrompts = prompts.sorted(by: {
                $0.promptNumberOfVotes > $1.promptNumberOfVotes
            })
            
            // Assign listPosition based on sorted order of numberOfVotesProfile
            for (index, var sortedPrompt) in sortedPrompts.enumerated() {
                sortedPrompt.promptListPosition = index + 1
                sortedPrompts[index] = sortedPrompt // Update the mutable list
                
                // Update Firebase with the updated listPosition
                let db = Firestore.firestore() // Assuming Firestore
                db.collection("dailyPrompts").document(sortedPrompt.id).updateData([
                    "promptListPosition": sortedPrompt.promptListPosition
                ]) { error in
                    if let error = error {
                        print("Error updating Firebase: \(error)")
                    } else {
                        print("Firebase updated successfully")
                    }
                }
            }
            
            // Update Firebase with the changes for the inputted profile
            let db = Firestore.firestore() // Assuming Firestore
            db.collection("dailyPrompts").document(prompt.id).updateData([
                "promptNumberOfVotes": prompts[index].promptNumberOfVotes
            ]) { error in
                if let error = error {
                    print("Error updating Firebase: \(error)")
                } else {
                    print("Firebase updated successfully")
                }
            }
        }
    }
    
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: Application_utility.rootViewController) { result, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let user = result?.user, let idToken = user.idToken else { return }
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            let db = Firestore.firestore()
            
            if let currentUser = Auth.auth().currentUser {
                currentUser.link(with: credential) { _, error in
                    if let error = error {
                        print("Error linking Google account: \(error.localizedDescription)")
                        return
                    }
                    print("Google account linked successfully.")
                    self.goOn = true
                }
            } else {
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    if let authResult = authResult {
                        let path = db.collection("Users").document(authResult.user.uid)
                        
                        path.getDocument { (document, error) in
                            if let document = document, document.exists {
                                print("User already exists, no need to update Firestore")
                                self.goOn = true
                            } else {
                                // Create new Firestore document for the user
                                let userData: [String: Any] = [
                                    "id": authResult.user.uid,
                                    "name": user.profile?.name ?? "No Name",
                                    "listPosition": 0,
                                    "numberOfVotesProfile": 0,
                                    "isSelected": false,
                                    "hasVoted": false,
                                    "hasVotedForPrompt": false,
                                    "greenDot": false
                                ]
                                
                                path.setData(userData) { error in
                                    if let error = error {
                                        print("Error creating user document: \(error.localizedDescription)")
                                    } else {
                                        print("User document created in Firestore.")
                                        self.goOn = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    func signInWithFacebook() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: nil) { result, error in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            let db = Firestore.firestore()
            
            if let currentUser = Auth.auth().currentUser {
                currentUser.link(with: credential) { _, error in
                    if let error = error {
                        print("Error linking Facebook account: \(error.localizedDescription)")
                        return
                    }
                    print("Facebook account linked successfully.")
                    self.goOn = true
                }
            } else {
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        print("Login error: \(error.localizedDescription)")
                        return
                    }
                    
                    let path = db.collection("Users").document(authResult!.user.uid)
                    
                    path.getDocument { (document, error) in
                        if let document = document, document.exists {
                            print("User already exists, no need to update Firestore")
                            self.goOn = true
                        } else {
                            let request = GraphRequest(graphPath: "me", parameters: ["fields": "id, name"])
                            request.start { _, result, error in
                                if let error = error {
                                    print("Error fetching user data: \(error.localizedDescription)")
                                    return
                                }
                                if let data = result as? [String: Any], let name = data["name"] as? String {
                                    let userData: [String: Any] = [
                                        "id": authResult!.user.uid,
                                        "name": name,
                                        "listPosition": 0,
                                        "numberOfVotesProfile": 0,
                                        "isSelected": false,
                                        "hasVoted": false,
                                        "hasVotedForPrompt": false,
                                        "greenDot": false
                                    ]
                                    
                                    path.setData(userData) { error in
                                        if let error = error {
                                            print("Error creating user document: \(error.localizedDescription)")
                                        } else {
                                            print("User document created in Firestore.")
                                            self.goOn = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    
}

//
//  CommentSheetView.swift
//  Number1
//
//  Created by Joël Lacoste-Therrien on 2023-11-05.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct CommentSheetView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @State var commentContent = ""
    
    var profile: Profile
    
    var body: some View {
        VStack {
            ZStack{
                CustomRectangle()
                    .frame(height: 100)
                
                Text("Comments")
                    .font(.custom("AvenirNext-Bold", size: 32))
                    .foregroundColor(.white)
            }
            
            if profile.comments != nil {
                
                ForEach(profile.comments!, id: \.id) {item in
                    
                    CommentView(comment: item)
                    
                }
                
                TextField("Write a comment...", text: $commentContent)
                    .padding(.horizontal)
                
                Button {
                    
                    postComment()
                    model.getUsers()
                    
                } label: {
                    ZStack {
                        CustomRectangle()
                            .padding()
                        .frame(height: 80)
                        .cornerRadius(15)
                        
                        Text("Post Comment")
                            .font(.custom("AvenirNext", size: 25))
                            .foregroundColor(.white)
                    }
                }
                .buttonStyle(.plain)

                
            } else {
                
            }
            Spacer()
        }
    }
    func postComment() {
            guard let currentUser = model.currentUser else { return } // Replace with your actual current user fetching logic
            
            let db = Firestore.firestore()
            let userDoc = db.collection("Users").document(profile.id)
            
            let newComment = Comment(
                id: UUID().uuidString, // Generate a unique ID for the comment
                name: currentUser.name,
                comment: commentContent,
                profileImageURLComment: currentUser.profileImageURL
            )
            
            // Convert your comment object to a dictionary to save to Firestore
            let newCommentData = [
                "id": newComment.id,
                "name": newComment.name,
                "comment": newComment.comment,
                "profileImageURLComment": newComment.profileImageURLComment ?? ""
            ]
            
            userDoc.updateData([
                "comments": FieldValue.arrayUnion([newCommentData])
            ]) { error in
                if let error = error {
                    print("Error adding comment: \(error.localizedDescription)")
                } else {
                    print("Comment added successfully")
                    self.commentContent = "" // Clear the text field
                    // Here, you would also update the local 'comments' array if you are maintaining one
                    // This is to ensure the UI updates without having to re-fetch from Firestore
                }
            }
        }
}


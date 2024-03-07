//
//  CommunityView.swift
//  Number1
//
//  Created by Joël Lacoste-Therrien on 2024-01-30.
//

import SwiftUI
import Firebase
import FirebaseFirestore



struct CommunityView: View {
    
    @EnvironmentObject var model:ContentModel
    
    @State var newCommunity:String
    
    @State var selectedCommunities = Set<String>()
    
    var body: some View {
        
        
        VStack{
            
            Title(subTitle: "Choose your community")
            
            ScrollView{
                
                ForEach(model.communities, id: \.self) { community in
                    
                    Button(action: {
                        
                        if selectedCommunities.contains(community) {
                                                    selectedCommunities.remove(community)
                                                } else {
                                                    selectedCommunities.insert(community)
                                                }
                        
                    }, label: {
                        
                        
                        ZStack{
                            
                            Capsule()
                                .foregroundColor(selectedCommunities.contains(community) ? .green : .gray)
                                 .padding(.horizontal)
                            
                            Text(community)
                            
                        }
                    })
                    
                }
            }
            
            Text("Or create your own")
            
            HStack{
                TextField("", text: $newCommunity)
                
                Button(action: {
                    
                    model.communities.append(newCommunity)
                    newCommunity = ""
                    
                }, label: {
                    
                    ZStack{
                        Circle()
                            .foregroundColor(.blue)
                        
                        Image(systemName: "check")
                            .foregroundColor(.white)
                        
                    }
                    
                })
            }
            
            Button(action: {
                
                updateFirestore()
                
            }, label: {
                
                ZStack{
                    CustomRectangle()
                    Text("Continue")
                }
            })
            
          
            
        }
        
        
    }
    func updateFirestore() {
            guard let currentUser = model.currentUser else { return }
            let db = Firestore.firestore()

            // Updating the user's "myCommunities" field in Firestore
            let userDocRef = db.collection("Users").document(currentUser.id)
            userDocRef.updateData([
                "myCommunities": FieldValue.arrayUnion(Array(selectedCommunities))
            ])

            // Updating each community's "members" field in Firestore
            for community in selectedCommunities {
                let communityDocRef = db.collection("Communities").document(community)
                communityDocRef.updateData([
                    "members": FieldValue.arrayUnion([currentUser.name])
                ])
            }
        }
}

#Preview {
    CommunityView(newCommunity: "BabileCity")
        .environmentObject(ContentModel())
}

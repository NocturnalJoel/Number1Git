//
//  AddPersonToListView.swift
//  Number1
//
//  Created by Joël Lacoste-Therrien on 2023-08-24.
//

import SwiftUI
import Firebase

struct VoteForPersonView: View {
    
    @EnvironmentObject var model: ContentModel
    @State private var searchText = ""
    @State var selectedUser: Profile?
    @State var allGood = false
    
    var body: some View {
        
        
        NavigationView {
            
            VStack {
                
                Text("Number1")
                    .bold()
                    .font(.largeTitle)
                
                Button {
                    model.inviteFriends()
                } label: {
                    ZStack{
                        Capsule()
                            .foregroundColor(.black)
                            .frame(height: 48)
                            .padding(.horizontal)
                        Text("Don't see your friends? Add them!")
                            .foregroundColor(.white)
                            .font(.custom("AvenirNext-Bold", size: 18))
                            
                    }
                }
                .buttonStyle(.plain)
                
                SearchBarView(text: $searchText)
                    .padding()
                
                
               

                
                
                List(filteredProfiles) { profile in
                    Button(action: {
                        model.selectOnly(profile: profile)
                        selectedUser = profile
                    }) {
                        HStack {
                            Text(profile.name)
                                .foregroundColor(.black)
                            
                            if profile.greenDot == true {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .background(Color.white)
                    }
                    .buttonStyle(.plain)
                }
                .background(Color.white)
                Divider()
                
                Button {
                    
                    if selectedUser != nil {
                        
                        model.markCurrentUserAsHavingVoted()
                        model.getUsers()
                        model.updateVotesAndListPosition(for: selectedUser!)
                        model.addUserToVotedForMe(of: selectedUser!)
                        model.fetchCurrentUser()
                        allGood = true
                    }
                    
                } label: {
                    ZStack{
                        Capsule()
                            .foregroundColor(.red)
                            .frame(height: 48)
                        Text("Save your vote!")
                            .foregroundColor(.white)
                            .bold()
                    }
                }
                .padding(.horizontal)
                .buttonStyle(.plain)
                .fullScreenCover(isPresented: $allGood, content: {
                    HomeScreenView()
                })

            }
            .background(Color.white)
        }
    }
    var filteredProfiles: [Profile] {
        if searchText.isEmpty {
            return model.profiles
        } else {
            return model.profiles.filter { profile in
                profile.name.contains(searchText)
            }
        }
    }
}






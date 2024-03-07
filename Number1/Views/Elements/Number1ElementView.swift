//
//  Number1ElementView.swift
//  Number1
//
//  Created by Joël Lacoste-Therrien on 2023-10-29.
//

import SwiftUI

struct Number1ElementView: View {
    
    var profile: Profile
    
    @State var isSheetThere = false
    
    @State var seeAUsersProfile = false
    
    @EnvironmentObject var model: ContentModel
    
    let customColor1 = Color(red: 255/255, green: 204/255, blue: 0/255, opacity: 1)
    
    let customColor2 = Color(red: 255/255, green: 237/255, blue: 137/255, opacity: 1)
    
    var body: some View {
        Button {
            //model.updateVotesAndListPosition(for: profile)
            seeAUsersProfile = true
        } label: {
            ZStack {
                Rectangle()
                    .fill(
                        LinearGradient(gradient: Gradient(colors: [customColor1, customColor2]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                    .cornerRadius(20)
                    .frame(height: 70)
                    .shadow(radius: 3)
                    .padding(.horizontal)
                    
                
                VStack (spacing: -30) {
                    HStack(spacing: 0) {
                        Text("\(profile.listPosition)")
                            .bold()
                            .font(.title)
                            .frame(width: 40)
                            .padding(.leading, 30) // Adjust padding
                        
                        if let urlString = profile.profileImageURL, let url = URL(string: urlString) {
                            AsyncImage(url: url, scale: 1.0, content: { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 90, height: 90) // Change dimensions as you like
                                    .clipShape(Circle())
                            }, placeholder: {
                                Text("Loading...")
                            })
                            .overlay(Circle().stroke(Color.black, lineWidth: 2))
                        } else {
                            ZStack {
                                Circle()
                                    .foregroundColor(.gray)
                                    .scaledToFit()
                                    .frame(width: 90, height: 90)
                                    .overlay(Circle().stroke(Color.black, lineWidth: 2))
                                
                                Image(systemName: "person")
                                    .frame(width: 90, height: 90)
                            }
                        }
                        
                        //  Image("logo") // Replace "your_image_name" with your actual image name
                        //        .resizable()
                        //        .scaledToFit()
                        //       .frame(width: 90, height: 90) // Change dimensions as you like
                        //       .clipShape(Circle())
                        //       .overlay(Circle().stroke(Color.black, lineWidth: 2))
                        
                        Text("\(profile.name)")
                            .font(.custom("AvenirNext-Bold", size: 18))
                            .foregroundColor(.black)
                            .minimumScaleFactor(0.5)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 150, alignment: .center)
                            .padding(.horizontal, 5) // Adjust padding
                        
                        Spacer()
                        
                        Text("\(profile.numberOfVotesProfile) votes")
                            .bold()
                            .frame(width: 60, alignment: .trailing) // Adjust width
                            .padding(.trailing, 30) // Adjust padding
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            isSheetThere = true
                        } label: {
                            ZStack {
                                Capsule()
                                    .foregroundColor(.white)
                                    .frame(width: 175, height: 30)
                                    .padding(.horizontal)
                                    .offset(x: -9, y: 10)
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.black, lineWidth: 2)
                                            .frame(width: 175, height: 30)
                                            .offset(x: -9, y: 10)
                                    )
                                Text("Comments")
                                    .foregroundColor(.black)
                                    .italic()
                                    .font(.custom("AvenirNext-Bold", size: 20))
                                    .offset(x: -9, y: 10)
                                
                            }
                        }
                        .buttonStyle(.plain)
                        .sheet(isPresented: $isSheetThere) {
                                            // Pass the profile ID to the comments sheet view
                                            CommentSheetView(profile: profile)
                                        }
                        
                        
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $seeAUsersProfile) {
            SheetProfileView(profile: profile)
        }
    }
}


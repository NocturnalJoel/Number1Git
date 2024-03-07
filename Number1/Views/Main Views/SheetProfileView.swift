//
//  SheetProfileView.swift
//  Number1
//
//  Created by Joël Lacoste-Therrien on 2023-11-09.
//

import SwiftUI

struct SheetProfileView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var profile:Profile
    
    var body: some View {
        
        
        GeometryReader { geometry in
            ScrollView{
                
                VStack{
                    Title(subTitle: "Profile")
                    
                    if let urlString = profile.profileImageURL, let url = URL(string: urlString) {
                        AsyncImage(url: url, scale: 1.0, content: { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150) // Change dimensions as you like
                                .clipShape(Circle())
                        }, placeholder: {
                            Text("Loading...")
                        })
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: geometry.size.width * 0.03)
                            .stroke(Color.red)
                            .frame(height: geometry.size.height * 0.1)
                        
                        VStack {
                            Text("Name")
                                .font(.custom("AvenirNext-Bold", size: geometry.size.width * 0.05))
                            
                            Text(profile.name ?? "")
                                .font(.custom("AvenirNext", size: geometry.size.width * 0.05))
                        }
                        
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: geometry.size.width * 0.03)
                            .stroke(Color.red)
                            .frame(height: geometry.size.height * 0.15)
                        
                        VStack {
                            Text("Affiliations")
                                .font(.custom("AvenirNext-Bold", size: geometry.size.width * 0.05))
                            ZStack {
                                Capsule()
                                    .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.04)
                                    .foregroundColor(.gray)
                                HStack {
                                    Image(systemName: "multiply.circle")
                                    Text("Université de Sherbrooke")
                                        .font(.custom("AvenirNext", size: geometry.size.width * 0.05))
                                }
                                
                            }
                        }
                        .padding(.vertical)
                        Spacer()
                    }
                    
                    Text("My NUMBER1s ")
                        .font(.custom("AvenirNext-Bold", size: geometry.size.width * 0.05))
                        .padding(.vertical)
                    
                    ForEach(model.historyElements) { item in
                        if item.topPerson == profile.name {
                            ZStack{
                                Rectangle()
                                    .cornerRadius(20)
                                    .frame(height: 70)
                                    .foregroundColor(.white)
                                    .shadow(radius: 3)
                                    .padding(.horizontal)
                                
                                Text(item.dailyPrompt)
                            }
                        }
                    }
                    
                }
                
            }
        }
    }
}



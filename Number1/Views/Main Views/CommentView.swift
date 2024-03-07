//
//  CommentView.swift
//  Number1
//
//  Created by Joël Lacoste-Therrien on 2023-11-03.
//

import SwiftUI

struct CommentView: View {
    
    var comment: Comment
    
    
    
    var body: some View {
        
        ZStack{
            
            Rectangle()
                .foregroundColor(.black)
                .padding(20)
                .frame(height: 110)
                .shadow(radius: 10)
            
            Rectangle()
                .foregroundColor(.white)
                .padding(22)
                .frame(height: 110)
            
            VStack (spacing: 0){
                HStack{
                    
                    Text(comment.name)
                        .bold()
                        .underline()
                        .offset(y: -9)
                        .minimumScaleFactor(0.5)
                        .font(.custom("AvenirNext-Bold", size: 18))
                        .padding(.leading)
                        .lineLimit(1)
                    
                    Spacer()
                }
                
                
                HStack{
                    AsyncImage(url: URL(string: comment.profileImageURLComment!)) { image in
                        image
                            .resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .scaledToFit()
                    .offset(y: -10)
                    .frame(height: 50)
                    .padding(.leading, 30)
                    
                    Text(comment.comment)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: 300, maxHeight: 80)
                        .lineLimit(4)
                        .minimumScaleFactor(0.5)
                        .font(.custom("AvenirNext", size: 14))
                        .padding(.horizontal)
                        .offset(x: -40, y: -10)
                    
                }
            }
        }
    }
}


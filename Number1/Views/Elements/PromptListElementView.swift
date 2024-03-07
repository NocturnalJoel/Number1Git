//
//  PromptListElementView.swift
//  Number1
//
//  Created by Joël Lacoste-Therrien on 2023-08-13.
//

import SwiftUI

struct PromptListElementView: View {
    
 
    
    var promptInList: Prompt
    
    var body: some View {
        
        ZStack {
            
            Rectangle()
                .cornerRadius(15)
                .foregroundColor(.white)
                .shadow(radius: 3)
                .frame(height: 100)
                .padding(.horizontal)
            
            HStack {
                Spacer()
                Text("\(promptInList.promptListPosition)")
                    .bold()
                    .font(.title)
                    .frame(width: 40)
                    .padding(.leading, 15)
                    .foregroundColor(.black)
                    
                Spacer()
                Text("\(promptInList.content)")
                    .font(.custom("AvenirNext-Bold", size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.red)
                    .minimumScaleFactor(0.5)
                    .lineLimit(3)
                    .padding(.horizontal)
                    .frame(maxWidth: 200, alignment: .center)
                    
                    
                Spacer()
                Text("\(promptInList.promptNumberOfVotes) votes")
                    .bold()
                    .frame(width: 60, alignment: .trailing) // Adjust width
                    .padding(.trailing, 15) // Adjust padding
                    .foregroundColor(.black)
                    
                Spacer()
            }
            .padding(.horizontal)
            
        }
        
    }
}

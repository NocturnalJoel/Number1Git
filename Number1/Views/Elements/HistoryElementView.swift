//
//  HistoryElementView.swift
//  Number1
//
//  Created by Joël Lacoste-Therrien on 2023-10-29.
//

import SwiftUI

struct HistoryElementView: View {
    
    var historyElement: HistoryElement
    
    @EnvironmentObject var model: ContentModel
    

    
    var body: some View {
        Button {
            //model.updateVotesAndListPosition(for: profile)
            print("yeehaw")
        } label: {
            
            ZStack {
                
                Rectangle()
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .frame(height: 150)
                    .shadow(radius: 3)
                    .padding(.horizontal)
                
                
                    
                    
                    CustomRectangle()
                        .cornerRadius(20)
                        .frame(height: 45)
                        .padding(.horizontal)
                        .offset(y: -60)
                    
                    
                    Text(historyElement.date)
                    .font(.custom("AvenirNext-Bold", size: 18))
                    .underline()
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                    .offset(y: -60)
                  
                
                
                
                
                VStack (spacing: 8) {
                  
                    
                    Text(historyElement.dailyPrompt)
                        .font(.custom("AvenirNext", size: 18))
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5)
                        .frame(maxWidth: 350, alignment: .center)
                    
                    Text("Winner:")
                        .font(.custom("AvenirNext-Bold", size: 18))
                        .underline()
                    
                    Text(historyElement.topPerson)
                        .font(.custom("AvenirNext", size: 18))
                        
                }
                .padding(.top, 35)
                
                
            }
            
        }
        .buttonStyle(.plain)
        .padding(.bottom, 35)
    }
}


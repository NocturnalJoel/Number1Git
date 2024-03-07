//
//  AreYouSureView.swift
//  Number1
//
//  Created by Joël Lacoste-Therrien on 2023-10-05.
//

import SwiftUI

struct AreYouSureView: View {
    
    @EnvironmentObject var model: ContentModel
    
    let customColor1 = Color(red: 246/255, green: 46/255, blue: 55/255, opacity: 1)
    
    let customColor2 = Color(red: 170/255, green: 7/255, blue: 14/255, opacity: 1)
    
    var noAction: () -> Void = {}   // Default to an empty closure
    
    var yesAction: () -> Void = {}
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(15)
                .shadow(radius: 15)
                .frame(height: 400)
            
            VStack (spacing: 30) {
                
                Text("You are about to give this prompt your only daily vote. Are you sure?")
                    .multilineTextAlignment(.center)
                    .font(.custom("AvenirNext-Bold", size: 30))
                    .padding(.horizontal)
                    .padding(.bottom, 50)
                
                
                
                HStack (spacing: 25){
                    
                    
                    Button {
                        noAction()
                    } label: {
                        ZStack{
                            CustomRectangle()
                                .frame(height: 70)
                                .cornerRadius(15)
                            
                            Text("NO")
                                .font(.custom("AvenirNext-Bold", size: 30))
                                .foregroundColor(.white)
                            
                        
                        }
                    }
                    .buttonStyle(.plain)

                    
                    
                    Button {
                        yesAction()
                    } label: {
                        ZStack{
                            
                            
                            CustomRectangle()
                                .frame(height: 70)
                                .cornerRadius(15)
                            
                            Text("YES")
                                .font(.custom("AvenirNext-Bold", size: 30))
                                .foregroundColor(.white)
                        }
                    }
                    .buttonStyle(.plain)

                   
                    
                }
                .padding(.horizontal)
            }
        }
        .padding(.horizontal)
    }
}

struct AreYouSureView_Previews: PreviewProvider {
    static var previews: some View {
        AreYouSureView()
            .environmentObject(ContentModel())
    }
}

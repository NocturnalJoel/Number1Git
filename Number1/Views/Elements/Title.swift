//
//  Title.swift
//  Untitled
//
//  Created by Joël Lacoste-Therrien on 2023-09-12.
//

import SwiftUI

struct Title: View {
    
    var subTitle: String
    
    let customColor1 = Color(red: 246/255, green: 46/255, blue: 55/255, opacity: 1)
    
    let customColor2 = Color(red: 170/255, green: 7/255, blue: 14/255, opacity: 1)
    
    var subsize:Double = 30
    
    
    var body: some View {
        
        VStack {
            
            ZStack{
                
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [customColor1, customColor2]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .ignoresSafeArea()
                    .frame(height: 80)
                
                Text("NUMBER1")
                    .foregroundColor(.white)
                    .font(.custom("AvenirNext-Bold", size: 42))
                    .italic()
                    
            }
            
            Text(subTitle)
                .foregroundColor(.black)
                .font(.custom("AvenirNext-Bold", size: subsize))
                .italic()
        }
        
    }
    
}

struct Title_Previews: PreviewProvider {
    static var previews: some View {
        Title(subTitle: "SubTitle")
    }
}

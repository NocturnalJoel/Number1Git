//
//  CustomRectangle.swift
//  Number1
//
//  Created by Joël Lacoste-Therrien on 2023-09-13.
//

import SwiftUI

struct CustomRectangle: View {
    
    let customColor1 = Color(red: 246/255, green: 46/255, blue: 55/255, opacity: 1)
    
    let customColor2 = Color(red: 170/255, green: 7/255, blue: 14/255, opacity: 1)
    
    
    var body: some View {
        
        Rectangle()
            .fill(
                LinearGradient(gradient: Gradient(colors: [customColor1, customColor2]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
            .ignoresSafeArea()
            
    }
}

struct CustomRectangle_Previews: PreviewProvider {
    static var previews: some View {
        CustomRectangle()
    }
}

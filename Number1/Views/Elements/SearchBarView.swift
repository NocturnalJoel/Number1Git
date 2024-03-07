//
//  SearchBarView.swift
//  Number1
//
//  Created by Joël Lacoste-Therrien on 2023-08-26.
//

import SwiftUI

struct SearchBarView: View {
    

    
    @Binding var text: String
        
            
            var body: some View {
                TextField("Search", text: $text)
                    .frame(height: 35)
                    .padding(.horizontal, 10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    
                
            }
        }


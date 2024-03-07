//
//  HistoryView.swift
//  Number1
//
//  Created by Joël Lacoste-Therrien on 2023-10-29.
//

import SwiftUI

struct HistoryView: View {
    
    @EnvironmentObject var model: ContentModel
    
    
    var body: some View {
        
     VStack {
            
            Title(subTitle: "📜 History 🏛")
             
            
            ScrollView {
                
                LazyVStack(spacing: 5){
                    
                    ForEach(model.historyElements.sorted(by: { $0.date > $1.date }), id: \.id) { item in
                        
                        HistoryElementView(historyElement: item)
                        
                    }
                    
                }
            }
            Spacer()
        }
        
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}

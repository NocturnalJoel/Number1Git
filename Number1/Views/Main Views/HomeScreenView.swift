//
//  HomeScreenView.swift
//  Number1
//
//  Created by Joël Lacoste-Therrien on 2023-08-13.
//

import SwiftUI

struct HomeScreenView: View {
    
    @EnvironmentObject var model : ContentModel
    
    @State private var selectedTab = 1
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            HistoryView()
                .tabItem {
                    Image(systemName: "book")
                    Text("History")
                }
                .tag(0)
            
            VotesView()
                .tabItem {
                    Image(systemName: "list.number")
                    Text("Votes")
                }
                .tag(1)
                .foregroundColor(.black)
            
            PromptsView()
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("Tomorrow's Questions")
                }
                .tag(2)
        }
        .accentColor(.red)
        .navigationBarHidden(false)
        
        
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
            .environmentObject(ContentModel())
    }
}

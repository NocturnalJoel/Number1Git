//
//  LaunchView.swift
//  Number1
//
//  Created by Joël Lacoste-Therrien on 2023-08-13.
//

import SwiftUI
import FirebaseAuth

struct LaunchView: View {
    
    @EnvironmentObject var model: ContentModel
    @State var activateLink: Bool = false
    
    
    
    var body: some View {
        
        
        
        if model.loggedIn == false {
            OnboardingView()
                .onAppear{
                    checkLogin()
                }
            
        } else if model.loggedIn {
            HomeScreenView()
                .onAppear{
                    checkLogin()
                }
        }
        
    }
    
    
    func checkLogin() {
        
        model.loggedIn = Auth.auth().currentUser != nil
        
    }
}
    
    struct LaunchView_Previews: PreviewProvider {
        static var previews: some View {
            LaunchView()
                .environmentObject(ContentModel())
        }
    }


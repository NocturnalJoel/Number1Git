//
//  PromptSubmissionView.swift
//  Number1
//
//  Created by Joël Lacoste-Therrien on 2023-08-13.
//

import SwiftUI
import Firebase

struct PromptSubmissionView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var isButtonClicked = false
    
    @State var newPrompt = ""
    
    @State private var isPromptShown = false
    
    var body: some View {
        
        
            
            GeometryReader { geometry in
                VStack {
                    
                    Title(subTitle: " ✍️ Submission 📝")
                    
                    Spacer()
                    
                    Text("What would you like to see as tomorrow's prompt?")
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                        .font(.custom("AvenirNext-Bold", size: geometry.size.width * 0.06))
                    
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: geometry.size.width * 0.03)
                            .stroke(Color.red)
                            .frame(height: geometry.size.height * 0.1)
                        
                        TextField("Write here...", text: $newPrompt)
                            .padding(.bottom)
                            .padding(.horizontal)
                            .font(.custom("AvenirNext", size: geometry.size.width * 0.045))
                    }
                    .padding(.horizontal)
                    
                    Button {
                        
                        addDailyPrompt()
                        isButtonClicked = true
                        isPromptShown = true
                        presentationMode.wrappedValue.dismiss()
                        model.getPrompts()
                        
                    } label: {
                        ZStack{
                            Rectangle()
                                .cornerRadius(geometry.size.width * 0.03)
                                .foregroundColor(.red)
                                .frame(height: geometry.size.height * 0.1)
                                .padding(.horizontal)
                            
                            Text("Submit")
                                .bold()
                                .foregroundColor(.white)
                                .font(.custom("AvenirNext-Bold", size: geometry.size.width * 0.045))
                        }
                    }
                    .buttonStyle(.plain)
                    .alert(isPresented: $isPromptShown) {
                        Alert(
                            title: Text("Congrats!"),
                            message: Text("Your prompt has been posted. People can now vote for it to become the next prompt."),
                            dismissButton: .default(Text("OK")) {
                                // Dismiss the current view (go back)
                                presentationMode.wrappedValue.dismiss()
                            }
                        )
                    }
                    
                    Spacer()
                    
                    Spacer()
                }
                .background(Color.white)
                
                
            }
            
        
        
    }
    
    func addDailyPrompt() {
        let db = Firestore.firestore()
        let path = db.collection("dailyPrompts").document()
        path.setData([
            "id": path.documentID,
            "content": newPrompt,
            "promptListPosition": 0,
            "promptNumberOfVotes": 0,
            "fcmToken": model.currentUser?.fcmToken ?? "" // Add this line to set FCM Token
        ])
    }

}

struct PromptSubmissionView_Previews: PreviewProvider {
    static var previews: some View {
        PromptSubmissionView()
            .environmentObject(ContentModel())
    }
}

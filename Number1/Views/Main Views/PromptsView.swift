import SwiftUI
import Firebase

struct PromptsView: View {

    @EnvironmentObject var model: ContentModel
    @State var isShowingPopup = false
    @State var areYouSure = false
    @State var theySaidYes = false
    @State var selectedPrompt: Prompt? // Replace YourPromptType with the actual data type of your prompt.


    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Title(subTitle: " ✍️ Tomorrow's Questions 📝", subsize: geometry.size.width * 0.065)
                        .onAppear {
                            model.fetchCurrentUser()
                            model.getPrompts()
                        }

                    ZStack {
                        RoundedRectangle(cornerRadius: geometry.size.width * 0.02)
                            .stroke(Color.red)
                            .frame(height: geometry.size.height * 0.16)
                            

                        VStack(spacing: geometry.size.height * 0.03) {
                            Text("Vote for tomorrow's sentence or...")
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .font(.custom("AvenirNext-Bold", size: geometry.size.width * 0.04))
                                

                            NavigationLink {
                                PromptSubmissionView()
                            } label: {
                                ZStack {
                                    Capsule()
                                        .foregroundColor(.red)
                                        .frame(height: geometry.size.height * 0.07)
                                        .padding(.horizontal)
                                    Text("Create your own!")
                                        .foregroundColor(.white)
                                        .font(.custom("AvenirNext-Bold", size: geometry.size.width * 0.04))
                                }
                                
                            }
                            .buttonStyle(.plain)
                        }
                       
                    }
                    .padding(.horizontal)

                    ZStack {
                        
                        
                        
                        ScrollView {
                            VStack() {
                                ForEach(model.prompts.sorted { (first, second) -> Bool in
                                    if first.promptListPosition == 0 {
                                        return false // Put elements with promptListPosition 0 at the bottom
                                    } else if second.promptListPosition == 0 {
                                        return true // Put elements with promptListPosition 0 at the bottom
                                    } else {
                                        return first.promptListPosition < second.promptListPosition
                                    }
                                }, id: \.id) { item in

                                    Button {
                                        if !model.currentUser!.hasVotedForPrompt {
                                            
                                            selectedPrompt = item
                                                    areYouSure = true
                                                } else {
                                                    showCustomPopup(message: "You have already voted for a sentence or question today.")
                                                }
                                    } label: {
                                        PromptListElementView(promptInList: item)
                                    }
                                    .buttonStyle(.plain)
                                    
                                }
                            }
                            .padding(.top)
                        }
                        
                        if areYouSure, let prompt = selectedPrompt {
                            AreYouSureView(noAction: {
                                areYouSure = false
                            }, yesAction: {
                                theySaidYes = true
                                areYouSure = false
                                model.updatePromptVotesAndListPosition(for: prompt)
                                updateUserHasVotedForPrompt()
                                model.getUsers()
                                model.fetchCurrentUser()
                                theySaidYes = false
                            })
                        }

                        
                    }
                    Spacer()
                }
                .background(Color.white)
            }
        }
        .accentColor(.white)
    }

    func showCustomPopup(message: String) {
        isShowingPopup = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Automatically close the pop-up after a certain time (2 seconds in this example)
            isShowingPopup = false
        }
    }

    func updateUserHasVotedForPrompt() {
        // Get the current user's UID or any unique identifier that you use in your app
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            // Handle the case where the user is not authenticated or you can't retrieve their UID
            return
        }

        // Reference to the Firestore collection "Users"
        let usersCollection = Firestore.firestore().collection("Users")

        // Reference to the document for the current user
        let userDocument = usersCollection.document(currentUserUID)

        // Update the "hasVotedForPrompt" field to true
        userDocument.updateData(["hasVotedForPrompt": true]) { error in
            if let error = error {
                print("Error updating hasVotedForPrompt: \(error.localizedDescription)")
            } else {
                print("hasVotedForPrompt updated successfully")
            }
        }
    }
}

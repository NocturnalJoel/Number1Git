import SwiftUI
import Firebase
import UserNotifications
import BackgroundTasks

struct VotesView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @State private var votesViewSearchText = ""
    @State var seeProfile = false
    @State var seeAUsersProfile = false
    

    
    var body: some View {
        
        NavigationView {
            
            GeometryReader { geometry in
                
                VStack {
                    
                        VStack {
                            
                            ZStack {
                                
                                Title(subTitle: "🥇 Podium 🏆", subsize: geometry.size.width * 0.07)
                                    .onAppear {
                                        model.fetchCurrentUser()
                                        model.getPrompts()
                                        model.getUsers()
                                        model.getPrompt()
                                        model.fetchHistory()
                                    }
                                
                                HStack{
                                    VStack {
                                        Button {
                                            seeProfile = true
                                        } label: {
                                            ZStack{
                                                Circle()
                                                    .foregroundColor(.white)
                                                    .frame(height: geometry.size.width * 0.15)
                                                    .overlay(
                                                        Circle()
                                                            .stroke(Color.black, lineWidth: 2)
                                                    )
                                                
                                                Image(systemName: "person")
                                                    .foregroundColor(.black)
                                                
                                            }
                                        }.sheet(isPresented: $seeProfile, content: { ProfileView().environmentObject(self.model) })
                                            .padding(.leading)
                                            .buttonStyle(.plain)
                                        
                                        Text("Profile")
                                            .font(.caption)
                                            .padding(.leading)
                                    }
                                    .padding(.top)
                                    Spacer()
                                }
                            }
                            .frame(height: geometry.size.height * 0.1)
                        }
                        
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: geometry.size.width * 0.02)
                                .stroke(Color.red)
                                .frame(height: geometry.size.height * 0.15)
                                .padding()
                            
                            VStack {
                                
                                Text("Today's Sentence:")
                                    .padding(.horizontal)
                                    .underline()
                                    .font(.custom("AvenirNext-Bold", size: geometry.size.width * 0.05))
                                
                                
                                Text(model.promptOfTheDay)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.red)
                                    .font(.custom("AvenirNext-Bold", size: geometry.size.width * 0.04))
                                    .padding(.horizontal)
                                
                                
                            }
                            .frame(height: geometry.size.height * 0.16)
                            
                        }.padding(.top)
                    
                    
                    if model.currentUser?.hasVoted == true {
                        SearchBarView(text: $votesViewSearchText)
                            .padding(.horizontal)
                            
                         
                        
                        ScrollView {
                            VStack {
                                if votesViewSearchText == "" {
                                    ForEach(model.profiles.sorted(by: { $0.listPosition < $1.listPosition }), id: \.id) { profile in
                                        if profile.isSelected == true {
                                            
                                            if profile.listPosition == 1 {
                                                
                                                
                                                    Number1ElementView(profile: profile)
                                                

                                                
                                                
                                            } else {
                                                
                                                
                                               
                                                    VotesListElementView(profile: profile)
                                             
                                                
                                                
                                            }
                                        }
                                    }
                                } else if votesViewSearchText != "" {
                                    ForEach(filteredProfilesForVotes) { profile in
                                        if profile.isSelected {
                                            
                                            
                                            
                                                VotesListElementView(profile: profile)
                                      
                                            
                                            
                                                
                                        }
                                    }
                                }
                            }
                            .padding(.top)
                            
                        }
                        .simultaneousGesture(DragGesture().onChanged({ _ in
                            self.hideKeyboard()
                        }))
                        
                        Spacer()
                        
                        if model.canSeeWhoVoted == false {
                            Button {
                                model.inviteFriends { success in
                                        if success {
                                            model.canSeeWhoVoted = true
                                        }
                                    }
                            } label: {
                                ZStack{
                                    Capsule()
                                        .foregroundColor(.red)
                                        .frame(height: geometry.size.width * 0.14)
                                        .padding(.horizontal)
                                    Text("Share the app to see who voted for you!")
                                        .foregroundColor(.white)
                                        .font(.custom("AvenirNext-Bold", size: geometry.size.width * 0.04))
                                        
                                }
                                
                            }
                            .padding(.vertical)
                            .buttonStyle(.plain)
                        } else {
                            ZStack{
                                Capsule()
                                    .foregroundColor(.red)
                                    .frame(height: geometry.size.width * 0.14)
                                    .padding(.horizontal)
                                Text("You can see who voted for you in your profile")
                                    .foregroundColor(.white)
                                    .font(.custom("AvenirNext-Bold", size: geometry.size.width * 0.04))
                                    
                            }
                        }
                    } else {
                        
                        Spacer()
                        
                        ZStack {
                            ScrollView {
                                VStack {
                                    ForEach(0..<8, id: \.self) { x in
                                        ZStack {
                                            Rectangle()
                                                .cornerRadius(geometry.size.width * 0.03)
                                                .frame(height: geometry.size.height * 0.1)
                                                .foregroundColor(.white)
                                                .shadow(radius: 3)
                                                .padding(.horizontal)
                                            
                                            HStack(spacing: 0) {
                                                Text("\(x + 1)")
                                                    .bold()
                                                    .font(.title)
                                                    .frame(width: geometry.size.width * 0.1)
                                                    .padding(.leading, geometry.size.width * 0.07)
                                                
                                                Spacer()
                                                
                                                Text("Peter Parker")
                                                    .bold()
                                                    .foregroundColor(.red)
                                                    .lineLimit(1)
                                                    .truncationMode(.tail)
                                                    .frame(maxWidth: .infinity, alignment: .center)
                                                    .padding(.horizontal, geometry.size.width * 0.015)
                                                    .blur(radius: geometry.size.width * 0.05)
                                                
                                                Spacer()
                                                
                                                Text("135")
                                                    .bold()
                                                    .frame(width: geometry.size.width * 0.15, alignment: .trailing)
                                                    .padding(.trailing, geometry.size.width * 0.07)
                                                    .blur(radius: geometry.size.width * 0.05)
                                            }
                                        }
                                    }
                                }
                                .padding(.top)
                            }
                            DailyPopUp()
                        }
                        
                        
                        
                        Spacer()
                    }
                }
                .background(Color.white)
            }
            
        }
    }
    
    var filteredProfilesForVotes: [Profile] {
        
        if votesViewSearchText.isEmpty {
            return model.profiles
            
        } else {
            return model.profiles.filter { profile in
                
                profile.name.contains(votesViewSearchText)
                
            }
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.windows.forEach { $0.endEditing(true) }
        }
    
 
    
}

//
//  OnboardingView.swift
//  Number1
//
//  Created by Joël Lacoste-Therrien on 2023-08-14.
//
import UserNotifications
import SwiftUI

struct OnboardingView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @State var loginFormShowing = false
    
    @State var createFormShowing = false
    
    @State var tabSelection = 0
    
    let customColor1 = Color(red: 246/255, green: 46/255, blue: 55/255, opacity: 1)
    
    let customColor2 = Color(red: 170/255, green: 7/255, blue: 14/255, opacity: 1)
    
    var body: some View {
        
        NavigationView{
            
            VStack {
                
                TabView(selection: $tabSelection) {
                    
                    ZStack {
                        
                        CustomRectangle()
                            
                        
                        VStack {
                            
                            Image("shushing-face-transparent-2")
                                .resizable()
                                .frame(width: 180, height: 280)
                                .shadow(radius: 100)
                            
                            Text("Welcome to the")
                                .font(.custom("AvenirNext-Bold", size: 32))
                                .italic()
                                .bold()
                                .padding(.bottom, 1)
                                .foregroundColor(.black)
                           
                            
                            Text("NUMBER1 APP")
                                .multilineTextAlignment(.center)
                                .bold()
                                .font(.custom("AvenirNext-Bold", size: 42))
                                .italic()
                                .padding(.horizontal, 2)
                                .frame(width: 350)
                                .foregroundColor(.black)
                            
                            Text("Who will be first?")
                                .padding(.top)
                                .foregroundColor(.black)
                        }
                        
                    
                    }
                    .edgesIgnoringSafeArea(.all)
                    .frame(height:900)
                    .tag(0)
                   
                    
                    VStack {
                        Image(systemName: "bell")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .padding(.bottom)
                            .foregroundColor(.red)
                        Text("Every Day a Notification Gets Sent at a Random Time")
                            .bold()
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .frame(height: 200)
                            .foregroundColor(.black)
                        Text("A question or sentence will appear...")
                            .foregroundColor(.black)
                    }
                    .tag(1)
                    
                    VStack {
                        Image(systemName: "person")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .padding(.bottom)
                            .foregroundColor(.red)
                        Text("They are always designed to make you think of a person you know.")
                            .bold()
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .frame(height: 200)
                            .foregroundColor(.black)
                        
                        Text("You need to vote for the user who fits the daily sentence the most. Here are some examples:")
                            .multilineTextAlignment(.center)
                            .padding(.bottom)
                            .padding(.horizontal)
                            .foregroundColor(.black)
                        
                        HStack {
                            Image(systemName: "hand.point.right")
                                .foregroundColor(.red)
                            
                            Text("Who is the hottest person I know?")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                        .padding(.top)
                        HStack {
                            Image(systemName: "hand.point.right")
                                .foregroundColor(.red)
                            
                            Text("The most likely to never pay you back.")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                        .padding(.top)
                        HStack {
                            Image(systemName: "hand.point.right")
                                .foregroundColor(.red)
                            
                            Text("Who can't be trusted with a secret?")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                        .padding(.top)
                    }
                    .tag(2)
                    
                    VStack {
                        Image(systemName: "archivebox")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .padding(.bottom)
                            .foregroundColor(.red)
                        Text("At the notification, vote for the person that fits the daily sentence best by clicking the red button")
                            .bold()
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .frame(height: 200)
                            .foregroundColor(.black)
                        
                        Text("When you do, you will be able to see the results of all the votes.")
                            .multilineTextAlignment(.center)
                            .padding(.bottom)
                            .padding(.horizontal)
                            .foregroundColor(.black)
                        
                    }
                    .tag(3)
                    
                    VStack {
                        Image(systemName: "pencil.and.ellipsis.rectangle")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .padding(.bottom)
                            .foregroundColor(.red)
                        Text("How does the daily sentence appear?")
                            .bold()
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .frame(height: 200)
                            .foregroundColor(.black)
                        
                        Text("Simple. Users write them and vote for their favorite. The most popular becomes the sentence of the next day.")
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .foregroundColor(.black)
                        
                    }
                    .tag(4)
                    
                    VStack {
                        Image(systemName: "trophy")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .padding(.bottom)
                            .foregroundColor(.red)
                        Text("Be careful, you only get to vote for 1 person and 1 sentence a day.")
                            .bold()
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .frame(height: 200)
                            .foregroundColor(.black)
                        
                        Text("But you can write and subit as many sentences/questions as you want.")
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .foregroundColor(.black)
                        
                    }
                    .tag(5)
                    
                    CreateAnAccountView()
                    .tag(6)
                    
                    
                }
                .ignoresSafeArea()
                .background(Color.white)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            }
            .ignoresSafeArea() //
        }
        .accentColor(.white)
        
        
    }
        
    
}
    

struct ObboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(ContentModel())
    }
}

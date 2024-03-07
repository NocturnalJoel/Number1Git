//
//  PermissionsView.swift
//  Number1
//
//  Created by Joël Lacoste-Therrien on 2023-09-01.
//

import SwiftUI

struct PermissionsView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @State private var showAlert = false
    
    @State var tabSelection = 0
    
    var body: some View {
        TabView {
            
            VStack {
                
                Title(subTitle: "Invite Friends")
                
                Spacer()
                
                Image(systemName: "person.2")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .padding(.bottom)
                    .foregroundColor(.red)
                
                
                Text("Great!")
                    .bold()
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .frame(height: 100)
                    .foregroundColor(.black)
                
                Text("But don't you think it's a little lonely in here?")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .foregroundColor(.black)
                
                Spacer()
                
                Button {
                    model.inviteFriends()
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.red)
                            .cornerRadius(15)
                            .padding(.horizontal)
                            .frame(height: 55)
                        Text("Add some friends to spice things up.")
                            .bold()
                            .foregroundColor(.white)
                    }
                    
                    
                }
                .buttonStyle(.plain)
                .padding(.top)
                
                
                
                
                Text("Swipe to skip")
                    .underline()
                    .foregroundColor(.black)
                
                Spacer()
            }
            .tag(0)
            
            VStack {
                
                Title(subTitle: "Almost There!")
                
                Spacer()
                Image(systemName: "trophy")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .padding(.bottom)
                    .foregroundColor(.red)
              
                Spacer()
               
                if model.notificationsPermissionGranted == true {
                    
                    Button {
                        model.loggedIn = true
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.red)
                                .cornerRadius(15)
                                .padding(.horizontal)
                                .frame(height: 55)
                            
                            Text("Let's get started")
                                .bold()
                                .foregroundColor(.white)
                        }
                    }
                    .buttonStyle(.plain)
                    Spacer()
                    
                }
                else if model.notificationsPermissionGranted == false {
                    Button {
                        model.requestNotificationsPermission()
                        
                        
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.red)
                                .cornerRadius(15)
                                .padding(.horizontal)
                                .frame(height: 55)
                            
                            Text("Enable notifications to play the game.")
                                .bold()
                                .foregroundColor(.white)
                        }
                    }
                    .buttonStyle(.plain)
                    .alert(isPresented: $model.showAlert) {
                                Alert(
                                    title: Text("Notifications Permission Required"),
                                    message: Text("To use this app, you need to allow notifications. You can enable notifications by going to your settings."),
                                    primaryButton: .default(Text("Open Settings")) {
                                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                            UIApplication.shared.open(settingsURL)
                                        }
                                    },
                                    secondaryButton: .cancel()
                                )
                            }
                }
                
                Text("Yes it's mandatory. Cry about it.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top)
                    .foregroundColor(.black)
                Spacer()
            }
            .tag(1)
        }
        .background(Color.white)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        
    }
}

struct PermissionsView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionsView()
            .environmentObject(ContentModel())
    }
}

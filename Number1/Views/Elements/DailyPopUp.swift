//
//  DailyPopUp.swift
//  Number1
//
//  Created by Joël Lacoste-Therrien on 2023-10-02.
//

import SwiftUI

struct DailyPopUp: View {
 
    @State var showConfetti = false
    
    @EnvironmentObject var model: ContentModel
    
    let customColor1 = Color(red: 246/255, green: 46/255, blue: 55/255, opacity: 1)
    
    let customColor2 = Color(red: 170/255, green: 7/255, blue: 14/255, opacity: 1)
    
    
    var body: some View {
        
        ZStack {
            
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(15)
                .shadow(radius: 15)
            
            VStack (spacing: 30) {
                
                Text("Welcome to a new day on NUMBER1")
                    .foregroundColor(.black)
                    .font(.custom("AvenirNext-Bold", size: 30))
                    .italic()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text("Today's question/sentence is:")
                    .foregroundColor(.black)
                    .font(.custom("AvenirNext-Bold", size: 22))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .underline()
                   
                
                Text(model.promptOfTheDay)
                    .foregroundColor(.black)
                    .font(.custom("AvenirNext", size: 22))
                    .multilineTextAlignment(.center)
                    .onAppear {
                        self.showConfetti = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            self.showConfetti = false
                        }
                    }
                
                NavigationLink {
                    VoteForPersonView()
                } label: {
                    ZStack {
                        
                        Rectangle()
                            .fill(
                                LinearGradient(gradient: Gradient(colors: [customColor1, customColor2]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                            .ignoresSafeArea()
                            .cornerRadius(15)
                        
                        Text("Vote for someone to see the poll's results!")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .font(.custom("AvenirNext-Bold", size: 24))
                    }
                }
                .buttonStyle(.plain)
                .frame(width: 300, height: 100)

                            }
            
            if showConfetti {
                ConfettiView()
            }

        }
        .frame(width: 325, height: 400)
        .padding(.bottom)
        
        
        
    }
}

struct ConfettiView: View {
    
    let colors: [Color] = [.red, .green, .blue, .yellow, .pink, .purple, .orange]
    
    var body: some View {
        ZStack {
            ForEach(0..<100) { _ in
                ConfettiPieceView(color: colors.randomElement() ?? .black)
            }
        }
    }
}

struct ConfettiPieceView: View {

    @State private var animationFlag = false
    let color: Color
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: 8, height: 16)
            .offset(y: animationFlag ? 500 : -100)
            .rotationEffect(.degrees(Double.random(in: 0...360)))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0...0.5)) {
                    withAnimation(Animation.easeInOut(duration: 1.5)) {
                        self.animationFlag.toggle()
                    }
                }
            }
            .animation(animationFlag ? Animation.easeInOut(duration: 1.5) : .none)
    }
}

//
//  LogInView.swift
//  Number1
//
//  Created by Joël Lacoste-Therrien on 2023-08-14.
//

import SwiftUI
import FirebaseAuth

struct LogInView: View {
    
 
    
    @EnvironmentObject var model: ContentModel
    
    @State var email:String = ""
    @State var password:String = ""
    @State var errorMessage : String?
    
    var body: some View {
        
        
        
        NavigationView {
            
            if model.goOn == false {
                VStack (spacing: 50) {
                    
                    Title(subTitle: "Sign In")
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.red)
                            .frame(height: 48)
                        
                        
                        HStack {
                            Text("Email:")
                                .bold()
                                .foregroundColor(.black)
                            
                            TextField("", text: $email)
                        }
                        .padding(.horizontal)
                        
                    }
                    .padding(.horizontal)
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.red)
                            .frame(height: 48)
                        
                        
                        HStack {
                            Text("Password:")
                                .bold()
                                .foregroundColor(.black)
                            
                            SecureField("", text: $password)
                        }
                        .padding(.horizontal)
                        
                    }
                    .padding(.horizontal)
                    
                    if errorMessage != nil {
                        
                            Text(errorMessage!)
                        
                    }
                    Button {
                        if email != "" && password != "" {
                            signIn()
                            model.goOn = true
                        }
                        else {
                            
                        }
                        
                    } label: {
                        ZStack{
                            Rectangle()
                                .cornerRadius(15)
                                .foregroundColor(.red)
                                .frame(height: 48)
                                .padding(.horizontal)
                            
                            Text("Sign In")
                                .bold()
                                .foregroundColor(.white)
                        }
                    }
                    .buttonStyle(.plain)
                    Spacer()
                    Spacer()
                }
            }
            else if model.goOn {
                VStack {
                    Title(subTitle: "Log In")
                    
                    NavigationLink(destination: PermissionsView().navigationBarBackButtonHidden(true)) {
                        ZStack {
                            CustomRectangle()
                                .cornerRadius(15)
                                .frame(width: 300, height: 150, alignment: .center)
                                .padding()
                            
                            Text("Go On!")
                                .foregroundColor(.white)
                                .font(.custom("AvenirNext-Bold", size: 42))
                                .italic()
                        }
                    }
                    .buttonStyle(.plain)

                }
            }
        }
        .background(Color.white)
   
    }
    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            
            DispatchQueue.main.async {
                
                if error == nil {
                    
                    print("bitchassPussy")
                    model.goOn = true
                }
                else {
                    errorMessage = error!.localizedDescription
                }
            }
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}

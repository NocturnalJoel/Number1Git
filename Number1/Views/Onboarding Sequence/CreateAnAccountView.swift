import SwiftUI
import FirebaseAuth
import Firebase
import GoogleSignIn
import FBSDKCoreKit


struct CreateAnAccountView: View {
    
    
    
    @EnvironmentObject var model: ContentModel
    
    @State var email: String = ""
    @State var password: String = ""
    @State var name: String = ""
    @State var errorMessage: String?
    @State var firstName = ""
    @State var lastName = ""
    
    var body: some View {
        
        
        if model.goOn == false {
            VStack(spacing: 20) {
                Group{
                    Title(subTitle: "Create Account")
                    
                    NavigationLink {
                        LogInView()
                    } label: {
                        Text("Already got an account? Log in")
                            .foregroundColor(.black)
                            .underline()
                            .font(.callout)
                    }.buttonStyle(.plain)
                    
                    
                    
                    
                    Spacer()
                }
                Group {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.red)
                            .frame(height: 48)
                        
                        HStack {
                            Text("First Name:")
                                .bold()
                                .foregroundColor(.black)
                            
                            TextField("", text: $firstName)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.horizontal)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.red)
                            .frame(height: 48)
                        
                        HStack {
                            Text("Last Name:")
                                .bold()
                                .foregroundColor(.black)
                            
                            TextField("", text: $lastName)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.horizontal)
                    
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
                }
                
                if errorMessage != nil {
                    Text(errorMessage!)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                }
                
                Button {
                    if email != "" && password != "" && firstName != "" && lastName != "" {
                        createAccount()
                    } else {
                        // Handle incomplete fields
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(.red)
                            .frame(height: 48)
                            .padding(.horizontal)
                        
                        Text("Submit")
                            .bold()
                            .foregroundColor(.white)
                    }
                }
                .buttonStyle(.plain)
                
                Divider()
                
                Text("Or")
                
                Button(action: {
                    model.signInWithGoogle()
                }, label: {
                    ZStack {
                        
                        RoundedRectangle(cornerSize: CGSize(width: CGFloat(15), height: CGFloat(15)))
                            .frame(height: 75)
                            .foregroundColor(.white)
                            .overlay(
                                RoundedRectangle(cornerSize: CGSize(width: CGFloat(15), height: CGFloat(15)))
                                    .stroke(Color.black, lineWidth: 1)
                            )
                        
                            .padding(.horizontal)
                        
                        
                        HStack {
                            
                            Image("googlelogo1")
                                .resizable()
                                .scaledToFit()
                                .padding()
                            
                            
                            Text("Sign in with Google")
                                .foregroundColor(.black)
                                .bold()
                            
                            
                        }
                    }
                })
                .padding(.top, 10)
                .buttonStyle(.plain)
                
                Button(action: {
                    model.signInWithFacebook()
                }, label: {
                    
                    
                    ZStack {
                        
                        RoundedRectangle(cornerSize: CGSize(width: CGFloat(15), height: CGFloat(15)))
                            .frame(height: 75)
                            .foregroundColor(.blue)
                        
                        
                            .padding(.horizontal)
                        
                        
                        HStack {
                            
                            Image("facebooklogo")
                                .resizable()
                                .scaledToFit()
                                .padding()
                            
                            
                            Text("Sign in with Facebook")
                                .foregroundColor(.white)
                                .bold()
                            
                            
                        }
                    }
                })
                .padding(.bottom)
                .buttonStyle(.plain)
                
                Spacer()
                Spacer()
            }
            .background(Color.white)
            
        } else if model.goOn {
           
            
                
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
    
    func createAccount() {
        Auth.auth().createUser(withEmail: email, password: password) { [self] result, error in
            DispatchQueue.main.async {
                if error == nil {
                    // User account created successfully, now sign in the user
                    Auth.auth().signIn(withEmail: email, password: password) { [self] authResult, signInError in
                        if signInError == nil {
                            // User signed in successfully
                    
                            createName()
                            userCreation()
                            model.goOn = true
                            model.fetchCurrentUser()
                           
                        } else {
                            errorMessage = signInError!.localizedDescription
                        }
                    }
                } else {
                    errorMessage = error!.localizedDescription
                }
            }
        }
    }
    
    func createName() {
        name = firstName + " " + lastName
    }
    
    func userCreation() {
        if let currentUser = Auth.auth().currentUser {
            let db = Firestore.firestore()
            let path = db.collection("Users").document(currentUser.uid)
            
            let userData: [String: Any] = [
                "id": currentUser.uid,
                "name": name,
                "listPosition": 0,
                "numberOfVotesProfile": 0,
                "isSelected": false,
                "hasVoted": false,
                "hasVotedForPrompt": false,
                "greenDot" : false
            ]
            
            path.setData(userData) { error in
                if let error = error {
                    // Handle the error if data couldn't be added to Firestore
                    print("Error creating user document: \(error.localizedDescription)")
                } else {
                    // User document created successfully
                    print("User document created in Firestore.")
                    model.goOn = true
                }
            }
        } else {
            // Handle the case where there's no signed-in user
            print("No user is currently signed in.")
        }
    }
}


//struct CreateAnAccountView_Previews: PreviewProvider {
//    static var previews: some View {
     //   CreateAnAccountView()
//    }
//}

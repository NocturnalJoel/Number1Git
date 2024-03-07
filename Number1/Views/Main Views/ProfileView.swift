//
//  ProfileView.swift
//  Number1
//
//  Created by Joël Lacoste-Therrien on 2023-08-13.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

struct ProfileView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @State var showImagePicker: Bool = false
    @State var selectedImage: UIImage?
    @State var downloadedImage: UIImage?
    
    var body: some View {
        
        NavigationView {
            
            GeometryReader { geometry in
                ScrollView{
                VStack (spacing: geometry.size.height * 0.01){
                    
                    Title(subTitle: "Profile")
                    
                    Spacer()
                    
                    Group {
                        
                        if let image = downloadedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            ZStack{
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 100, height: 100)
                                
                                Image(systemName: "person")
                                    .frame(width: 90, height: 90)
                            }
                        }
                        
                        Button("Change Photo") {
                            showImagePicker.toggle()
                        }
                        .sheet(isPresented: $showImagePicker, onDismiss: {
                            saveProfileImage(selectedImage: selectedImage)
                            downloadImage()
                        }) {
                            ImagePicker(isPresented: $showImagePicker, image: $selectedImage)
                            
                        }
                        
                        
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: geometry.size.width * 0.03)
                            .stroke(Color.red)
                            .frame(height: geometry.size.height * 0.1)
                        
                        VStack {
                            Text("Name")
                                .font(.custom("AvenirNext-Bold", size: geometry.size.width * 0.05))
                            
                            Text(model.currentUser?.name ?? "")
                                .font(.custom("AvenirNext", size: geometry.size.width * 0.05))
                        }
                        
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: geometry.size.width * 0.03)
                            .stroke(Color.red)
                            .frame(height: geometry.size.height * 0.15)
                        
                        VStack {
                            Text("Affiliations")
                                .font(.custom("AvenirNext-Bold", size: geometry.size.width * 0.05))
                            ZStack {
                                Capsule()
                                    .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.04)
                                    .foregroundColor(.gray)
                                HStack {
                                    Image(systemName: "multiply.circle")
                                    Text("Université de Sherbrooke")
                                        .font(.custom("AvenirNext", size: geometry.size.width * 0.05))
                                }
                                
                            }
                        }
                        .padding(.vertical)
                        Spacer()
                    }
                    
                    if model.canSeeWhoVoted == false {
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: geometry.size.width * 0.03)
                                .stroke(Color.red)
                                .frame(height: geometry.size.height * 0.2)
                            VStack {
                                Text("Share the app to see who voted for you!")
                                    .foregroundColor(.black)
                                    .font(.custom("AvenirNext-Bold", size: geometry.size.width * 0.05))
                                    .padding(.horizontal)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, geometry.size.height * 0.02)
                                
                                Text("You can do so by clicking the button at the bottom of the Home Page.")
                                    .multilineTextAlignment(.center)
                                    .font(.custom("AvenirNext", size: geometry.size.width * 0.05))
                            }
                        }
                        
                    } else if model.canSeeWhoVoted {
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: geometry.size.width * 0.03)
                                .stroke(Color.red)
                                .frame(height: geometry.size.height * 0.15)
                            VStack{
                                Text("Have voted for me:")
                                    .font(.custom("AvenirNext-Bold", size: geometry.size.width * 0.05))
                                    .padding(.bottom, geometry.size.height * 0.02)
                                
                                Text(model.currentUser?.votedForMe.joined(separator: ", ") ?? "")
                                    .padding(.horizontal)
                                    .multilineTextAlignment(.center)
                                    .font(.custom("AvenirNext", size: geometry.size.width * 0.05))
                            }
                        }
                    }
                    
                    Text("My NUMBER1s ")
                        .font(.custom("AvenirNext-Bold", size: geometry.size.width * 0.05))
                        .padding(.vertical)
                    
                    ForEach(model.historyElements) { item in
                        if item.topPerson == model.currentUser?.name {
                            ZStack{
                                Rectangle()
                                    .cornerRadius(20)
                                    .frame(height: 70)
                                    .foregroundColor(.white)
                                    .shadow(radius: 3)
                                    .padding(.horizontal)
                                
                                Text(item.dailyPrompt)
                            }
                        }
                    }
                    
                    Button {
                        
                        logout()
                        
                    } label: {
                        ZStack{
                            Rectangle()
                                .cornerRadius(geometry.size.width * 0.03)
                                .foregroundColor(.red)
                                .frame(height: geometry.size.height * 0.1)
                                .padding(.horizontal)
                            
                            Text("Log Out")
                                .bold()
                                .foregroundColor(.white)
                                .font(.custom("AvenirNext-Bold", size: geometry.size.width * 0.045))
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.vertical)

                    
                    
                    Spacer()
                    
                }
                .padding(.horizontal)
                .background(Color.white)
            }
            }
        }
        .onAppear(perform: {
                downloadImage()
            })
    }
    
    func saveProfileImage(selectedImage: UIImage?) {
        guard let image = selectedImage else { return }
        
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
        
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("profile_pictures/\(UUID().uuidString).jpg")
        
        imageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Error uploading image: \(error)")
                return
            }
            
            imageRef.downloadURL { url, error in
                if let error = error {
                    print("Error fetching URL: \(error)")
                    return
                }
                
                guard let urlString = url?.absoluteString else { return }
                
                if let userId = Auth.auth().currentUser?.uid {
                    let db = Firestore.firestore()
                    let userDoc = db.collection("Users").document(userId)
                    
                    userDoc.updateData([
                        "profileImageURL": urlString
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            model.currentUser?.profileImageURL = urlString
                        }
                    }
                }
            }
        }
    }
    
    func downloadImage() {
        
  
        if let urlString = model.currentUser?.profileImageURL, let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.downloadedImage = image
                    }
                }
            }.resume()
        }
    }

    
    func logout() {
        do {
            try Auth.auth().signOut()
            // Successful logout, navigate to the OnboardingView
            
            // Dismiss the current view (if applicable)
       
                       model.loggedIn = false
                   
            print("User logged out successfully.")
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
}



struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(ContentModel())
    }
}

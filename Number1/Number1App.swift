import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import UserNotifications
import BackgroundTasks
import UIKit
import FBSDKCoreKit



@main
struct Number1App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @EnvironmentObject var model: ContentModel
    
    @State private var showOnboarding = false

    
    init() {
        
       // FirebaseApp.configure()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        

    }
    
    var body: some Scene {
            WindowGroup {
                
                LaunchView()
                    .environmentObject(ContentModel())
               
                   
                      
                        
                        
                }
            }
            
        }
    

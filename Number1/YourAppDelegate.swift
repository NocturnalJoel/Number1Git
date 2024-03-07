import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import FBSDKCoreKit
import FacebookCore

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate{
    
    // Consider making ContentModel a singleton if it holds shared state
    let model = ContentModel()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application(
                application,
                didFinishLaunchingWithOptions: launchOptions
            )
        // Setup UNUserNotificationCenter
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("Notification authorization granted")
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else if let error = error {
                print("Notification authorization denied: \(error.localizedDescription)")
            }
            
            

        }
        
        model.fetchCurrentUser()
        model.getPrompts()
        model.getUsers()
        model.getPrompt()
        
        Messaging.messaging().delegate = self
                registerForPushNotifications()
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

     
            
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device Token: \(token)")
        // Pass this device token to Firebase
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
        // TODO: Consider sending this error information to your server for debugging
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
     
    }
    func registerForPushNotifications() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                print("Permission granted: \(granted)")
                guard granted else { return }
                self.getNotificationSettings()
            }
        }

        func getNotificationSettings() {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                print("Notification settings: \(settings)")
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken)")
        
        
        // TODO: Send this token to your server or save in Firestore
        if let userID = Auth.auth().currentUser?.uid, let newToken = fcmToken {
            let usersRef = Firestore.firestore().collection("Users").document(userID)
            usersRef.setData(["fcmToken": newToken], merge: true) { err in
                if let err = err {
                    print("Error writing token: \(err)")
                } else {
                    print("FCM token successfully written!")
                }
            }
        }
    }
    @available(iOS 9.0, *)
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(
                app,
                open: url,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )
      return GIDSignIn.sharedInstance.handle(url)
    }


}

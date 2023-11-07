//
//  WallpaperIOSApp.swift
//  WallpaperIOS
//
//  Created by Mac on 25/04/2023.
//

import SwiftUI
import FirebaseCore
import FirebaseAnalytics
import FirebaseMessaging
import FirebaseRemoteConfig


class AppDelegate : NSObject, UIApplicationDelegate {
    let FLURRY_API : String = "QZVMFBWBYKFV6QZPY5HM"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("MYSTORE--- FirebaseApp.configure() init")
        FirebaseApp.configure()

        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
                Messaging.messaging().delegate = self
                Messaging.messaging().token { token, error in
            if let error = error {
                print("TRUNGDUC Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("TRUNGDUC FCM registration token: \(token)")
                //  self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
            }
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("TRUNG DUC didRegisterForRemoteNotificationsWithDeviceToken 🥳 \(deviceToken.base64EncodedString())")
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
    }
    
    
  
}

@main
struct WallpaperIOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            
//            EztSubcriptionView()
            
//            NavigationView{
//                EztMainView()
//            } .preferredColorScheme(.dark)
               
            
     
            
            SplashView()
                .statusBarHidden(false)
                .preferredColorScheme(.dark)
              
        }
    }
}


extension AppDelegate : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo

        return [[.alert, .sound]]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
       
    }
    
    // Silent notifications
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
    -> UIBackgroundFetchResult {
    
        
        return UIBackgroundFetchResult.newData
    }
}


extension AppDelegate : MessagingDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let dataDict : [String : String] = ["token" : fcmToken ?? ""]
        print("TRUNG DUC \(String(describing: fcmToken))")
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
}





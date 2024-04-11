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
import AVFoundation
import UserMessagingPlatform
import Adjust


class AppDelegate : NSObject, UIApplicationDelegate {
 
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("MYSTORE--- FirebaseApp.configure() init")
        FirebaseApp.configure()

        let yourAppToken = "112iadqgoq74"
        let environment = ADJEnvironmentProduction //ADJEnvironmentSandbox //
        let adjustConfig = ADJConfig(
            appToken: yourAppToken,
            environment: environment)
        Adjust.appDidLaunch(adjustConfig)
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default)
            try AVAudioSession.sharedInstance().setActive(true)
            print("DEBUG: setup success")
        } catch let error as NSError {
            print("Setting category to AVAudioSessionCategoryPlayback failed: \(error)")
        }
        
        
        
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





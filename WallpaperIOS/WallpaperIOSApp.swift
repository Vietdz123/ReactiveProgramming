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
        //    ContentView()
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




//var remoteConfig = RemoteConfig.remoteConfig()
//let settings = RemoteConfigSettings()
//settings.minimumFetchInterval = 0
//remoteConfig.configSettings = settings
//remoteConfig.setDefaults(fromPlist: "GoogleService-Info")
//fetchConfig(remoteConfig: remoteConfig)


//func fetchConfig(remoteConfig : RemoteConfig) {
//
//    remoteConfig.fetch { (status, error) -> Void in
//        if status == .success {
//           remoteConfig.activate { changed, error in
//                let wl_domain = remoteConfig.configValue(forKey: "wl_domain").stringValue ?? "http://3.8.138.29/"
//                let reward_delay = remoteConfig.configValue(forKey: "reward_delay").numberValue
//                let allowShowRate = remoteConfig.configValue(forKey: "allow_show_rate").boolValue
//                let productsJsonStr = remoteConfig.configValue(forKey: "products").stringValue ?? "[\"com.ezt.wl.monthly\", \"com.ezt.wl.yearly\"]"
//
//
//                UserDefaults.standard.set(wl_domain, forKey: "wl_domain")
//                UserDefaults.standard.set(reward_delay, forKey: "delay_reward")
//                UserDefaults.standard.set(allowShowRate, forKey: "allow_show_rate")
//                UserDefaults.standard.set(productsJsonStr, forKey: "products")
//
//
//
//                print("FIREBSE REMOTE CONFIG wl_domain \(wl_domain)")
//                print("FIREBSE REMOTE CONFIG reward_delay \(reward_delay)")
//                print("FIREBSE REMOTE CONFIG allowShowRate \(allowShowRate)")
//               print("FIREBSE REMOTE CONFIG productsJsonStr \(productsJsonStr)")
//
//
//
//
//
//            }
//        } else {
//            print("Config not fetched")
//            print("Error: \(error?.localizedDescription ?? "No error available.")")
//        }
//
//    }
//
//
//
//}

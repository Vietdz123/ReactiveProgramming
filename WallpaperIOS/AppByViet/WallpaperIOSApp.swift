//
//  WallpaperIOSApp.swift
//  WallpaperIOS
//
//  Created by Mac on 25/04/2023.
//

import SwiftUI
import FirebaseCore
import FirebaseAnalytics
import AVFoundation
import UserMessagingPlatform
import Adjust
import GoogleMobileAds
import FirebaseMessaging
import FirebaseRemoteConfig
import AppTrackingTransparency

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

     
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("TRUNG DUC didRegisterForRemoteNotificationsWithDeviceToken 🥳 \(deviceToken.base64EncodedString())")
        
        
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
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



@main
struct WallpaperIOSApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let notFirstTimeGoApp : Bool = UserDefaults.standard.bool(forKey: "firstTimeLauncher")
    @StateObject private var appVM = AppViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .bottomLeading) {
                if notFirstTimeGoApp == false {
                    OnboardingView()
                        .ignoresSafeArea()
                    
                } else {
                    EztMainView()
                        .ignoresSafeArea()
                }
                
                
                if appVM.isActivedSplash {
                    SplashView()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .statusBarHidden(false)
                        .preferredColorScheme(.dark)
                }
                
                
            }
        }
    }
    
    
    func showATTandGDPR(onComplete : @escaping () -> ()){
        print("showATTandGDPR 1")

        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
            print("showATTandGDPR 2")
            DispatchQueue.main.async {
                onComplete()
            }
           
            
            if UserDefaults.standard.bool(forKey: "send_log_att") == false{
                FirebaseHelper.share.log("ATT_Tracking_show")
                UserDefaults.standard.set(true, forKey: "send_log_att")
            }
          
            
            
            if status == .authorized {
                if UserDefaults.standard.bool(forKey: "send_log_att_success") == false{
                    FirebaseHelper.share.log("ATT_Tracking_authorized")
                    UserDefaults.standard.set(true, forKey: "send_log_att_success")
                }
            } else {
                DispatchQueue.main.async {
                    onComplete()
                }
            
                return
            }
            
            // Create a UMPRequestParameters object.
            let parameters = UMPRequestParameters()
            // Set tag for under age of consent. false means users are not under age
            // of consent.
            let debugSettings = UMPDebugSettings()
            debugSettings.testDeviceIdentifiers = ["AF93D002-26D2-44FC-8CFE-671A01A5571A"]
            debugSettings.geography = .EEA
            parameters.debugSettings = debugSettings
            parameters.tagForUnderAgeOfConsent = false
            
            GADMobileAds.sharedInstance().start()
            
            
            // Request an update for the consent information.
            UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: parameters) {
                requestConsentError in
                
                if let consentError = requestConsentError {
                    // Consent gathering failed.
                    return print("Error: \(consentError.localizedDescription)")
                }
                
                UMPConsentForm.loadAndPresentIfRequired(from: getRootViewController()) { (loadAndPresentError) in
                    
                    if let consentError = loadAndPresentError {
                        return print("Error: \(consentError.localizedDescription)")
                    }
                    
                }
            }
            
            
        })
    }
    
    func getRootViewController() -> UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first   as? UIWindowScene
        else{
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else{
            return .init()
        }
        return root
    }
}



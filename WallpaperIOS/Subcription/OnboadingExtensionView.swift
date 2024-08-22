//
//  OnboadingExtensionView.swift
//  WallpaperIOS
//
//  Created by Duc on 09/05/2024.
//

import SwiftUI
import AVKit
import AppTrackingTransparency
import UserMessagingPlatform
import GoogleMobileAds
extension OnboardingView {
    
    func rootView() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first   as? UIWindowScene
        else{
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else{
            return .init()
        }
        return root
    }
    
    //MARK: show ATT and GDPR
    func showATTandGDPR(){
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
            // Create a UMPRequestParameters object.
            
            GADMobileAds.sharedInstance().start()
            rewardAd.loadRewardedAd()
            interAd.loadInterstitial()
            
            
            if status != .authorized {
                return 
            }
            
            
            
            let parameters = UMPRequestParameters()
            // Set tag for under age of consent. false means users are not under age
            // of consent.
            let debugSettings = UMPDebugSettings()
            debugSettings.testDeviceIdentifiers = ["2CCEC876-0E47-4237-865A-78C8D7B08814"]
            debugSettings.geography = .EEA
            parameters.debugSettings = debugSettings
            parameters.tagForUnderAgeOfConsent = false
            
            // Request an update for the consent information.
            UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: parameters) {
                requestConsentError in
                
                if let consentError = requestConsentError {
                    // Consent gathering failed.
                    return print("Error: \(consentError.localizedDescription)")
                }
                
                UMPConsentForm.loadAndPresentIfRequired(from: rootView()) { (loadAndPresentError) in
                    
                    if let consentError = loadAndPresentError {
                        return print("Error: \(consentError.localizedDescription)")
                    }
                    
                    
                    print("chay vao day khong")
                 
                    
                    
                }
            }
            
            
        })
    }
    
    
    //MARK: Video screen
    
    func Screen_1() -> some View{
        VideoOnboarding(video_name: "video1")
    }
    
    func Screen_2() -> some View{
        VideoOnboarding(video_name: "live")
    }
    
    func Screen_3() -> some View{
        VideoOnboarding(video_name: "intro 2")
    }
    func Screen_4() -> some View{
        VideoOnboarding(video_name: "depth_effect")
    }
    func Screen_5() -> some View{
        VideoOnboarding(video_name: "shuffle_packs")
    }
    
    func Screen_6() -> some View{
        VideoOnboarding(video_name: "watchface")
        
    }
    
    func Screen_7() -> some View{
        VideoOnboarding(video_name: "video5")
        
    }
    
    func Screen_8() -> some View{
        VideoOnboarding(video_name: "intro 6")
        
    }
    
    func Screen_9() -> some View{
        VideoOnboarding(video_name: "bg")
    }
    
}


struct VideoOnboarding : View{
    
    @State var avPlayer : AVPlayer?
    let video_name : String
    
    
    var body: some View{
        ZStack{
            if  avPlayer != nil{
                MyVideoPlayer(player: avPlayer!)
                    .ignoresSafeArea()
                    .gesture(DragGesture())
            }
        }
        
        .onAppear(perform: {
            if let url =  Bundle.main.url(forResource: video_name, withExtension: "mp4") {
                avPlayer = AVPlayer(url: url)
                avPlayer!.play()
            }
            
        })
        .onDisappear(perform: {
            if avPlayer != nil{
                avPlayer!.pause()
            }
            avPlayer = nil
        })
        
        
    }
}


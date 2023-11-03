//
//  RewardAd.swift
//  WallpaperIOS
//
//  Created by Mac on 25/05/2023.
//



import SwiftUI
import UIKit
import GoogleMobileAds


#if DEBUG
let adRewardUnitID = "ca-app-pub-3940256099942544/1712485313"
#else
let adRewardUnitID = "ca-app-pub-5782595411387549/3315917452"
#endif


class RewardAd: NSObject, ObservableObject , GADFullScreenContentDelegate {

  @Published var rewardedAd: GADRewardedAd?
    
    private var onComplete: ( (Bool) -> Void )?

    @Published var loadTime : Int = 0
    
    override init() {
        super.init()
        if self.rewardedAd == nil {
            loadRewardedAd()
        }

    }
 
    
    func loadRewardedAd() {
       
        
        
        if rewardedAd != nil {
            return
        }
     
        let request = GADRequest()
        request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
     
        self.loadTime+=1
        print("ADS LOAD RV")
        GADRewardedAd.load(withAdUnitID: adRewardUnitID, request: request) { [weak self](rewardedAd, error) in
            
            if let error = error {
                if self!.loadTime < 4 {
                    self!.loadRewardedAd()
                }
                print(error.localizedDescription)
                
                return
            }
            
            self?.rewardedAd = rewardedAd
            
            if self?.rewardedAd != nil{
                self?.rewardedAd?.fullScreenContentDelegate = self
            }
            
          
            
        
           
        }
    }
    

    func presentRewardedVideo(onCommit: @escaping (Bool) -> Void) {

        self.onComplete = onCommit
        
        guard let rewardedAd = rewardedAd else {
            loadTime = 0
            loadRewardedAd()
            if self.onComplete != nil {
                self.onComplete!(false)
            }
            return
        }
  
        guard let root = UIApplication.shared.windows.first?.rootViewController else {
            if self.onComplete != nil {
                self.onComplete!(false)
            }
            return
        }
      
      
        DispatchQueue.main.async {
            rewardedAd.present(fromRootViewController: root) {
               
                    if self.onComplete != nil {
                        self.onComplete!(true)
                      
                    }
           }
        }
       
         
            
           
            
        
    }
    
    
    
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
         //  print("0. impression recorded")
       }

       /// Tells the delegate that the ad presented full screen content.
      
       
       /// Tells the delegate that the ad will dismiss full screen content.
       func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        //   print("2. willDimiss ad")
        
       }
       
       /// Tells the delegate that the ad dismissed full screen content.
       func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
       //    print("3. didDimiss ad")
           self.rewardedAd = nil
           if onComplete != nil {
               onComplete  = nil
           }
           loadRewardedAd()
       }
       
       /// Tells the delegate that a click has been recorded for the ad.
       func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        //   print("4. impression click detected")
       }
       
       /// Tells the delegate that the ad failed to present full screen content.
       func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
         //  print("5. didFailToReceiveAdWithError: \(error.localizedDescription)")
       }
}


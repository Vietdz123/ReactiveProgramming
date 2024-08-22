//
//  InterAds.swift
//  WallpaperIOS
//
//  Created by Mac on 30/05/2023.
//

import SwiftUI
import GoogleMobileAds
import UIKit

//#if DEBUG
//let adUnitID = "ca-app-pub-3940256099942544/4411468910"
//#else
//let adUnitID = "ca-app-pub-5782595411387549/7246551467"
//#endif

//#if DEBUG
//let delay = 60000
//#else
//let delay = 30000
//#endif

 class InterstitialAdLoader: NSObject, ObservableObject , GADFullScreenContentDelegate , ImpressionRevenueAds {
     
     static let shared = InterstitialAdLoader()
    @Published var interstitial: GADInterstitialAd?
 
     private var allowShowInter : Bool = false
 
    private var timeShowPrev : Int = 0
    private var onComplete: ( () -> () )?
     private var loadTime : Int = 0
    override init() {
        super.init()
    //    loadInterstitial()

    }

    func loadInterstitial(){
        if interstitial != nil {
            return
        }
       
        let request = GADRequest()
        loadTime += 1
        print("ADS LOAD INTER")
        GADInterstitialAd.load(withAdUnitID: AdsConfig.interID,
                               request: request,
                               completionHandler: {
            [self] ad, error in
            
            if let _ = error {
                if self.loadTime < 4 {
                    loadInterstitial()
                }
                return
            }
            interstitial = ad
            interstitial?.paidEventHandler = { [weak self] adValue in
            
            let info = self?.interstitial?.responseInfo
                self?.impressionAdsValue(name: "Inter_ads", adValue: adValue, responseInfo: info)

            }
            interstitial?.fullScreenContentDelegate = self
        
        }
        )
    }

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        if onComplete != nil {
            onComplete!()
        }
        loadInterstitial()
    }


    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      
    }


    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        timeShowPrev = Date().currentTimeMillis()
        if onComplete != nil {
            onComplete!()
        }
        interstitial = nil
        onComplete = nil
        loadTime = 0
        loadInterstitial()
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

    func showAd( onCommit: @escaping () -> ()  ){
//        if !allowShowInter {
//            allowShowInter = true
//            timeShowPrev = Date().currentTimeMillis()
//            onCommit()
//            return
//        }
        let delay =  UserDefaults.standard.integer(forKey: "delay_inter") * 1000
        self.onComplete = onCommit
        
        
        //MARK: FOR TEST
//                            if onComplete != nil {
//                                onComplete!()
//                            }
        //MARK: END TEST
        
            if Date().currentTimeMillis() - timeShowPrev > delay {
             
                
                if interstitial != nil {
                    interstitial?.present(fromRootViewController: getRootViewController())
                }else{
                    loadInterstitial()
                    if onComplete != nil {
                        onComplete!()
                    }
                }
            }else{
                if onComplete != nil {
                    onComplete!()
                }
            }





    }


}




extension Date {
    func currentTimeMillis() -> Int {
        return Int(self.timeIntervalSince1970 * 1000)
    }
}



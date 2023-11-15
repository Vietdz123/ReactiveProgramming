//
//  OpenAds.swift
//  WallpaperIOS
//
//  Created by Mac on 26/05/2023.
//

import SwiftUI
import Foundation
import GoogleMobileAds

//
//#if DEBUG
//let openAdsId = "ca-app-pub-3940256099942544/5662855259"
//#else
//let openAdsId = "ca-app-pub-5782595411387549/4564547807"
//#endif

final class OpenAd: NSObject, GADFullScreenContentDelegate {
    var appOpenAd: GADAppOpenAd?
    var loadTime = Date()
   
    private var onComplete: ( (Bool) -> Void )?


    
    func requestAppOpenAd() {
        if appOpenAd != nil {
            return
        }
        print("LOAD_ADS OPEN")
        let request = GADRequest()
        GADAppOpenAd.load(withAdUnitID: AdsConfig.openID,
                          request: request,
                          orientation: UIInterfaceOrientation.portrait,
                          completionHandler: { (appOpenAdIn, _) in
            self.appOpenAd = appOpenAdIn
            self.appOpenAd?.fullScreenContentDelegate = self
            self.loadTime = Date()
           
        })
    }
    
    func tryToPresentAd(onCommit: @escaping (Bool) -> Void ) {
        print("LOAD_ADS tryToPresentAd")
        self.onComplete = onCommit
        if let gOpenAd = self.appOpenAd {
            gOpenAd.present(fromRootViewController: (UIApplication.shared.windows.first?.rootViewController)!)
        } else {
            onCommit(false)
            self.requestAppOpenAd()
        }
    }
    
    
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        if onComplete != nil{
            onComplete!(true)
        }
        appOpenAd = nil
        requestAppOpenAd()
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        appOpenAd = nil
        requestAppOpenAd()
        if onComplete != nil{
            onComplete!(false)
        }
    }

}


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
            if  self.appOpenAd != nil{
                print("LOAD_ADS OPEN has")
            }else{
                print("LOAD_ADS OPEN no")
            }
            
            self.appOpenAd?.fullScreenContentDelegate = self
            self.loadTime = Date()
           
        })
    }
    
    func tryToPresentAd(onCommit: @escaping (Bool) -> Void ) {
        print("LOAD_ADS tryToPresentAd")
        self.onComplete = onCommit
        if let gOpenAd = self.appOpenAd {
            print("LOAD_ADS tryToPresentAd has open")
            gOpenAd.present(fromRootViewController: getRootViewController())
        } else {
            print("Load_ADS openid \(AdsConfig.openID)")
            print("LOAD_ADS tryToPresentAd no open")
            onCommit(false)
            self.requestAppOpenAd()
        }
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
    
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("LOAD_ADS OPEN didFailToPresentFullScreenContentWithError")
        if onComplete != nil{
            onComplete!(true)
        }
        appOpenAd = nil
        requestAppOpenAd()
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("LOAD_ADS OPEN adDidDismissFullScreenContent")
        if onComplete != nil{
            onComplete!(false)
        }
        appOpenAd = nil
        requestAppOpenAd()
    }

}


//
//  ImpressionRevenueAds.swift
//  WallpaperIOS
//
//  Created by Duc on 12/07/2024.
//

import Firebase
import FirebaseRemoteConfig
import FirebaseAnalytics
import SwiftUI
import GoogleMobileAds
import Adjust

protocol ImpressionRevenueAds {
    func impressionAdsValue(name: String, adValue: GADAdValue, responseInfo: GADResponseInfo?)
}

extension ImpressionRevenueAds {
    func impressionAdsValue(name: String, adValue: GADAdValue, responseInfo: GADResponseInfo?) {
        
        print("ImpressionRevenueAds \(name)")
        
        let value = adValue.value
        let currencyCode = adValue.currencyCode
        guard let loadedAdNetworkResponseInfo = responseInfo?.loadedAdNetworkResponseInfo else {
            return
        }
        
      
        
        let adRevenue = ADJAdRevenue(source: ADJAdRevenueSourceAdMob)
        adRevenue?.setRevenue(Double(truncating: value), currency: adValue.currencyCode)
        adRevenue?.setAdRevenueNetwork(loadedAdNetworkResponseInfo.adSourceName ?? ADJAdRevenueSourceAdMob)
        if let adRevenue {
            Adjust.trackAdRevenue(adRevenue)
        }
        
      
        
        
        
    }
}

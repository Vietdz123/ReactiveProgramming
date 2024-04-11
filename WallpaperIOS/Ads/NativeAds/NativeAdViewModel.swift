////
////  NativeAdViewModel.swift
////  TestNativeAd
////
////  Created by LNHung on 18/12/2023.
////
//
//import Foundation
//import GoogleMobileAds
//import UIKit
//
//
//
//final class NativeAdViewModel: NSObject, ObservableObject, GADNativeAdLoaderDelegate {
//    static let shared = NativeAdViewModel()
//    @Published var adLoader: GADAdLoader?
//    @Published var nativeAd: GADNativeAd?
//    @Published var adStatus: AdStatus = .loading
//    private let adUnitID = "ca-app-pub-3940256099942544/3986624511"
//    private var cachedAds: [String: GADNativeAd] = [:]
//
//    
//    private var nativeAdOptions: [GADAdLoaderOptions]? {
//        let mediaOption = GADNativeAdMediaAdLoaderOptions()
//        mediaOption.mediaAspectRatio = .square
//        
//        let adViewOptions = GADNativeAdViewAdOptions()
//        adViewOptions.preferredAdChoicesPosition = .topRightCorner
//        
//        return [mediaOption, adViewOptions]
//    }
//    
//    
//    override init() {
//        super.init()
//        print("DEBUG: .init")
//      
//        fetchNativeAd()
//    }
//    
//    func fetchNativeAd() {
//        adLoader = GADAdLoader(adUnitID: adUnitID, rootViewController: nil, adTypes: [GADAdLoaderAdType.native], options: nativeAdOptions)
//        adLoader?.delegate = self
//        adLoader?.load(GADRequest())
//    }
//    
//    func refreshAd() {
//        adLoader = GADAdLoader(adUnitID: adUnitID, rootViewController: nil, adTypes: [GADAdLoaderAdType.native], options: nativeAdOptions)
//        adLoader?.delegate = self
//        adLoader?.load(GADRequest())
//    }
//    
//    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
//        print("DEBUG: Native AD Success \(nativeAd)")
//        self.nativeAd?.delegate = self
//        adStatus = .success
//
////        if let currentNativeAd = self.nativeAd {
////            if self.isSameNativeAd(currentNativeAd, nativeAd) {
////                self.refreshAd()
////            } else {
//                self.nativeAd = nativeAd
////            }
////        }
//    }
//    
//
//    
//    func isSameNativeAd(_ lhs: GADNativeAd,_ rhs: GADNativeAd) -> Bool {
//        if lhs.headline == rhs.headline &&
//            lhs.advertiser == rhs.advertiser  {
//            print("DEBUG: Check properties same: \(lhs.headline ?? "nul") --- \(rhs.headline ?? "nul") --- \(lhs.advertiser ?? "nul") --- \(rhs.advertiser ?? "nul")")
//            return true
//        }
//        return  false
//    }
//    
//    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
//        print("DEBUG:\(adLoader) failed with error: \(error.localizedDescription)")
//        adStatus = .failure
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            self.refreshAd()
//        }
//       
//    }
//}
//
//extension NativeAdViewModel: GADVideoControllerDelegate {
//  func videoControllerDidEndVideoPlayback(_ videoController: GADVideoController) {
//    print("Video playback has ended.")
//  }
//}
//
//extension NativeAdViewModel: GADNativeAdDelegate {
//  func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
//    print("\(#function) called")
//  }
//
//  func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
//    print("\(#function) called")
//  }
//
//  func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
//    print("\(#function) called")
//  }
//
//  func nativeAdWillDismissScreen(_ nativeAd: GADNativeAd) {
//    print("\(#function) called")
//  }
//
//  func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
//    print("\(#function) called")
//  }
//
//  func nativeAdIsMuted(_ nativeAd: GADNativeAd) {
//    print("\(#function) called")
//  }
//}
//
//extension GADNativeAd {
//    static func isSame(lhs: GADNativeAd, rhs: GADNativeAd) -> Bool {
//        if lhs.headline == rhs.headline &&
//            lhs.advertiser == rhs.advertiser &&
//            lhs.mediaContent == rhs.mediaContent {
//            return true
//        }
//        return  false
//    }
//}

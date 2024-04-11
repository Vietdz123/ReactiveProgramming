////
////  GADNativeMediaViewCustom.swift
////  TestNativeAd
////
////  Created by LNHung on 21/12/2023.
////
//
//import UIKit
//import GoogleMobileAds
//import SwiftUI
//
//struct GADNativeMediaWrapper: UIViewRepresentable {
//    typealias UIViewType = GADNativeMediaViewCustom
//    @Binding var nativeAd: GADNativeAd?
//    var size: CGSize
//    
//    func makeUIView(context: Context) -> GADNativeMediaViewCustom {
//        let view = GADNativeMediaViewCustom(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
//        return view
//    }
//    
//    func updateUIView(_ nativeAdView: GADNativeMediaViewCustom, context: Context) {
//        guard let nativeAd = nativeAd else { return }
//        
//        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
//        if !nativeAd.mediaContent.hasVideoContent {
//            nativeAdView.mediaView?.contentMode = .scaleToFill
//            nativeAdView.mediaView?.clipsToBounds = true
//        }
//    }
//}
//
//class GADNativeMediaViewCustom: GADNativeAdView {
//    @ObservedObject private var nativeAdViewModel = NativeAdViewModel.shared
//    var size: CGSize = .zero
//    let myMediaView = GADMediaView()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.size = frame.size
//        setupViews()
//    }
//    
//    func setupViews() {
//        myMediaView.translatesAutoresizingMaskIntoConstraints = false
//        myMediaView.widthAnchor.constraint(equalToConstant: size.width).isActive = true
//        myMediaView.heightAnchor.constraint(equalToConstant: size.height).isActive = true
//        self.mediaView = myMediaView
//        self.addSubview(myMediaView)
//    }
//    
//    func updateView(nativeAd: GADNativeAd) {
//        myMediaView.removeFromSuperview()
//        myMediaView.translatesAutoresizingMaskIntoConstraints = false
//        myMediaView.widthAnchor.constraint(equalToConstant: size.width).isActive = true
//        myMediaView.heightAnchor.constraint(equalToConstant: size.height).isActive = true
//        self.mediaView = myMediaView
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

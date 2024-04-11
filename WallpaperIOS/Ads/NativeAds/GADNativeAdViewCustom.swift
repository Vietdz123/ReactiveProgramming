////
////  NativeViewCustom.swift
////  TestNativeAd
////
////  Created by LNHung on 19/12/2023.
////
//
//import UIKit
//import GoogleMobileAds
//import SwiftUI
//
//enum NativeAdType {
//    case Banner
//    case Card
//}
//
//struct NativeAdViewCustom: UIViewRepresentable {
//    typealias UIViewType = GADNativeAdViewCustom
//    @Binding var nativeAd: GADNativeAd?
//    var nativeAdType: NativeAdType = .Card
//    
//    func makeUIView(context: Context) -> GADNativeAdViewCustom {
//        
//        let swiftUIViewController = getViewController()
//        
//        let view = GADNativeAdViewCustom(frame: .zero,
//                                         nativeAd: nativeAd,
//                                         view: swiftUIViewController)
//        return view
//    }
//    
//    private func getViewController() -> UIHostingController<AnyView> {
//        if nativeAdType == .Banner {
//            return UIHostingController(rootView: AnyView(NativeAdBannerView(nativeAd: .constant(nativeAd))))
//        } else {
//            return UIHostingController(rootView: AnyView(NativeAdCardView(nativeAd: .constant(nativeAd))))
//        }
//    }
//    
//    func updateUIView(_ nativeAdView: GADNativeAdViewCustom, context: Context) {
//        guard let nativeAd = nativeAd else { return }
//        nativeAdView.nativeAd = nativeAd
//        nativeAdView.updateView(nativeAd: nativeAd)
//    }
//}
//
//class GADNativeAdViewCustom: GADNativeAdView {
//    private var nativeView = UIView()
//    private var gADNativeAd: GADNativeAd?
//    var viewController: UIHostingController<AnyView>?
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//    
//    init(frame: CGRect, nativeAd: GADNativeAd?, view: UIHostingController<AnyView>) {
//        super.init(frame: frame)
//        gADNativeAd = nativeAd
////        self.swiftUIView = swiftUIView
//        self.viewController = view
//        setupViews()
//    }
//    
//    func setupViews() {
//        if let nativeAd = gADNativeAd {
////            nativeView = UIHostingController(rootView: swiftUIView).view ?? UIView()
//            nativeView = viewController?.view ?? UIView()
//            let frameSize = nativeView.intrinsicContentSize
//            nativeView.translatesAutoresizingMaskIntoConstraints = false
//            nativeView.widthAnchor.constraint(equalToConstant: frameSize.width).isActive = true
//            nativeView.heightAnchor.constraint(equalToConstant: frameSize.height).isActive = true
//        }
//        
//        self.advertiserView = nativeView
//        self.addSubview(nativeView)
//    }
//    
//    func updateView(nativeAd: GADNativeAd) {
//        nativeView.removeFromSuperview()
////        nativeView = UIHostingController(rootView: swiftUIView).view ?? UIView()
//        nativeView = viewController?.view ?? UIView()
//        let frameSize = nativeView.intrinsicContentSize
//        nativeView.translatesAutoresizingMaskIntoConstraints = false
//        nativeView.widthAnchor.constraint(equalToConstant: frameSize.width).isActive = true
//        nativeView.heightAnchor.constraint(equalToConstant: frameSize.height).isActive = true
//        
//        self.advertiserView = nativeView
//        self.addSubview(nativeView)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//struct NativeAdViewCustomClone: UIViewRepresentable {
//    typealias UIViewType = GADNativeAdViewCustomClone
//    @Binding var nativeAd: GADNativeAd?
//    var nativeAdType: NativeAdType
//
//    func makeUIView(context: Context) -> GADNativeAdViewCustomClone {
//        let view = GADNativeAdViewCustomClone(frame: .zero, nativeAd: nativeAd, adType: nativeAdType)
//        return view
//    }
//
//    func updateUIView(_ nativeAdView: GADNativeAdViewCustomClone, context: Context) {
//        guard let nativeAd = nativeAd else { return }
//        nativeAdView.nativeAd = nativeAd
//        nativeAdView.updateView(nativeAd: nativeAd)
//    }
//}
//
//class GADNativeAdViewCustomClone: GADNativeAdView {
//    private var swiftUIView = UIView()
//    private var gADNativeAd: GADNativeAd?
//    private var nativeAdType: NativeAdType = .Banner
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//
//    init(frame: CGRect, nativeAd: GADNativeAd?, adType: NativeAdType) {
//        super.init(frame: frame)
//        gADNativeAd = nativeAd
//        nativeAdType = adType
//        setupViews()
//
//    }
//
//    func setupViews() {
//        if let nativeAd = gADNativeAd {
//            switch nativeAdType {
//            case .Banner:
//                swiftUIView = UIHostingController(rootView: NativeAdBannerView(nativeAd: .constant(nativeAd))).view ?? UIView()
//            case .Card:
//                swiftUIView = UIHostingController(rootView: NativeAdCardView(nativeAd: .constant(nativeAd))).view ?? UIView()
//            }
//            swiftUIView.backgroundColor = .clear
//            let frameSize = swiftUIView.intrinsicContentSize
//            swiftUIView.isUserInteractionEnabled = false
//            swiftUIView.translatesAutoresizingMaskIntoConstraints = false
//            swiftUIView.widthAnchor.constraint(equalToConstant: frameSize.width).isActive = true
//            swiftUIView.heightAnchor.constraint(equalToConstant: frameSize.height).isActive = true
//        }
//
//        self.advertiserView = swiftUIView
//        self.addSubview(swiftUIView)
//    }
//
//    func updateView(nativeAd: GADNativeAd) {
//        swiftUIView.removeFromSuperview()
//        switch nativeAdType {
//        case .Banner:
//            swiftUIView = UIHostingController(rootView: NativeAdBannerView(nativeAd: .constant(nativeAd))).view ?? UIView()
//        case .Card:
//            swiftUIView = UIHostingController(rootView: NativeAdCardView(nativeAd: .constant(nativeAd))).view ?? UIView()
//        }
//        swiftUIView.backgroundColor = .clear
//        let frameSize = swiftUIView.intrinsicContentSize
//        swiftUIView.isUserInteractionEnabled = false
//        swiftUIView.translatesAutoresizingMaskIntoConstraints = false
//        swiftUIView.widthAnchor.constraint(equalToConstant: frameSize.width).isActive = true
//        swiftUIView.heightAnchor.constraint(equalToConstant: frameSize.height).isActive = true
//
//        self.advertiserView = swiftUIView
//        self.addSubview(swiftUIView)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//

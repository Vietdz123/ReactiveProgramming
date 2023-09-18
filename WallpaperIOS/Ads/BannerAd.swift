//
//  BannerAd.swift
//  WallpaperIOS
//
//  Created by Mac on 02/08/2023.
//

import SwiftUI
import GoogleMobileAds

#if DEBUG
let adBannerUnitID = "ca-app-pub-3940256099942544/2934735716"
#else
let adBannerUnitID = "ca-app-pub-5782595411387549/9881325801"
#endif

enum AdFormat {
    
    case largeBanner
    case mediumRectangle
    case adaptiveBanner
    
    var adSize: GADAdSize {
        switch self {
        case .largeBanner: return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.size.width)
        case .mediumRectangle: return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.size.width)
        case .adaptiveBanner: return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.size.width)
        }
    }
    
    var size: CGSize {
        adSize.size
    }
}
enum AdStatus {
    
    case loading
    case success
    case failure
}
struct BannerViewController: UIViewControllerRepresentable  {
    
    let adUnitID: String
    let adSize: GADAdSize
    @Binding var adStatus: AdStatus
   
    
    init(adUnitID: String, adSize: GADAdSize, adStatus: Binding<AdStatus>) {

        self.adUnitID = adUnitID
        self.adSize = adSize
        self._adStatus = adStatus
       
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(bannerViewController: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
      
        let viewController = UIViewController()
        let view = GADBannerView(adSize: adSize)
        view.delegate = context.coordinator
        view.adUnitID = adUnitID
        print("LOAD_ BANNER ADS")
        view.rootViewController = viewController
        view.load(GADRequest())
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: adSize.size)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
      
    }
    
    class Coordinator: NSObject, GADBannerViewDelegate {
        
        var bannerViewController: BannerViewController
        
        init(bannerViewController: BannerViewController) {
           
            self.bannerViewController = bannerViewController
        }
      
        
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      
            bannerViewController.adStatus = .success
        }
        
        func bannerView(_ bannerView: GADBannerView, bannerViewDidReceiveAd error: Error) {
       
            bannerViewController.adStatus = .failure
        }
        
        
    }
}

struct BannerAdView: View {
    
    
    let adFormat: AdFormat
    @Binding var adStatus: AdStatus
    
    
    
    var body: some View {
        HStack {
                BannerViewController(adUnitID: adBannerUnitID, adSize: adFormat.adSize, adStatus: $adStatus)
                .frame(width: adFormat.size.width, height: adStatus == .success ?  adFormat.size.height : 0.0  )
        }

          
    }
    
 
    
}


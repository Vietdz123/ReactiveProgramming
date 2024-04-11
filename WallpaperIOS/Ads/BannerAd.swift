//
//  BannerAd.swift
//  WallpaperIOS
//
//  Created by Mac on 02/08/2023.
//

import SwiftUI
import GoogleMobileAds

//#if DEBUG
//let adBannerUnitID = "ca-app-pub-3940256099942544/2934735716"
//#else
//let adBannerUnitID = "ca-app-pub-5782595411387549/9881325801"
//#endif

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
     
        view.adUnitID = self.adUnitID
        print("LOAD_ BANNER ADS")
        view.rootViewController = viewController
     
        
        let request = GADRequest()
                   
        if UserDefaults.standard.bool(forKey: "using_banner_collapsible") {
        print("using_banner_collapsible")
            let extras = GADExtras()
            extras.additionalParameters = ["collapsible" : "bottom"]
            request.register(extras)
        }
        view.load(request)
        
        
        
        viewController.view.addSubview(view)
        view.frame = .init(x: 0, y: 0, width: adSize.size.width, height: adSize.size.height)
        viewController.view.frame = CGRect(origin: .zero, size: adSize.size )
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


struct BannerAdViewMain: View {
    
    // "ca-app-pub-3940256099942544/8388050270"
 
    @Binding var adStatus: AdStatus
    
    var size = UserDefaults.standard.bool(forKey: "using_banner_collapsible") ? GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.size.width - 32) : GADAdSizeBanner
    
    var body: some View {
        HStack {
            BannerViewController(adUnitID: AdsConfig.bannerID, adSize: size, adStatus: $adStatus)
                .frame(width: size.size.width, height: adStatus == .success ? size.size.height : 0.0  )
        }.frame(maxWidth: .infinity, alignment: .center)

          
    }
    
 
    
}

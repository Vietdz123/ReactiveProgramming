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
    let isCollapBanner : Bool
    let adSize: GADAdSize
    static var latestTimeShowCollapse: Double = 0
    @Binding var adStatus: AdStatus
   
    
    init(adUnitID: String, isCollapBanner : Bool ,adSize: GADAdSize, adStatus: Binding<AdStatus>) {

        self.adUnitID = adUnitID
        self.isCollapBanner = isCollapBanner
        self.adSize = adSize
        self._adStatus = adStatus
       
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(bannerViewController: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
      
        let viewController = UIViewController()
        let view = GADBannerView(adSize: adSize)
        let request = GADRequest()
        view.delegate = context.coordinator

        view.adUnitID = self.adUnitID
        if isCollapBanner {
                view.adUnitID = AdsConfig.bannerCollapID
                BannerViewController.latestTimeShowCollapse = Date.now.timeIntervalSince1970
                let extras = GADExtras()
                extras.additionalParameters = ["collapsible" : "bottom"]
                request.register(extras)
            
        }
        print("LOAD_ BANNER ADS")
        view.rootViewController = viewController
     
        
       
                   

        view.load(request)
        
      
        
        viewController.view.addSubview(view)
        view.frame = .init(x: 0, y: 0, width: adSize.size.width, height: adSize.size.height)
        viewController.view.frame = CGRect(origin: .zero, size: adSize.size )
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
      
    }
    
    class Coordinator: NSObject, GADBannerViewDelegate, ImpressionRevenueAds {
        
        var bannerViewController: BannerViewController
        
        init(bannerViewController: BannerViewController) {
           
            self.bannerViewController = bannerViewController
        }
      
        
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            bannerView.paidEventHandler = { [weak self] adValue in
                let info = bannerView.responseInfo
                self?.impressionAdsValue(name: "Banner_ads", adValue: adValue, responseInfo: info)

            }
            bannerViewController.adStatus = .success
        }
        
        func bannerView(_ bannerView: GADBannerView, bannerViewDidReceiveAd error: Error) {
       
            bannerViewController.adStatus = .failure
        }
        
        
    }
}



//MARK: Banner In Home
struct BannerAdHomeView : View {
    @State var adStatus: AdStatus = .loading
    
    var size = AdFormat.adaptiveBanner.adSize
    
    var body: some View {
        ZStack {
         
              
          
                Color(red: 0.08, green: 0.1, blue: 0.09).opacity(0.7)
                VisualEffectView(effect: UIBlurEffect(style: .dark))
            BannerViewController(adUnitID: AdsConfig.bannerCollapID, isCollapBanner: true, adSize: size, adStatus: $adStatus)
                .frame(width: size.size.width, height: size.size.height  )
           
        }.frame(height: size.size.height)

          
    }
    
   
}

//MARK: ForBanner Collapse
struct BannerAdViewMain: View {
    
  
    @Binding var adStatus: AdStatus
    
    var size = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.size.width - 32)
    
    var body: some View {
        HStack {
            BannerViewController(adUnitID: AdsConfig.bannerCollapID, isCollapBanner: true, adSize: size, adStatus: $adStatus)
           
                .frame(width: size.size.width, height: adStatus == .success ? size.size.height : 0.0  )
        }.frame(maxWidth: .infinity, alignment: .center)

          
    }
    
 
    
}


struct BannerAdViewInDetail : View {
    @Binding var adStatus: AdStatus
    
    var size = GADAdSizeBanner
    
    var body: some View {
        HStack {
            BannerViewController(adUnitID: AdsConfig.bannerID, isCollapBanner: false, adSize: size, adStatus: $adStatus)
           
                .frame(width: size.size.width, height: adStatus == .success ? size.size.height : 0.0  )
        }.frame(maxWidth: .infinity, alignment: .center)

    }
}

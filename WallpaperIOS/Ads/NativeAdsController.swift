//
//  NativeAdsController.swift
//  eWidget
//
//  Created by MAC on 26/02/2024.
//

import UIKit
import GoogleMobileAds
import SwiftUI



struct NativeAdsCoordinator: UIViewControllerRepresentable {
    let width: CGFloat
    
    func makeUIViewController(context: Context) -> NativeAdsController {
        return NativeAdsController(width: width)
    }
    
    func updateUIViewController(_ uiViewController: NativeAdsController, context: Context) {
        
    }
    
}


class NativeAdsViewModel: NSObject, GADAdLoaderDelegate, GADNativeAdLoaderDelegate {
    
    static let shared = NativeAdsViewModel()
    let idAds = AdsConfig.nativeID
    var nativeAd: GADNativeAd?
    var completionLoadAds: ((GADNativeAd) -> Void)?
    var nativeAdLoader = GADAdLoader()

    func loadAds() {
        let request = GADRequest()
        request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        nativeAdLoader = GADAdLoader(adUnitID: idAds,
                                     rootViewController: nil,
                                     adTypes: [ .native ],
                                     options: nil)
        
        nativeAdLoader.delegate = self
        nativeAdLoader.load(request)
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            let request = GADRequest()
            request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            self.nativeAdLoader.load(request)
        }
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        print("DEBUG: load native ads success")
        self.nativeAd = nativeAd
        
        completionLoadAds?(nativeAd)
    }

    
    func refetchAds() {
     //   if !MyStore.shared.isPro() {
            let request = GADRequest()
            request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            
            nativeAd = nil
            nativeAdLoader.load(request)
       // }
    }
    
}



class NativeAdsView: GADNativeAdView {
    
    //MARK: - Properties
    lazy var logoAdsImageView: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "AD_Viet"))
        imv.translatesAutoresizingMaskIntoConstraints = false
        return imv
    }()
    
    lazy var iconAdsImageView: UIImageView = {
        let imv = UIImageView()
        imv.layer.cornerRadius = 12
        imv.layer.masksToBounds = true
        imv.translatesAutoresizingMaskIntoConstraints = false
        imv.setDimensions(width: 44, height: 44)
        return imv
    }()
    
    lazy var headerLineLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 1
        lbl.font = UIFont(name: "SVN-Avo-Bold", size: 16)
        lbl.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        return lbl
    }()
    
    lazy var logoAndHeaderlineStackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [logoAdsImageView,
                                                       headerLineLabel])
        stackview.axis = .horizontal
        stackview.spacing = 6
        stackview.alignment = .center
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.clipsToBounds = true
        return stackview
    }()
    
    lazy var advertiserViewLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 1
        lbl.font = UIFont(name: "SVN-Avo-Bold", size: 10)
        lbl.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        return lbl
    }()
    
    lazy var rateStarImageView: UIImageView = {
        let imv = UIImageView()
        return imv
    }()
    
    lazy var logoHeaderlineRateStackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [logoAndHeaderlineStackView,
                                                       rateStarImageView,
                                                       advertiserViewLabel])
        stackview.axis = .vertical
        stackview.spacing = 6
        stackview.alignment = .leading
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.clipsToBounds = true
        return stackview
    }()
    
    lazy var contentStackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [iconAdsImageView,
                                                       logoHeaderlineRateStackView])
        stackview.axis = .horizontal
        stackview.spacing = 12
        stackview.alignment = .top
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.clipsToBounds = true
        return stackview
    }()
    
    
    private lazy var backgroundBtnView: UIView = {
        var view = UIView()
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(red: 0.15, green: 0.696, blue: 1, alpha: 1).cgColor,
            UIColor(red: 0.464, green: 0.371, blue: 1, alpha: 1).cgColor,
            UIColor(red: 0.904, green: 0.2, blue: 0.869, alpha: 1).cgColor
        ]
        layer.locations = [0, 0.52, 1]
        layer.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer.frame = .init(x: 0, y: 0, width: UIScreen.main.bounds.width - 48, height: 48)
        
        view.layer.addSublayer(layer)
        view.layer.cornerRadius = 24
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    lazy var actionButton: UILabel = {
        let btn = UILabel()//UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.textColor = .white
        btn.font = UIFont(name: "SVN-Avobold", size: 20)
        btn.clipsToBounds = true
        btn.textAlignment = .center
        return btn
    }()
    
    //MARK: - View LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func configureUI() {
        backgroundColor = .white.withAlphaComponent(0.01)
        
        self.iconView = self.iconAdsImageView
        self.callToActionView = self.actionButton
        self.headlineView = self.headerLineLabel
        self.starRatingView = self.rateStarImageView
        self.advertiserView = self.advertiserViewLabel

        addSubview(contentStackView)
        addSubview(backgroundBtnView)
        addSubview(actionButton)
        layer.cornerRadius = 16
        
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            backgroundBtnView.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            backgroundBtnView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
            backgroundBtnView.heightAnchor.constraint(equalToConstant: 48),
            backgroundBtnView.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 8),
            
            actionButton.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor, constant: 0),
            actionButton.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor, constant: -0),
            actionButton.heightAnchor.constraint(equalToConstant: 48),
            actionButton.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 8),
        ])

        
    }
    
}

class NativeAdsController: UIViewController , ImpressionRevenueAds {
    
    //MARK: - Properties
    let nativeView = NativeAdsView(frame: .zero)
    let viewModel = NativeAdsViewModel.shared
    let width: CGFloat
    
    //MARK: - View LifeCycle
    init(width: CGFloat) {
        self.width = width
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        loadNativeAds()
    }
    
    deinit {
        print("DEBUG: Native AdsVC deinit")
        viewModel.refetchAds()
    }
    
    //MARK: - Helpers
    private func configureUI() {
        view.addSubview(nativeView)
        nativeView.frame = .init(x: 24, y: 0, width: width - 48, height: 132)
    }
    
    private func loadNativeAds() {
        viewModel.completionLoadAds = { [weak self] nativeAds in
            self?.attachNativeAds(nativeAd: nativeAds)
        }
        
        if let nativeAds = viewModel.nativeAd {
            attachNativeAds(nativeAd: nativeAds)
        }
    }
    
    //MARK: - Selectors
    private func attachNativeAds(nativeAd: GADNativeAd) {
        nativeAd.delegate = self
        nativeView.headerLineLabel.text = nativeAd.headline
        (nativeView.starRatingView as? UIImageView)?.image = imageOfStars(from: nativeAd.starRating)
        nativeView.starRatingView?.isHidden = nativeAd.starRating == nil
        
        nativeView.actionButton.text = nativeAd.callToAction
        nativeView.actionButton.isHidden = nativeAd.callToAction == nil
        nativeView.actionButton.isUserInteractionEnabled = false
        
        nativeView.iconAdsImageView.image = nativeAd.icon?.image
        nativeView.advertiserViewLabel.isHidden = nativeAd.advertiser == nil
        if nativeAd.advertiser == nil {
            nativeView.frame = .init(x: 24, y: 0, width: width - 48, height: 132)
            
        } else {
            nativeView.frame = .init(x: 24, y: 0, width: width - 48 , height: 114)
        }
        
        nativeView.iconAdsImageView.isHidden = nativeAd.icon == nil
        nativeView.advertiserViewLabel.text = nativeAd.advertiser
        
        nativeView.isUserInteractionEnabled = true
        nativeView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                               action: #selector(refetchNativeAds)))
        nativeView.nativeAd = nativeAd
        nativeView.nativeAd?.paidEventHandler = { [weak self] adValue in
            let info = self?.nativeView.nativeAd?.responseInfo
            self?.impressionAdsValue(name: "Native_Ads", adValue: adValue, responseInfo: info)

        }
    }
    
    @objc func refetchNativeAds() {
        
        print("DEBUG: refetch ads")
        viewModel.refetchAds()
    }
    
}

//MARK: - Delegate
extension NativeAdsController: GADNativeAdLoaderDelegate, GADNativeAdDelegate {
    
    func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
      guard let rating = starRating?.doubleValue else {
        return nil
      }
      if rating >= 5 {
        return UIImage(named: "stars_5")
      } else if rating >= 4.5 {
        return UIImage(named: "stars_4_5")
      } else if rating >= 4 {
        return UIImage(named: "stars_4")
      } else if rating >= 3.5 {
        return UIImage(named: "stars_3_5")
      } else {
        return nil
      }
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        

    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("DEBUG: load Ads Failed")
    }
    
    
}

extension NativeAdsController: GADVideoControllerDelegate {
    func videoControllerDidEndVideoPlayback(_: GADVideoController) {
        print("Video playback has ended.")
    }
}



extension UIView {
    
    func setDimensions(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: height),
        ])
    }
}

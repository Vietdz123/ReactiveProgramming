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
    
    
    func makeUIViewController(context: Context) -> NativeAdsController {
        return NativeAdsController()
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
        nativeAdLoader = GADAdLoader(adUnitID: idAds,
                                     rootViewController: nil,
                                     adTypes: [ .native ],
                                     options: nil)
        
        nativeAdLoader.delegate = self
        nativeAdLoader.load(GADRequest())
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.nativeAdLoader.load(GADRequest())
        }
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        print("DEBUG: load native ads success")
        self.nativeAd = nativeAd
        
        completionLoadAds?(nativeAd)
    }

    
    func refetchAds() {
     //   if !MyStore.shared.isPro() {
            nativeAd = nil
            nativeAdLoader.load(GADRequest())
    //    }
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

class NativeAdsView: GADNativeAdView {
    

    
    //MARK: - Properties
    lazy var logoAdsImageView: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "native_ad"))
        imv.translatesAutoresizingMaskIntoConstraints = false
        return imv
    }()
    
    lazy var iconAdsImageView: UIImageView = {
        let imv = UIImageView()
        imv.layer.cornerRadius = 12
        imv.layer.masksToBounds = true
        imv.translatesAutoresizingMaskIntoConstraints = false
        imv.setDimensions(width: 40, height: 40)
        return imv
    }()
    
    lazy var headerLineLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 1
      //  lbl.font = .fontSVNAVoBold(12)
        lbl.font = UIFont(name: "SVN-Avobold", size: 14)
        return lbl
    }()
    
    lazy var rateStarImageView: UIImageView = {
        let imv = UIImageView()
        return imv
    }()
    
    lazy var headerlineRateStackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [headerLineLabel,
                                                       rateStarImageView])
        stackview.axis = .vertical
        stackview.spacing = 8
        stackview.alignment = .leading
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.clipsToBounds = true
        return stackview
    }()
    
    lazy var contentStackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [iconAdsImageView,
                                                       headerlineRateStackView])
        stackview.axis = .horizontal
        stackview.spacing = 20
        stackview.alignment = .center
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.clipsToBounds = true
        return stackview
    }()
    
    private lazy var backgroundViewBtn: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "main")
        view.layer.cornerRadius = 14
        return view
    }()

    lazy var actionButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle("", for: .normal)
//        btn.backgroundColor = UIColor(named: "main")
        btn.layer.cornerRadius = 14
        btn.clipsToBounds = true
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
        backgroundColor = .white.withAlphaComponent(0.2)
        
        self.iconView = self.iconAdsImageView
        self.callToActionView = self.actionButton
        self.headlineView = self.headerLineLabel
        self.starRatingView = self.rateStarImageView
        
        addSubview(logoAdsImageView)
        addSubview(contentStackView)
        addSubview(backgroundViewBtn)
        addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            logoAdsImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            logoAdsImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            logoAdsImageView.widthAnchor.constraint(equalToConstant: 24),
            logoAdsImageView.heightAnchor.constraint(equalToConstant: 16),
            
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            contentStackView.heightAnchor.constraint(equalToConstant: 44),
            contentStackView.trailingAnchor.constraint(equalTo: actionButton.leadingAnchor, constant: -6),
            
            backgroundViewBtn.centerYAnchor.constraint(equalTo: iconAdsImageView.centerYAnchor, constant: 0),
            backgroundViewBtn.heightAnchor.constraint(equalToConstant: 28),
            backgroundViewBtn.widthAnchor.constraint(equalToConstant: 80),
            backgroundViewBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            actionButton.centerYAnchor.constraint(equalTo: iconAdsImageView.centerYAnchor, constant: -2),
            actionButton.heightAnchor.constraint(equalToConstant: 28),
            actionButton.widthAnchor.constraint(equalToConstant: 80),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

        ])
        
        
        
    }
    
}

class NativeAdsController: UIViewController {
    
    //MARK: - Properties
    let nativeView = NativeAdsView(frame: .zero)
    let viewModel = NativeAdsViewModel.shared
    
    //MARK: - View LifeCycle
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
        nativeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nativeView)
        view.backgroundColor = .clear
        NSLayoutConstraint.activate([
            nativeView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            nativeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            nativeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            nativeView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -0)
        ])

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
        (nativeView.starRatingView as? UIImageView)?.image = imageOfStars(
            from: nativeAd.starRating)
        nativeView.starRatingView?.isHidden = nativeAd.starRating == nil
        
        nativeView.actionButton.setTitle(nativeAd.callToAction, for: .normal)
        
        nativeView.actionButton.isUserInteractionEnabled = false
        nativeView.actionButton.titleLabel?.font =  UIFont(name: "SVN-Avobold", size: 14)
        
        nativeView.iconAdsImageView.image = nativeAd.icon?.image
        nativeView.iconAdsImageView.isHidden = nativeAd.icon == nil
        nativeView.nativeAd = nativeAd
        nativeView.isUserInteractionEnabled = true
        nativeView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                               action: #selector(refetchNativeAds)))
        nativeView.backgroundColor = .clear
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


    

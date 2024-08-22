//
//  MyStore.swift
//  WallpaperIOS
//
//  Created by Mac on 15/05/2023.
//

import StoreKit
import Foundation
import SwiftUI
import FirebaseAnalytics
import FirebaseRemoteConfig
import SDWebImageSwiftUI
import SDWebImage


struct IDProduct {
    
    
    static let WEEK_1 = "com.ezt.wl.weekly_1"
    
    static let LIFETIME = "com.ezt.wl.lifetime"
    
    
    static let MONTH = "com.ezt.wl.monthly"
    static let YEAR_1 = "com.ezt.wl.yearly"
    static let YEAR_2 = "com.ezt.wl.yearly_2"
    static let UNLIMITED = "com.ezt.wl.unlimited"
    static let YEARLY_FREE_TRIAL =  "com.ezt.wl.year_6"
    static let MONTHLY_V2 = "com.ezt.wl.month_2"
    static let THREE_MONTH = "com.ezt.wl.3months"
    
    
    //MARK: current sungs
    static let WEEK_FT = "com.ezt.wl.weekft"
    static let WEEK_2 = "com.ezt.wl.weekly_2"
    static let MONTH_1 = "com.ezt.wl.monthly_1"
    static let YEARLY_SALE_50 = "com.ezt.wl.year_3"
    static let YEARLY_ORIGINAL = "com.ezt.wl.year_5"
    static let YEAR_SALE_50_NEW = "com.ezt.wl.year_7"
    static let YEAR_ORIGINAL_NEW = "com.ezt.wl.year_9"
    
    
}

class MyStore: ObservableObject {
    
    static let shared = MyStore()
    
    @Published var purchasedIds: [String] = []
    
    @Published var allProductIdLoad : [String] = [IDProduct.WEEK_2, IDProduct.WEEK_1, IDProduct.WEEK_FT,
                                                  IDProduct.MONTH_1 , IDProduct.MONTH,
                                                  IDProduct.YEARLY_FREE_TRIAL, IDProduct.YEARLY_SALE_50, IDProduct.YEARLY_ORIGINAL ,IDProduct.MONTHLY_V2, IDProduct.THREE_MONTH,
                                                  IDProduct.YEAR_SALE_50_NEW, IDProduct.YEAR_ORIGINAL_NEW,
                                                  IDProduct.YEAR_1, IDProduct.YEAR_2 ,
                                                  IDProduct.UNLIMITED , IDProduct.LIFETIME
                                                  
    ]
    
    @Published var productIdAllowShows : [String] = []
    
    @Published var weekFreeTrialProduct : Product?
    @Published var weekProductNotSale : Product?
    @Published var monthProduct : Product?
    
    @Published var yearlyOriginalProduct : Product?
    @Published var yearlv2Sale50Product :  Product?
    
    @Published var yearlyOriginalNewProduct : Product?
    @Published var yearlv2Sale50NewProduct :  Product?
    
    @Published var lifeTimeProduct : Product?
    
    
    @Published var allowFetcConfigWhenError : Bool = true
    @Published var isPurchasing : Bool = false
    
    var remoteConfig : RemoteConfig
    
    
 

    
    init() {
        print("MYSTORE---init")
        self.remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 1
        self.remoteConfig.configSettings = settings
        self.remoteConfig.setDefaults(fromPlist: "GoogleService-Info")
        self.fetchProducts()
        self.fetchConfig()
        
        
        
    }
    
    func allowShowBanner() -> Bool {
        return  !self.isPro() && UserDefaults.standard.bool(forKey: "allow_show_banner")
    }
    
    func isNewVeriosn() -> Bool {
        return UIApplication.version != UserDefaults.standard.string(forKey: "current_version") ?? ""
    }
    
    func getYearOriginUsingProduct() -> Product?{
        return yearlyOriginalNewProduct
    }
    
    func getYearSale50UsingProduct() -> Product?{
        return yearlv2Sale50NewProduct
    }
    
    
    func fetchConfig() {
        print("MYSTORE---fetchConfig")
        remoteConfig.fetch { (status, error) -> Void in
            
            
            if status == .success {
                print("MYSTORE---fetchConfig-success")
                self.remoteConfig.activate { changed, error in
                    //MARK: using_onb_has_freetrial
                    let usingOnbHasFreetrial = self.remoteConfig.configValue(forKey: "using_onb_has_freetrial").boolValue
                    UserDefaults.standard.set(usingOnbHasFreetrial, forKey: "using_onb_has_freetrial")
                    
                    //MARK: ADS ID
                    let bannerID = self.remoteConfig.configValue(forKey: "id_banner_ads").stringValue ?? AdsConfig.def_bannerID
                    let rewardID = self.remoteConfig.configValue(forKey: "id_reward_ads").stringValue ?? AdsConfig.def_rewardID
                    let interID = self.remoteConfig.configValue(forKey: "id_inter_ads").stringValue ?? AdsConfig.def_interID
                    let openID = self.remoteConfig.configValue(forKey: "id_open_ads").stringValue ?? AdsConfig.def_openID
                    let nativeID = self.remoteConfig.configValue(forKey: "id_native_ads").stringValue ?? AdsConfig.def_nativeID
                 
                    
                    
                    UserDefaults.standard.set(bannerID, forKey: "id_banner_ads")
                    UserDefaults.standard.set(rewardID, forKey: "id_reward_ads")
                    UserDefaults.standard.set(interID, forKey: "id_inter_ads")
                    UserDefaults.standard.set(openID, forKey: "id_open_ads")
                    UserDefaults.standard.set(nativeID, forKey: "id_native_ads")
                  
                    
                    
                    let wl_domain       =  self.remoteConfig.configValue(forKey: "wl_domain").stringValue ?? "http://3.8.138.29/"
                    let reward_delay    = self.remoteConfig.configValue(forKey: "reward_delay").numberValue
                    let inter_delay    = self.remoteConfig.configValue(forKey: "inter_delay").numberValue
                    let allowShowRate   = self.remoteConfig.configValue(forKey: "allow_show_rate").boolValue
                    let allowShowBanner = self.remoteConfig.configValue(forKey: "allow_show_banner").boolValue
                    let allowShowNative = self.remoteConfig.configValue(forKey: "allow_show_native_ads").boolValue
                    let exclusiveCost   = self.remoteConfig.configValue(forKey: "exclusive_cost").numberValue
                    let currentVersion  = self.remoteConfig.configValue(forKey: "current_version").stringValue ?? "1.1.2.1"
                    let liveWlUsingCoin  = self.remoteConfig.configValue(forKey: "live_wl_using_coin").boolValue
                    let showBtnFreeTrialInSubOnb = self.remoteConfig.configValue(forKey: "using_btn_for_freetrial").boolValue
                    
                    
                    let textColor   = self.remoteConfig.configValue(forKey: "textColor").stringValue ?? "000000"
                    let btnTextColor  = self.remoteConfig.configValue(forKey: "btnTextColor").stringValue ?? "000000"
                    let btnBgColor  = self.remoteConfig.configValue(forKey: "btnBgColor").stringValue ?? "ffffff"
                    
                    
                    //MARK: NEWVERSION
                    let is_v1           = self.remoteConfig.configValue(forKey: "is_v1").boolValue
                    let url_image_bg_event = self.remoteConfig.configValue(forKey: "sub_event_bg_image_url").stringValue ?? "https://cdn-wallpaper.eztechglobal.com/upload/images/full/2023/09/25/1695615834_Dkptf.png"
                    let url_image_banner_event = self.remoteConfig.configValue(forKey: "sub_event_banner_image_url").stringValue ?? "https://cdn-wallpaper.eztechglobal.com/upload/images/full/2023/09/25/1695635611_5n8d8.png"
                    let has_event = self.remoteConfig.configValue(forKey: "has_event").boolValue
                    
                    UserDefaults.standard.set(wl_domain,       forKey: "wl_domain")
                    UserDefaults.standard.set(reward_delay,    forKey: "delay_reward")
                    UserDefaults.standard.set(inter_delay,    forKey: "delay_inter")
                    UserDefaults.standard.set(allowShowRate,   forKey: "allow_show_rate")
                    UserDefaults.standard.set(allowShowBanner, forKey: "allow_show_banner")
                    UserDefaults.standard.set(allowShowNative, forKey: "allow_show_native_ads")
                    UserDefaults.standard.set(exclusiveCost,   forKey: "exclusive_cost")
                    UserDefaults.standard.set(currentVersion,  forKey: "current_version")
                    UserDefaults.standard.set(liveWlUsingCoin,  forKey: "remoteCf_live_using_coin")
                    UserDefaults.standard.set(showBtnFreeTrialInSubOnb, forKey: "using_btn_for_freetrial")
                    
                    
                    //MARK NEWVERSION
                    UserDefaults.standard.set(is_v1,  forKey: "is_v1")
                    UserDefaults.standard.set(url_image_bg_event, forKey: "sub_event_bg_image_url")
                    UserDefaults.standard.set(url_image_banner_event, forKey: "sub_event_banner_image_url")
                    UserDefaults.standard.set(has_event, forKey: "has_event")
                    
                    
                    UserDefaults.standard.set(textColor, forKey: "textColor")
                    UserDefaults.standard.set(btnTextColor, forKey: "btnTextColor")
                    UserDefaults.standard.set(btnBgColor, forKey: "btnBgColor")
                    
                    
                    let allowDownloadContentFree = self.remoteConfig.configValue(forKey: "allow_download_free").boolValue
                    UserDefaults.standard.set(allowDownloadContentFree, forKey: "allow_download_free")
                    
                    
                    SDWebImageManager.shared.loadImage(with: URL(string: url_image_bg_event), progress: nil, completed: {
                        _, _, _, _, _, _ in
                        print("Remote Config preload url_image_bg_event")
                        
                    })
                    
                    SDWebImageManager.shared.loadImage(with: URL(string: url_image_banner_event), progress: nil, completed: {
                        _, _, _, _, _, _ in
                        print("Remote Config preload url_image_banner_event")
                        
                    })
                    
                    
                    
                }
                
                
            } else {
                print("MYSTORE---fetchConfig-failure")
                if self.allowFetcConfigWhenError {
                    self.allowFetcConfigWhenError = false
                    self.fetchConfig()
                }
                
            }
            
        }
        
    }
    
  
    func isHasEvent() -> Bool{
        return UserDefaults.standard.bool(forKey:  "has_event")
    }
    

    func isPro() -> Bool {
        return !purchasedIds.isEmpty
        
    }
    
    func fetchProducts() {
        
        print("MYSTORE--- fetchProducts")
        
        Task {
            do {
                let products = try await Product.products(for: allProductIdLoad )
                
                print("MYSTORE \(products.count)")
                
                DispatchQueue.main.async {
                    for productttt in products {
                        let productId = productttt.id
                        
                        switch productId {
                        case IDProduct.WEEK_FT :
                            self.weekFreeTrialProduct = productttt
                            break
                        case IDProduct.WEEK_2 :
                            self.weekProductNotSale = productttt
                            break
                        case IDProduct.MONTH_1 :
                            self.monthProduct = productttt
                            break
                        case IDProduct.YEARLY_ORIGINAL:
                            self.yearlyOriginalProduct = productttt
                            break
                        case IDProduct.YEARLY_SALE_50:
                            self.yearlv2Sale50Product = productttt
                            break
                            
                        case IDProduct.YEAR_ORIGINAL_NEW:
                            self.yearlyOriginalNewProduct = productttt
                            break
                        case IDProduct.YEAR_SALE_50_NEW:
                            self.yearlv2Sale50NewProduct = productttt
                            break
                        case IDProduct.LIFETIME:
                            self.lifeTimeProduct = productttt
                            break
                            
                        default:
                            break
                        }
                        
                        
                        Task{
                            await self.isPurchased(product: productttt)
                        }
                        
                    }
                    
                }
                
                
            } catch {
                print("Error \(error)")
            }
        }
    }
    
    
    
    func isPurchased(product: Product) async {
        guard let state = await product.currentEntitlement else { return }
        switch state {
        case .verified(let transaction):
            DispatchQueue.main.async {
                self.purchasedIds.append(transaction.productID)
                print("Product purchase \(transaction.productID)")
            }
            
        case .unverified(_, _):
            break
        }
    }
    
    
    func Firebase_log( _ event : String) {
        if isDebug {
            print("Firebaselog event: \(event) ")
        }else{
            Analytics.logEvent(event, parameters: nil)
        }
    }
    
    
    
    
    func purchase(product : Product, onBuySuccess : @escaping  (Bool) -> () ) {
        Task {
            do {
                let result = try await product.purchase()
                switch result {
                case .success(let verification):
                    switch verification {
                    case .verified(let trans):
                        DispatchQueue.main.async {
                            switch trans.productID {
                            case IDProduct.WEEK_FT:
                                self.purchasedIds.append(trans.productID)
                                self.Firebase_log("Sub_buy_successful_1_weekly_freetrial")
                                onBuySuccess(true)
                                break
                            case IDProduct.WEEK_2:
                                self.purchasedIds.append(trans.productID)
                                self.Firebase_log("Sub_buy_successful_1_weekly(2)")
                                onBuySuccess(true)
                                break
                            case IDProduct.MONTH_1:
                                self.purchasedIds.append(trans.productID)
                                self.Firebase_log("Sub_buy_successful_1_monthly(1)")
                                onBuySuccess(true)
                                break
                            case IDProduct.YEARLY_ORIGINAL:
                                self.purchasedIds.append(trans.productID)
                                onBuySuccess(true)
                                break
                            case IDProduct.YEARLY_SALE_50:
                                self.purchasedIds.append(trans.productID)
                                onBuySuccess(true)
                                break
                            case IDProduct.YEAR_ORIGINAL_NEW:
                                self.purchasedIds.append(trans.productID)
                                onBuySuccess(true)
                                break
                            case IDProduct.YEAR_SALE_50_NEW:
                                self.purchasedIds.append(trans.productID)
                                onBuySuccess(true)
                                break
                            case IDProduct.LIFETIME:
                                self.purchasedIds.append(trans.productID)
                                self.Firebase_log("Sub_buy_successful_lifetime")
                                onBuySuccess(true)
                                break
                            default:
                                print("no_data")
                                break
                            }
                        }
                        
                    case .unverified(_, _):
                        self.Firebase_log("Sub_buy_failure_unverified")
                        onBuySuccess(false)
                        break
                    }
                case .userCancelled:
                    self.Firebase_log("Sub_buy_failure_userCancelled")
                    onBuySuccess(false)
                    break
                case .pending:
                    self.Firebase_log("Sub_buy_failure_pending")
                    onBuySuccess(false)
                    break
                @unknown default:
                    self.Firebase_log("Sub_buy_failure_unknow")
                    onBuySuccess(false)
                    break
                }
            } catch {
                self.Firebase_log("Sub_buy_failure_\(error.localizedDescription)")
                onBuySuccess(false)
            }
        }
    }
    
    func restore() async -> Bool {
        return ((try? await AppStore.sync()) != nil)
    }
    
    func setExpirationDate(str : String) {
        return UserDefaults.standard.set(str, forKey: "buypro.ExpirationDate")
    }
    
    func getExpirationDate() -> String {
        return UserDefaults.standard.string(forKey: "buypro.ExpirationDate") ?? "01/01/2023"
    }
    
    
}


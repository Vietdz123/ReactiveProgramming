//
//  MyStore.swift
//  WallpaperIOS
//
//  Created by Mac on 15/05/2023.
//

import StoreKit
import Foundation
import SwiftUI
//import Flurry_iOS_SDK
import FirebaseAnalytics
import FirebaseRemoteConfig

struct IDProduct {
    static let WEEK_2 = "com.ezt.wl.weekly_2"
    
    static let WEEK_1 = "com.ezt.wl.weekly_1"
    static let MONTH_1 = "com.ezt.wl.monthly_1"
    
    
    
    static let MONTH = "com.ezt.wl.monthly"
    static let YEAR_1 = "com.ezt.wl.yearly"
    static let YEAR_2 = "com.ezt.wl.yearly_2"
    static let UNLIMITED = "com.ezt.wl.unlimited"
    
    
    static let COIN_1 = "com.ezt.wl.coinpack1"
    static let COIN_2 = "com.ezt.wl.coinpack2"
    static let COIN_3 = "com.ezt.wl.coinpack3"
}

class MyStore: ObservableObject {

    @Published var showBanner : Bool = true

    @Published var purchasedIds: [String] = []

    @Published var allProductIdLoad : [String] = [IDProduct.WEEK_2, IDProduct.WEEK_1,
                                                  IDProduct.MONTH_1 , IDProduct.MONTH,
                                                  IDProduct.YEAR_1, IDProduct.YEAR_2 ,
                                                  IDProduct.UNLIMITED ,
                                                  IDProduct.COIN_1 , IDProduct.COIN_2  ,IDProduct.COIN_3 ]

    @Published var productIdAllowShows : [String] = []


    @Published var weekProductNotSale : Product?
    
    @Published var weekProduct :  Product?
    @Published var monthProduct : Product?
   
    @Published var coin_product_1 : Product?
    @Published var coin_product_2 : Product?
    @Published var coin_product_3 : Product?
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
        return self.showBanner &&  !self.isPro() && UserDefaults.standard.bool(forKey: "allow_show_banner")
    }

    func isNewVeriosn() -> Bool {

        return UIApplication.version != UserDefaults.standard.string(forKey: "current_version") ?? ""
    }


    func fetchMonthProductForFirsttime() {
        print("MYSTORE---fetchMonthProductForFirsttime")

        if UserDefaults.standard.bool(forKey: "fetchMonthProductForFirsttime") == false {
            UserDefaults.standard.set(true, forKey: "fetchMonthProductForFirsttime")
        }else{
            return
        }

        Task {
            do {
                let products = try await Product.products(for: allProductIdLoad )
                DispatchQueue.main.async {
                    if let productM = products.first {
                        self.monthProduct = productM
                        print("MYSTORE---fetchMonthProductForFirsttime_success")
                    }
                }
            }
        }
    }

    func fetchConfig() {
        print("MYSTORE---fetchConfig")
        remoteConfig.fetch { (status, error) -> Void in


            if status == .success {
                print("MYSTORE---fetchConfig-success")
                self.remoteConfig.activate { changed, error in
                    let productsJsonStr = self.remoteConfig.configValue(forKey: "products").stringValue ?? "[\"com.ezt.wl.monthly\", \"com.ezt.wl.yearly\"]"
                //    self.getProductsIdFromRemote(productJsonStr: productsJsonStr)
                    let coin_costs = self.remoteConfig.configValue(forKey: "coin_costs").stringValue ?? "[20, 50, 150]"
                    self.extractCoinCost(coin_cost:  coin_costs)



                    let wl_domain       =  self.remoteConfig.configValue(forKey: "wl_domain").stringValue ?? "http://3.8.138.29/"
                    let reward_delay    = self.remoteConfig.configValue(forKey: "reward_delay").numberValue
                    let allowShowRate   = self.remoteConfig.configValue(forKey: "allow_show_rate").boolValue
                    let allowShowBanner = self.remoteConfig.configValue(forKey: "allow_show_banner").boolValue
                    let exclusiveCost   = self.remoteConfig.configValue(forKey: "exclusive_cost").numberValue
                    let currentVersion  = self.remoteConfig.configValue(forKey: "current_version").stringValue ?? "1.1.2.1"
                    
                    let liveWlUsingCoin  = self.remoteConfig.configValue(forKey: "live_wl_using_coin").boolValue


                    UserDefaults.standard.set(wl_domain,       forKey: "wl_domain")
                    UserDefaults.standard.set(reward_delay,    forKey: "delay_reward")
                    UserDefaults.standard.set(allowShowRate,   forKey: "allow_show_rate")
                    UserDefaults.standard.set(allowShowBanner, forKey: "allow_show_banner")
                    UserDefaults.standard.set(exclusiveCost,   forKey: "exclusive_cost")
                    UserDefaults.standard.set(currentVersion,  forKey: "current_version")
                    UserDefaults.standard.set(liveWlUsingCoin,  forKey: "remoteCf_live_using_coin")


                }


            } else {
                print("MYSTORE---fetchConfig-failure")

                if self.allowFetcConfigWhenError {
                    self.allowFetcConfigWhenError = false

                    self.fetchConfig()

                }else {
                    self.getProductsIdFromRemote(productJsonStr: "[\"com.ezt.wl.monthly\", \"com.ezt.wl.yearly\"]")
                }

            }

        }

    }


    func getProductsIdFromRemote(productJsonStr : String){

       

        let data = Data(productJsonStr.utf8)
        do {
            if let products = try JSONSerialization.jsonObject(with: data, options: []) as? [String] {
                DispatchQueue.main.async {


                    self.productIdAllowShows = products
                    self.fetchProducts()
                }

            }
        } catch _ as NSError {
            self.productIdAllowShows = ["com.ezt.wl.monthly","com.ezt.wl.yearly"]
            self.fetchProducts()
        }
    }

    func extractCoinCost(coin_cost : String){
        let data = Data(coin_cost.utf8)
        do {
            if let coinCosts = try JSONSerialization.jsonObject(with: data, options: []) as? [Int] {
                if coinCosts.count == 3 {
                    UserDefaults.standard.set(coinCosts[0], forKey: "pack_1_coin")
                    UserDefaults.standard.set(coinCosts[1], forKey: "pack_2_coin")
                    UserDefaults.standard.set(coinCosts[2], forKey: "pack_3_coin")
                }



            }
        } catch _ as NSError {
            UserDefaults.standard.set(20, forKey: "pack_1_coin")
            UserDefaults.standard.set(50, forKey: "pack_2_coin")
            UserDefaults.standard.set(150, forKey: "pack_3_coin")
        }
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
                        case IDProduct.WEEK_2 :
                            self.weekProductNotSale = productttt
                        case IDProduct.WEEK_1 :
                            self.weekProduct = productttt
                        case IDProduct.MONTH_1 :
                            self.monthProduct = productttt
                        case IDProduct.COIN_1:
                            self.coin_product_1 = productttt
                        case IDProduct.COIN_2:
                            self.coin_product_2 = productttt
                        case IDProduct.COIN_3:
                            self.coin_product_3 = productttt
                        default:
                            print("no_data")
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

    func Flurry_log(_ event : String) {
        if isDebug{
            print("Flurry log event: \(event)")
        }
//        else{
//            Flurry.log(eventName: event)
//        }

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
                            case IDProduct.WEEK_2:
                                self.purchasedIds.append(trans.productID)
                                self.Flurry_log("Sub_buy_successful_1_weekly(2)")
                                self.Firebase_log("Sub_buy_successful_1_weekly(2)")
                                onBuySuccess(true)
                            case IDProduct.WEEK_1:
                                self.purchasedIds.append(trans.productID)
                                self.Flurry_log("Sub_buy_successful_1_weekly(1)")
                                self.Firebase_log("Sub_buy_successful_1_weekly(1)")
                                onBuySuccess(true)
                            case IDProduct.MONTH_1:
                                self.purchasedIds.append(trans.productID)
                                self.Flurry_log("Sub_buy_successful_1_monthly(1)")
                                self.Firebase_log("Sub_buy_successful_1_monthly(1)")
                                onBuySuccess(true)
                            
                            case IDProduct.COIN_1:
                                let currentCoin = UserDefaults.standard.integer(forKey: "current_coin")
                                UserDefaults.standard.set(currentCoin + UserDefaults.standard.integer(forKey: "pack_1_coin"), forKey: "current_coin")
                                self.Flurry_log("Sub_buy_successful_coin_pack_1")
                                self.Firebase_log("Sub_buy_successful_coin_pack_1")
                                onBuySuccess(true)
                            case IDProduct.COIN_2:
                                let currentCoin = UserDefaults.standard.integer(forKey: "current_coin")
                                UserDefaults.standard.set(currentCoin + UserDefaults.standard.integer(forKey: "pack_2_coin"), forKey: "current_coin")
                                self.Flurry_log("Sub_buy_successful_coin_pack_2")
                                self.Firebase_log("Sub_buy_successful_coin_pack_2")
                                onBuySuccess(true)
                            case IDProduct.COIN_3:
                                let currentCoin = UserDefaults.standard.integer(forKey: "current_coin")
                                UserDefaults.standard.set(currentCoin + UserDefaults.standard.integer(forKey: "pack_3_coin"), forKey: "current_coin")
                                self.Flurry_log("Sub_buy_successful_coin_pack_3")
                                self.Firebase_log("Sub_buy_successful_coin_pack_3")
                                onBuySuccess(true)


                            default:
                                print("no_data")
                            }



                        }

                    case .unverified(_, _):
                        self.Flurry_log("Sub_buy_failure_unverified")
                        self.Firebase_log("Sub_buy_failure_unverified")
                        onBuySuccess(false)
                    }
                case .userCancelled:
                    self.Flurry_log("Sub_buy_failure_userCancelled")
                    self.Firebase_log("Sub_buy_failure_userCancelled")
                    onBuySuccess(false)
                    break
                case .pending:
                    self.Flurry_log("Sub_buy_failure_pending")
                    self.Firebase_log("Sub_buy_failure_pending")
                    onBuySuccess(false)
                    break
                @unknown default:
                    self.Flurry_log("Sub_buy_failure_unknow")
                    self.Firebase_log("Sub_buy_failure_unknow")
                    onBuySuccess(false)
                    break
                }
            } catch {
                self.Flurry_log("Sub_buy_failure_\(error.localizedDescription)")
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


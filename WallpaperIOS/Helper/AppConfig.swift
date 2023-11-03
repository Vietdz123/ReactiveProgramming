//
//  AppConfig.swift
//  WallpaperIOS
//
//  Created by Mac on 05/05/2023.
//

import SwiftUI
import StoreKit

struct AppConfig {
    static let APP_NAME : String = "Wallive"
    static let limit : Int = 15
    static let forOnlyIOS = "&mobile_app_id=2&app=2"
    
    static let imgWidth : CGFloat = ( UIScreen.main.bounds.width - 48 ) / 3

    static let imgHeight : CGFloat = ( UIScreen.main.bounds.width - 40 ) * 2 / 3
    
    
    static let width_1 : CGFloat = (UIScreen.main.bounds.width - 40) / 2
    static let height_1 : CGFloat = (UIScreen.main.bounds.width - 40) 
    
    static let width_2 : CGFloat = (UIScreen.main.bounds.width - 40) - ( (UIScreen.main.bounds.width - 48) / 3 )
    static let height_2 : CGFloat = (UIScreen.main.bounds.width - 48)  * 32 / 27 + 8
    
   

   
    static func getDateInstall() -> String{
        return UserDefaults.standard.string(forKey: "date_install") ?? ""
    }
 
}

extension View{
    func showRateView(){
        let allowShowRate : Bool = UserDefaults.standard.bool(forKey: "allow_show_rate")
        let saveDateShowRate = UserDefaults.standard.string(forKey: "showrate_date") ?? ""
        if saveDateShowRate != Date().toString(format: "dd/MM/yyyy") {
            UserDefaults.standard.set(Date().toString(format: "dd/MM/yyyy"), forKey: "showrate_date")
            if allowShowRate && Date().toString(format: "dd/MM/yyyy") != AppConfig.getDateInstall() {
                SKStoreReviewController.requestReview()
            }
        }
    }
}

//extension String{
//    func localizable() -> String
//    {
//        return NSLocalizedString("splash_text", comment: "")
//    }
//}


extension UIApplication {
    static var release: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String? ?? "x.x"
    }
    static var build: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String? ?? "x"
    }
    static var version: String {
        return "\(release).\(build)"
    }
}

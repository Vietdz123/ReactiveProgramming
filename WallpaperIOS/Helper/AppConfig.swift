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
    static let APP_IN_STORE_ID : String = "6449699978"
    
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
   
    func showActionAfterDownload(isUserPro : Bool,
                                 onShowRate:@escaping () -> (),
                                 onShowGifView: @escaping () -> ()   ){
        //MARK: set download count +1
        let downloadCount = UserDefaults.standard.integer(forKey: "download_count_all")
        UserDefaults.standard.set(downloadCount + 1, forKey: "download_count_all")
        let allowShow : Bool = (UserDefaults.standard.bool(forKey: "user_click_button_submit_in_rateview") == false )
        if isUserPro {
            if allowShow {
                onShowRate()
            }
        }else{
            if downloadCount % 2 == 0 {
                onShowGifView()
            }else{
                if allowShow {
                    onShowRate()
                }else{
                    onShowGifView()
                }
            }
        }
        
        
    }
    
    func rateApp() {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/id\(AppConfig.APP_IN_STORE_ID)?mt=8&action=write-review") else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
}




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

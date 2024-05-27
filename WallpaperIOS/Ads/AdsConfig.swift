//
//  AdsConfig.swift
//  WallpaperIOS
//
//  Created by Duc on 15/11/2023.
//

import Foundation

#if DEBUG
let m_debug = true
#else
let m_debug = false
#endif


struct AdsConfig {
   
    //for testing
    static let test_bannerID = "ca-app-pub-3940256099942544/2934735716"
    static let test_bannerCollapID = "ca-app-pub-3940256099942544/8388050270"
    static let test_interID = "ca-app-pub-3940256099942544/4411468910"
    static let test_rewardID = "ca-app-pub-3940256099942544/1712485313"
    static let test_openID = "ca-app-pub-3940256099942544/5575463023"
    static let test_nativeID = "ca-app-pub-3940256099942544/3986624511"
    
    //for production
    static let def_bannerID = "ca-app-pub-5782595411387549/9881325801"
    static let def_banner_collapID = "ca-app-pub-5782595411387549/7255779031"
    static let def_interID = "ca-app-pub-5782595411387549/724655O1467"
    static let def_rewardID = "ca-app-pub-5782595411387549/3315917452"
    static let def_openID = "ca-app-pub-5782595411387549/4564547807"
    static let def_nativeID = "ca-app-pub-5782595411387549/2002835788"
    
    
    static let bannerID = m_debug ? test_bannerID : UserDefaults.standard.string(forKey: "id_banner_ads") ?? def_bannerID
    static let bannerCollapID = m_debug ? test_bannerCollapID : def_banner_collapID
    static let openID = m_debug ? test_openID : UserDefaults.standard.string( forKey: "id_open_ads") ?? def_openID
    static let rewardID = m_debug ? test_rewardID : UserDefaults.standard.string(forKey: "id_reward_ads") ?? def_rewardID
    static let interID = m_debug ? test_interID : UserDefaults.standard.string(forKey: "id_inter_ads") ?? def_interID
    static let nativeID = m_debug ? test_nativeID : UserDefaults.standard.string(forKey: "id_native_ads") ?? def_nativeID
    
}







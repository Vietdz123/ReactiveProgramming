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
    static let test_interID = "ca-app-pub-3940256099942544/4411468910"
    static let test_rewardID = "ca-app-pub-3940256099942544/1712485313"
    static let test_openID = "ca-app-pub-3940256099942544/5662855259"
    
    
    //for production
    static let def_bannerID = "ca-app-pub-5782595411387549/9881325801"
    static let def_interID = "ca-app-pub-5782595411387549/7246551467"
    static let def_rewardID = "ca-app-pub-5782595411387549/3315917452"
    static let def_openID = "ca-app-pub-5782595411387549/4564547807"
    
    
    static let bannerID = m_debug ? test_bannerID : UserDefaults.standard.string(forKey: "id_banner_ads") ?? def_bannerID
    static let openID = m_debug ? test_openID : UserDefaults.standard.string( forKey: "id_open_ads") ?? def_openID
    static let rewardID = m_debug ? test_rewardID : UserDefaults.standard.string(forKey: "id_reward_ads") ?? def_rewardID
    static let interID = m_debug ? test_interID : UserDefaults.standard.string(forKey: "id_inter_ads") ?? def_interID
    
}







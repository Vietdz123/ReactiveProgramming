//
//  FlurryHelper.swift
//  WallpaperIOS
//
//  Created by Mac on 05/06/2023.
//

import SwiftUI
//import Flurry_iOS_SDK
import FirebaseAnalytics
#if DEBUG
    let isDebug = true
#else
    let isDebug = false
#endif

extension View{
    func Flurry_log(_ event : String) {
        if isDebug {
            print("Flurry log event: \(event) ")
        }
    }
    
   
    
    func Firebase_log( _ event : String) {
        if isDebug {
            print("Firebaselog event: \(event) ")
        }else{
            Analytics.logEvent(event, parameters: nil)
        }
    }
}

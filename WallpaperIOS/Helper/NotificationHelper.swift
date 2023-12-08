//
//  NotificationHelper.swift
//  WallpaperIOS
//
//  Created by Duc on 08/12/2023.
//

import SwiftUI
import UserNotifications




class NotificationHelper {
    
    static let share = NotificationHelper()
    
    private let notificationCenter = UNUserNotificationCenter.current()


    
    func requestNotificationPermission(onComplete : @escaping (Bool) -> () ) {
        print("NotificationHelper requestNotificationPermission")
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                onComplete(true)
            } else {
                onComplete(false)
            }
        }
    }
    
  
    
 
}

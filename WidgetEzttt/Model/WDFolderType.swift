//
//  WDFolderType.swift
//  WallpaperIOS
//
//  Created by Duc on 26/10/2023.
//

import Foundation


enum FamilyFolderType: String, CaseIterable {
    
    case square = "square"
    case rectangle = "rectangle"
    case check = "check"
    case uncheck = "uncheck"
    
    static func getType(name: String) -> FamilyFolderType {
        
        for type in FamilyFolderType.allCases {
            if type.rawValue == name {
                return type
            }
        }
        
        return .square
        
    }
}

enum WDFolderType: String, CaseIterable {
    
    case digitalFriend = "Digital Friend"
    case routineMonitor = "Routine Monitor"
    case placeholder = "placeholder"
    
    var nameId: String {
        return self.rawValue
    }
    
    static func getType(name: String) -> WDFolderType {
        
        for folderType in WDFolderType.allCases {
            if folderType.nameId == name {
                return folderType
            }
        }
        
        return .digitalFriend
        
    }
}

enum RoutinMonitorType: String, CaseIterable {
    
    case random = "routine_monitor_random"
    case single = "routine_monitor_single"
    case daily = "routine_monitor_daily"
    
    var nameId: String {
        return self.rawValue
    }
    
    static func getType(name: String) -> RoutinMonitorType {
        
        for folderType in RoutinMonitorType.allCases {
            if folderType.nameId == name {
                return folderType
            }
        }
        
        return .single
        
    }
    
}

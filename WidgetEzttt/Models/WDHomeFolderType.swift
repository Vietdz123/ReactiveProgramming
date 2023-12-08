//
//  WDFolderType.swift
//  WallPaper
//
//  Created by MAC on 23/10/2023.
//

import Foundation

enum FamilyHome: String, CaseIterable {
    
    case square = "square"
    case rectangle = "rectangle"
    case check = "check"
    case uncheck = "uncheck"
    case singleSound = "single_sound"
    case multiSound = "multi_sound"
    
    static func getType(name: String) -> FamilyHome {
        
        for type in FamilyHome.allCases {
            if type.rawValue == name {
                return type
            }
        }
        
        return .square
        
    }
}

enum WDHomeFolderType: String, CaseIterable {
    
    case digitalFriend = "Digital Friend"
    case routineMonitor = "Routine Monitor"
    case sound = "Sounds"
    case gif = "Gif"
    case makeDecision = "Decision Maker"
    case placeholder = "placeholder"
   
    
    var nameId: String {
        return self.rawValue
    }
    
    static func getType(name: String) -> WDHomeFolderType {
        
        for folderType in WDHomeFolderType.allCases {
            if folderType.nameId == name {
                return folderType
            }
        }
        
        return .placeholder
        
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

enum DigitalFriendType: CaseIterable, Equatable {
    static var allCases: [DigitalFriendType] = [.changeBackground, .delayActive(true)]
    
    
    case changeBackground
    case delayActive(Bool)
    
    var nameId: String {
        switch self {
        case .changeBackground:
            return "digital_friend_change_background"
        case .delayActive:
            return "digital_friend_delay_active"
        }
    }
    
    static func getType(name: String) -> DigitalFriendType {
        
        for type in DigitalFriendType.allCases {
            if type.nameId == name {
                return type
            }
        }
        
        return .changeBackground
        
    }
    
}



enum SoundType: String, CaseIterable {
    
    case circle = "sound_circle"
    case makeDesicion = "sound_make_decision"
    
    var nameId: String {
        return self.rawValue
    }
    
    static func getType(name: String) -> SoundType {
        
        for folderType in SoundType.allCases {
            if folderType.nameId == name {
                return folderType
            }
        }
        
        return .circle
        
    }
    
}


enum FamilyLock: Int, CaseIterable {
    
    case rectangle = 1
    case square = 2
    case inline = 3
    
    var name: String {
        switch self {
        case .square:
            return "square"
        case .rectangle:
            return "rectangle"
        case .inline:
            return "inline"
        }
    }
    
    static func getType(name: String) -> FamilyLock {
        
        for type in FamilyLock.allCases {
            if type.name == name {
                return type
            }
        }
        
        return .square
        
    }
}

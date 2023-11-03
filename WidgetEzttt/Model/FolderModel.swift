//
//  FolderModel.swift
//  WallpaperIOS
//
//  Created by Duc on 26/10/2023.
//

import Foundation
import SwiftUI

struct WDConstant {
    static let groupConstant = "group.ezt.wallive"
    static let keyPlaceHolder = "choose"
    static let folderButtonChecklistName = "FolderButtonChecklist"
}

struct AssetConstant {
    static let imagePlacehodel = "placeHodel"
    static let logo = "logo"
    static let unchecklistButton = "m1"
    static let checklistButton = "m2"
}



struct FolderModel {
    
    var name: String        //HasID
    var suggestedName: String  //noID
    var type: WDFolderType

    
}


enum WeekendDay: Int, CaseIterable {
    case sunday  = 0
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
        
    var nameDay: String {
        switch self {
        case .monday:
            return "Mon"
        case .tuesday:
            return "Tues"
        case .wednesday:
            return "Wed"
        case .thursday:
            return "Thur"
        case .friday:
            return "Fri"
        case .saturday:
            return "Sat"
        case .sunday:
            return "Sun"
        }
    }
}

struct WeekendDayModel {
    
    var day: WeekendDay
    var isChecked = false
    var index : Int = 0
    
}

struct ButtonCheckListModel {
    
    var checkImage: [UIImage] = []
    var uncheckImage: [UIImage] = []
    
}

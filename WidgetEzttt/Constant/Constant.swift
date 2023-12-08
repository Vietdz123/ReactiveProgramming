//
//  Constant.swift
//  WidgetEztttExtension
//
//  Created by Duc on 30/11/2023.
//

import SwiftUI


struct WDConstant {
    static let groupConstant = "group.ezt.wallive"
    static let keyPlaceHolder = "choose"
    static let folderButtonChecklistName = "FolderButtonChecklist"
    
    static var containerURL: URL {
        return FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: WDConstant.groupConstant)!
    }
}

struct AssetConstant {
    static let imagePlacehodel = "placeHodel"
    static let logo = "logo"
    static let unchecklistButton = "m1"
    static let checklistButton = "m2"
}


//
//  Enum.swift
//  WallpaperIOS
//
//  Created by Mac on 25/04/2023.
//

import SwiftUI

enum NewTab : String, CaseIterable{
    case HOME = "HOME"
    case SPECIAL = "SPECIAL"
    case EXPLORE = "EXPLORE"
    case VIDEO = "LIVE"
    case AI_ART = "EXCLUSIVE"
    
    
}


enum Sorted : String, CaseIterable {
    case Newest = "NEWEST"
    case Popular = "MOST POPULAR"
    case Downloaded = "MOST DOWNLOADED"
    case Favorite = "MOST FAVORITE"
}

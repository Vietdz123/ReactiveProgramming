//
//  SquareBackgroundView.swift
//  Wallpaper-WidgetExtension
//
//  Created by MAC on 24/11/2023.
//


import SwiftUI
import WidgetKit
import AppIntents
import AVFoundation


struct LockInlineWidgetView: View {
    
    var entry: InlineEntry
    
    var category: CategoryLock? {
        return entry.imgSrc.getCategory()
    }
    
    var title: String {
        entry.title
    }
    
    var fontName: String {
        category?.fontName ?? ""
    }
    
    var fontSize: CGFloat {
        CGFloat(category?.fontSize ?? 20)
    }
    
    var body: some View {
        Text(title)
    }
    

}



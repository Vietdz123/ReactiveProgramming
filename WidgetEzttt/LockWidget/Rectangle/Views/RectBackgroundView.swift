//
//  RectBackgroundView.swift
//  WallPaper-CoreData
//
//  Created by MAC on 24/11/2023.
//

import SwiftUI
import WidgetKit
import AppIntents
import AVFoundation


struct RectBackgroudView: View {
    
    var entry: RectangleEntry
    
    var selectedBackgroundStlye: SelectedBackgroundStyle {
        return entry.backgroundStyle
    }
    
    var body: some View {
        ZStack {
            
            
            
            Image(uiImage: entry.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
                .frame(maxWidth: entry.size.width, maxHeight: entry.size.height)
                .ignoresSafeArea()
            

        }
        .background(selectedBackgroundStlye == .defaultBackground ? Color.white.opacity(0.25) : .clear)
        .cornerRadiusWithBorder(radius: 12, borderLineWidth: 1, borderColor: selectedBackgroundStlye == .border ? .white : .clear)
    }
    

}

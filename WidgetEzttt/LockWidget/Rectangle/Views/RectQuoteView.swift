//
//  RectQuoteView.swift
//  eWidget
//
//  Created by Three Bros on 26/12/2023.
//


import Foundation


import SwiftUI
import WidgetKit
import AppIntents
import AVFoundation


struct RectQuoteView: View {
    
    var entry: RectangleEntry
    
    func getFont() -> Font {
        let name = entry.imgSrc.getFontName()
        let size = entry.imgSrc.getFontSize()
        return .custom(name, fixedSize: CGFloat(size))
    }
    
    func getAignment() -> TextAlignment {
        let alignString = entry.imgSrc.getCategory()?.alignment ?? ""
        
        let align = AlignmentQuote(rawValue: alignString)
        switch align {
        case .center:
            return .center
        case .left:
            return .leading
        case nil:
            return .leading
        }
    }
    
    var selectedBackgroundStlye: SelectedBackgroundStyle {
        return entry.backgroundStyle
    }
    
    var body: some View {
        ZStack {
            

            
                
                Text("\(entry.quotetitle ?? "")")
                    .font(getFont())
                    .foregroundColor(.white)
                    .multilineTextAlignment(getAignment())
                    .lineLimit(2)
                    .minimumScaleFactor(0.4)
                    .padding(.leading, 4)
                    .padding(.trailing, 4)
                
                
            
            .frame(maxHeight: .infinity)
            
            
        }
        .frame(maxWidth: entry.size.width, maxHeight: entry.size.height)
        .background(selectedBackgroundStlye == .defaultBackground ? Color.white.opacity(0.25) : .clear)
        .cornerRadiusWithBorder(radius: 12, borderLineWidth: 1, borderColor: selectedBackgroundStlye == .border ? .white : .clear)
    }
    
}





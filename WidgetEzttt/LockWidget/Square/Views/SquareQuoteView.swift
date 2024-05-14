//
//  SquareQuoteView.swift
//  eWidget
//
//  Created by Three Bros on 26/12/2023.
//

import Foundation


import SwiftUI
import WidgetKit
import AppIntents
import AVFoundation


struct SquareQuoteView: View {
    
    var entry: SquareEntry
    
    func getFont() -> Font {
        let name = entry.imgSrc.getFontName()
        return .custom(name, fixedSize: 40)
    }
    
    var getFamily: FamilyTypeGifResonpse {
        return entry.imgSrc.getFamilySizeType()
    }
    
    var selectedBackgroundStlye: SelectedBackgroundStyle {
        return entry.backgroundStyle
    }
    
    var body: some View {
        ZStack {
            if getFamily == .squareIcon {
                Image(uiImage: entry.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                    .frame(maxWidth: entry.size.width, maxHeight: entry.size.height)
                    .ignoresSafeArea()
            } else {
                
                Text("\(entry.quotetitle ?? "")")
                    .font(getFont())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.1)
                    .padding(.horizontal, 4)
            }
            
        }
        .frame(maxWidth: entry.size.width, maxHeight: entry.size.height)
        .background(selectedBackgroundStlye == .defaultBackground ? Color.white.opacity(0.25) : .clear)
        .cornerRadiusWithBorder(radius: 12, borderLineWidth: 1, borderColor: selectedBackgroundStlye == .border ? .white : .clear)
    }
    
}





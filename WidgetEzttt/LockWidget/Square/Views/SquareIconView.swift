//
//  SquareIconView.swift
//  eWidget
//
//  Created by MAC on 27/12/2023.
//

import Foundation


import SwiftUI
import WidgetKit
import AppIntents
import AVFoundation


struct SquareIconView: View {
    
    var entry: SquareEntry
    
    var getFamily: FamilyTypeGifResonpse {
        return entry.imgSrc.getFamilySizeType()
    }
    
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
        .frame(maxWidth: entry.size.width, maxHeight: entry.size.height)
        .background(selectedBackgroundStlye == .defaultBackground ? Color.white.opacity(0.25) : .clear)
        .cornerRadiusWithBorder(radius: 12, borderLineWidth: 1, borderColor: selectedBackgroundStlye == .border ? .white : .clear)
        .onAppear {
            
        }
    }
    
}






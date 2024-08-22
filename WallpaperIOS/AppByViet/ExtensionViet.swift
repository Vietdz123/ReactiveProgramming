//
//  ExtensionViet.swift
//  WallpaperIOS
//
//  Created by Tiến Việt Trịnh on 22/8/24.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func placeholder<Placeholder: View>(@ViewBuilder placeholder: () -> Placeholder) -> some View {
        self.modifier(PlaceholderModifier(placeholder: placeholder()))
    }
}

struct PlaceholderModifier<Placeholder: View>: ViewModifier {
    let placeholder: Placeholder
    
    func body(content: Content) -> some View {
        content
            .overlay(
                placeholder
           
        
          
            )
    }
}

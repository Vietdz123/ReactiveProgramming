//
//  ScrollOffsetModifier.swift
//  WallpaperIOS
//
//  Created by Mac on 25/04/2023.
//

import SwiftUI

struct OffsetKey : PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}


extension View{
    @ViewBuilder
    func offsetX( _ addObsever : Bool = false ,complatetion : @escaping (CGRect) -> () ) -> some View {
        self.overlay{
            if addObsever {
                GeometryReader{
                    let rect = $0.frame(in: .global)
                    Color.clear
                        .preference(key:  OffsetKey.self, value: rect )
                        .onPreferenceChange(OffsetKey.self, perform: complatetion)
                }
            }
        }
    }
}

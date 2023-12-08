//
//  FontHelper.swift
//  WallpaperIOS
//
//  Created by Mac on 26/04/2023.
//

import SwiftUI

enum K2D  : String, CaseIterable {
    case bold = "SVN-Avobold"
    case italic = "SVN-Avoitalic"
    case regular = "SVN-Avo"

}


extension View{
    func mfont(_ size : CGFloat, _ k2d : K2D, line : Int = 1) -> some View{
        self.font(.custom(k2d.rawValue, size: size))
            .lineLimit(line)
            .minimumScaleFactor(0.5)
            .offset(y : -2)
    }
    
   
}

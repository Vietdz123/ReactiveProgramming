//
//  LocalizeHepler.swift
//  WallpaperIOS
//
//  Created by Duc on 06/11/2023.
//

import SwiftUI

extension View{
    
}

extension String{
    func toLocalize() -> LocalizedStringKey{
      return  LocalizedStringKey(self)
    }
}

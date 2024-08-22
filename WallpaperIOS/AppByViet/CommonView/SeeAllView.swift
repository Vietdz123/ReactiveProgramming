//
//  SeeAllView.swift
//  WallpaperIOS
//
//  Created by Tiến Việt Trịnh on 22/8/24.
//

import SwiftUI

struct SeeAllView: View {
    
    var body: some View {
        HStack(spacing : 0) {
            Text("See All".toLocalize())
                .mfont(11, .regular)
                .foregroundColor(.white)
            
            Image("arrow.right")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 18, height: 18, alignment: .center)
        }
    }
}

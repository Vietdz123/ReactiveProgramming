//
//  ComponentView.swift
//  WallpaperIOS
//
//  Created by Mac on 17/05/2023.
//

import SwiftUI

struct ComponentView: View {
    var body: some View {
        VStack{
            
            HStack{
                VStack(spacing : 0){
                    Image(systemName: "play.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 26, height: 26)
                }.frame(width: 100)
               
                
                VStack(spacing : 0){
                    Text("Watch 1 short video")
                        .mfont(16, .bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("to save this wallpaper")
                        .mfont(14, .regular)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.frame(maxWidth: .infinity, alignment: .leading)
               
            }.frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                   Capsule()
                    .stroke(Color.white, lineWidth: 1)
                )
                .padding(.horizontal, 20)
            
            HStack{
                VStack(spacing : 0){
                    ResizableLottieView(filename: "star")
                        .frame(width: 48, height: 48)
                }.frame(width: 100)
               
                
                VStack(spacing : 0){
                    Text("Download all wapapers")
                        .mfont(16, .bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("for free")
                        .mfont(16, .bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.frame(maxWidth: .infinity, alignment: .leading)
               
                
            }.frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                   Capsule()
                    .fill(Color.yellow)
                )
                .padding(.horizontal, 20)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.cyan)
    }
}

struct ComponentView_Previews: PreviewProvider {
    static var previews: some View {
        ComponentView()
    }
}

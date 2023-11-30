//
//  EztWatchFaceView.swift
//  WallpaperIOS
//
//  Created by Duc on 24/11/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct EztWatchFaceView: View {
    
    @StateObject var viewModel : EztWatchFaceViewModel = .init()
    @EnvironmentObject var store : MyStore
    var body: some View {

        
     
            
       
        ScrollView(.vertical, showsIndicators: false){
         
            LazyVGrid(columns: [GridItem.init(spacing: 20), GridItem.init()], spacing: 20 ){
                
                if !viewModel.wallpapers.isEmpty {
                    ForEach(0..<viewModel.wallpapers.count, id: \.self){
                        i in
                        let  wallpaper = viewModel.wallpapers[i]
                        let string : String = wallpaper.path.first?.path.preview ?? ""
                        
                        NavigationLink(destination: {
                            WatchFaceDetailView(wallpaper: wallpaper)
                        }, label: {
                            

                                ZStack{
                                    Color.black
                                    WebImage(url: URL(string: string))
                                        .resizable()
                                        .placeholder {
                                            placeHolderImage()
                                                .frame(width: AppConfig.width_1, height: AppConfig.height_1)
                                        }
                                        .scaledToFill()
                                        .cornerRadius(32)
                                        .padding(12)
                                }
                                
                           
                            .frame(width: ( getRect().width - 60 ) / 2 , height:( getRect().width - 60 )  * 196  / 2 / 157)
                                .clipShape(RoundedRectangle(cornerRadius: 36))
                                .cornerRadius(36)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 36)
                                            .inset(by: 1.5)
                                            .stroke(.white.opacity(0.3), lineWidth: 3)

                                )
                                .overlay(
                                    ZStack{
                                        if !store.isPro(){
                                            Image("crown")
                                                .resizable()
                                                .frame(width: 16, height: 16, alignment: .center)
                                                .padding(6)
                                        }
                                    }
                                    
                                 
                                           
                                    
                                    , alignment: .topTrailing
                                )
                            
                            
                            
                        })
                        .onAppear(perform: {
                            if i == ( viewModel.wallpapers.count - 6 ){
                                viewModel.getWallpapers()
                            }
                        })
                    }
                }
            }
            .padding(20)
            
         
            
        }
        .refreshable {
            
        }
      
        .frame(maxWidth : .infinity, maxHeight : .infinity)
        .addBackground()
    }
}


//
//  MyItemView.swift
//  WallpaperIOS
//
//  Created by Duc on 30/10/2023.
//

import SwiftUI
import SDWebImageSwiftUI
import Lottie

extension View{
    @ViewBuilder
    func ItemWL(wallpaper : Wallpaper, isPro : Bool) -> some View{
        
    }
    
    @ViewBuilder
    func ItemLiveWL(wallpaper : Wallpaper, isPro : Bool) -> some View{
        
    }
    
    @ViewBuilder
    func ItemDepthEffectWL(wallpaper : SpWallpaper, isPro : Bool) -> some View{
        let string : String = wallpaper.thumbnail?.path.preview ?? ""
        WebImage(url: URL(string: string))
            .resizable()
            .placeholder {
                placeHolderImage()
                    .frame(width: AppConfig.width_1, height:  AppConfig.height_1)

            }
            .scaledToFill()
            .frame(width: AppConfig.width_1, height:  AppConfig.height_1)
            .cornerRadius(8)
            .clipped()
//            .overlay(alignment : .topTrailing){
//                if !isPro{
//                    Image("crown")
//                        .resizable()
//                        .frame(width: 16, height: 16, alignment: .center)
//                        .padding(8)
//                }
//            }

    }
    
    @ViewBuilder
    func ItemDynamictWL(wallpaper : SpWallpaper, isPro : Bool) -> some View{
        let string : String = wallpaper.thumbnail?.path.preview ?? wallpaper.path.first?.path.small ?? ""
        WebImage(url: URL(string: string))
            .resizable()
            .placeholder {
                placeHolderImage()
                    .frame(width: AppConfig.width_1, height:  AppConfig.height_1)

            }
            .scaledToFill()
            .frame(width: AppConfig.width_1, height:  AppConfig.height_1)
            .cornerRadius(8)
            .clipped()
            .overlay(
                Image("dynamic")
                    .resizable()
                    .frame(width: AppConfig.width_1, height:  AppConfig.height_1)
                    .cornerRadius(8)
            )
//            .overlay(alignment : .topTrailing){
//                if !isPro{
//                    Image("crown")
//                        .resizable()
//                        .frame(width: 16, height: 16, alignment: .center)
//                        .padding(8)
//                }
//            }
//            .onAppear(perform: {
//                print("ItemDynamictWL")
//            })
    }
    
    @ViewBuilder
    func ItemShuffleWL(wallpaper : SpWallpaper, isPro : Bool) -> some View{
        let img1 = wallpaper.path[0].path.small
        let img2 = wallpaper.path[1].path.extraSmall
        let img3 = wallpaper.path[2].path.extraSmall
        ZStack(alignment: .trailing){
            WebImage(url: URL(string: img3))
               .resizable()
               .placeholder {
                   placeHolderImage()
                       .frame(width: 100, height: 200)
               }
               .scaledToFill()
                .frame(width: 100, height: 200)
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 4, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.2), lineWidth : 1)
                )
            
            WebImage(url: URL(string: img2))
               .resizable()
               .placeholder {
                   placeHolderImage()
                       .frame(width: 110, height: 220)
               }
               .scaledToFill()
                .frame(width: 110, height: 220)
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 4, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.2), lineWidth : 1)
                )
                .padding(.trailing, 12)
            
            
            WebImage(url: URL(string: img1))
               .resizable()
               .placeholder {
                   placeHolderImage()
                       .frame(width: 120, height: 240)
               }
               .scaledToFill()
                .frame(width: 120, height: 240)
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 4, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.2), lineWidth : 1)
                )
//                .overlay(
//                    
//                    ZStack{
//                        if !isPro{
//                            Image("crown")
//                                .resizable()
//                                .frame(width: 16, height: 16, alignment: .center)
//                                .padding(8)
//                        }
//                    }
//                    
//                    , alignment: .topTrailing
//                    
//                )
                .padding(.trailing, 24)
        }.frame(width: 160, height: 240)
//            .onAppear(perform: {
//                print("ItemShuffleWL")
//            })
    }
    
    
    @ViewBuilder
    func ItemShuffleWL2(wallpaper : SpWallpaper, isPro : Bool, sizeWidth : CGFloat = ( UIScreen.main.bounds.size.width - 48 ) / 2, sizeHeight : CGFloat = (UIScreen.main.bounds.width - 48 ) * 3 / 4 ) -> some View{
        let img1 = wallpaper.path[0].path.small
        let img2 = wallpaper.path[1].path.extraSmall
        let img3 = wallpaper.path[2].path.extraSmall
        ZStack(alignment: .trailing){
      
            
            WebImage(url: URL(string: img3))
               .resizable()
               .placeholder {
                   placeHolderImage()
                       .frame(width: sizeHeight * 0.4 , height: sizeHeight * 0.8)
               }
               .scaledToFill()
               .frame(width: sizeHeight * 0.4 , height: sizeHeight * 0.8)
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 4, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.2), lineWidth : 1)
                )
            
            WebImage(url: URL(string: img2))
               .resizable()
               .placeholder {
                   placeHolderImage()
                       .frame(width: sizeHeight * 0.45 , height: sizeHeight * 0.9)
               }
               .scaledToFill()
               .frame(width: sizeHeight * 0.45 , height: sizeHeight * 0.9)
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 4, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.2), lineWidth : 1)
                )
                .padding(.trailing, sizeHeight * 0.05)
            
            
            WebImage(url: URL(string: img1))
               .resizable()
               .placeholder {
                   placeHolderImage()
                       .frame(width: sizeHeight / 2, height: sizeHeight)
               }
               .scaledToFill()
                .frame(width: sizeHeight / 2, height: sizeHeight)
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 4, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.2), lineWidth : 1)
                )
//                .overlay(
//                    
//                    ZStack{
//                        if !isPro{
//                            Image("crown")
//                                .resizable()
//                                .frame(width: 16, height: 16, alignment: .center)
//                                .padding(8)
//                        }
//                    }
//                    
//                    , alignment: .topTrailing
//                    
//                )
                .padding(.trailing, sizeHeight * 0.1)
        }.frame(width: sizeWidth, height: sizeHeight)
//            .onAppear(perform: {
//                print("ItemShuffleWL FixSize")
//            })
    }
    
    
    @ViewBuilder
    func ItemWidgetView(widget : EztWidget) -> some View{
        LottieView {
            await LottieAnimation.loadedFrom(url:  URL(string: widget.getURLStringLottie().first ?? "")! )
        } .looping()
            .resizable()
            .scaledToFill()
            .frame(width: 320, height: 320 / 2.2)
            .overlay{
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.4), lineWidth : 1)
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 16)
            )
    }
    
    @ViewBuilder
    func ItemWidgetViewFull(widget : EztWidget) -> some View{
        LottieView {
            await LottieAnimation.loadedFrom(url:  URL(string: widget.getURLStringLottie().first ?? "")! )
        }
            .looping()
            .resizable()
            .scaledToFill()
            .frame(width: getRect().width - 32, height: ( getRect().width - 32 ) / 2.2 )
            .overlay{
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.4), lineWidth : 1)
            }
        
            .clipShape(
                RoundedRectangle(cornerRadius: 16)
            )
    }
    
    @ViewBuilder
    func ItemWidgetPlaceHolder() -> some View{
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing : 0){
                Spacer().frame(width: 16)
                LazyHStack(spacing : 16,content: {
                    ForEach(0..<3, id: \.self) { count in
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 320, height: 320 / 2.2)
                    }
                })
            }
        }
        .disabled(true)
        .frame(height: 160)
    }
    
    
    
    func PlaceHolderListLoad() -> some View{
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing : 8){
                
                
                placeHolderImage()
                    .frame(width: 160, height: 320)
                    .clipped()
                    .cornerRadius(8)
                
                LazyHGrid(rows: [GridItem.init(spacing : 8), GridItem.init()], spacing: 8, content: {
                    ForEach(1..<15, content: {
                        i in
                        
                        placeHolderImage()
                            .frame(width: 78, height: 156)
                            .clipped()
                            .cornerRadius(8)
                        
                        
                        
                    })
                })
            }
            
            
        }
        .frame(height: 320)
        .padding(.horizontal, 16)
        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
    }
    
}


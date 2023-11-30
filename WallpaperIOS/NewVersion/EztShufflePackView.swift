//
//  EztShufflePackView.swift
//  WallpaperIOS
//
//  Created by Duc on 16/10/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct EztShufflePackView: View {
    @EnvironmentObject var wallpaperCatelogVM : WallpaperCatalogViewModel
    @EnvironmentObject var rewardAd : RewardAd
    @EnvironmentObject var interAd : InterstitialAdLoader
    @EnvironmentObject var store : MyStore
  
    var body: some View {
        
        
        ScrollView(.vertical, showsIndicators: false){
            
            
            LazyVStack(spacing: 0, content: {
                NewestView().padding(.bottom, 16)
                
                PopularView().padding(.bottom, 16)
                
                LazyVStack(spacing : 16){
                    ForEach(0..<wallpaperCatelogVM.shufflePackTags.count, id: \.self){
                        i in
                        let data = wallpaperCatelogVM.shufflePackTags[i]
                        
                        
                        VStack(spacing : 0){
                            HStack(spacing : 0){
                                Text("\(data.specialTag.title)")
                                    .mfont(20, .bold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                 
                                Spacer()
                               
                                
                                NavigationLink(destination: {
                                    EztSpecialPageView(currentTag: data.specialTag.title, type: 1, tagID: data.specialTag.id)
                                        .environmentObject(rewardAd)
                                        .environmentObject(interAd)
                                        .environmentObject(store)
                                }, label: {
                                    HStack(spacing : 0){
                                        Text("See more".toLocalize())
                                            .mfont(11, .regular)
                                            .foregroundColor(.white)
                                        Image("arrow.right")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 18, height: 18, alignment: .center)
                                    }
                                })
                                
                                
                                
                            }.frame(height: 36)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 8)
                            
                            
                            
                            ZStack{
                                if !data.wallpapers.isEmpty{
                                    ScrollView(.horizontal, showsIndicators: false){
                                        HStack(spacing : 8){
                                            Spacer().frame(width: 8)
                                            ForEach(data.wallpapers, id: \.id){
                                                wallpaper in
                                                let img1 = wallpaper.path[0].path.small
                                                let img2 = wallpaper.path[1].path.extraSmall
                                                let img3 = wallpaper.path[2].path.extraSmall
                                                NavigationLink(destination: {
                                                    ShuffleDetailView(wallpaper: wallpaper)
                                                          .environmentObject(store)
                                                          .environmentObject(interAd)
                                                          .environmentObject(rewardAd)
                                                }, label: {
                                                    ZStack(alignment: .trailing){
                                                        WebImage(url: URL(string: img3))
                                                           .onSuccess { image, data, cacheType in
                                                           
                                                           }
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
                                                        
                                                           .onSuccess { image, data, cacheType in
                                                           
                                                           }
                                                           .resizable()
                                                           .placeholder {
                                                               placeHolderImage()
                                                                   .frame(width: 110, height: 220)
                                                           }
                                                           .indicator(.activity) // Activity Indicator
                                                           .transition(.fade(duration: 0.5)) // Fade Transition with duration
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
                                                        
                                                           .onSuccess { image, data, cacheType in
                                                           
                                                           }
                                                           .resizable()
                                                           .placeholder {
                                                               placeHolderImage()
                                                                   .frame(width: 120, height: 240)
                                                           }
                                                           .indicator(.activity) // Activity Indicator
                                                           .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                                           .scaledToFill()
                                                            .frame(width: 120, height: 240)
                                                            .cornerRadius(8)
                                                          
                                                            .shadow(color: .black.opacity(0.25), radius: 2, x: 4, y: 2)
                                                            .overlay(
                                                                RoundedRectangle(cornerRadius: 8)
                                                                    .stroke(Color.white.opacity(0.2), lineWidth : 1)
                                                            )
                                                            .overlay(
                                                                
                                                                ZStack{
                                                                if !store.isPro(){
                                                                        Image("crown")
                                                                            .resizable()
                                                                            .frame(width: 16, height: 16, alignment: .center)
                                                                            .padding(8)
                                                                   }
                                                                }
                                                                
                                                                , alignment: .topTrailing
                                                                
                                                            )
                                                            .padding(.trailing, 24)
                                                    }.frame(width: 160, height: 240)
                                                })
                                                
                                            }
                                            Spacer().frame(width: 16)
                                        }
                                    }
                                }
                                else{
                                    CategoryPlaceHolder()
                                }
                                
                                
                            }.frame(height : 240)
                                .onAppear(perform : {
                                    if data.wallpapers.isEmpty {
                                        wallpaperCatelogVM.loadDataDepthEffectWhenAppear(dataType: 1, index: i, tagID: data.specialTag.id)
                                    }
                                })
                            
                            
                        }
                       // .padding(.bottom, 16)
                        
                        
                        
                    }
                }
                
                Spacer()
                    .frame(height: 152)
                
            })
            
           
            
            
       
            
            
        }
        .refreshable {
            wallpaperCatelogVM.shufflePackNew.removeAll()
            wallpaperCatelogVM.shufflePackPopular.removeAll()
            wallpaperCatelogVM.getshufflePackNew()
            wallpaperCatelogVM.getshufflePackPopular()
        }
        
        

    }
    
    
}


extension EztShufflePackView{
    
    func NewestView() -> some View{
        VStack(spacing : 0){
            HStack(spacing : 0){
                Text("Newest".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                  
                Spacer()
               
                
                NavigationLink(destination: {
                    ConditionShufflePackView(urlString:"&order_by=id+desc")
                          .environmentObject(store)
                          .environmentObject(rewardAd)
                          .environmentObject(interAd)
                }, label: {
                    HStack(spacing : 0){
                        Text("See more".toLocalize())
                            .mfont(11, .regular)
                            .foregroundColor(.white)
                        Image("arrow.right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18, height: 18, alignment: .center)
                    }
                })
                
                
                
            }.frame(height: 36)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            
            
            
            ZStack{
                if !wallpaperCatelogVM.shufflePackNew.isEmpty{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 8){
                            Spacer().frame(width: 8)
                            ForEach(wallpaperCatelogVM.shufflePackNew, id: \.id){
                                wallpaper in
                                let img1 = wallpaper.path[0].path.small
                                let img2 = wallpaper.path[1].path.extraSmall
                                let img3 = wallpaper.path[2].path.extraSmall
                                NavigationLink(destination: {
                                    ShuffleDetailView(wallpaper: wallpaper)
                                          .environmentObject(store)
                                          .environmentObject(interAd)
                                          .environmentObject(rewardAd)
                                }, label: {
                                    ZStack(alignment: .trailing){
                                        WebImage(url: URL(string: img3))
                                        
                                           .onSuccess { image, data, cacheType in
                                           
                                           }
                                           .resizable()
                                           .placeholder {
                                               placeHolderImage()
                                                   .frame(width: 100, height: 200)
                                           }
                                           .indicator(.activity) // Activity Indicator
                                           .transition(.fade(duration: 0.5)) // Fade Transition with duration
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
                                            .overlay(
                                                
                                                ZStack{
                                                    if !store.isPro(){
                                                        Image("crown")
                                                            .resizable()
                                                            .frame(width: 16, height: 16, alignment: .center)
                                                            .padding(8)
                                                   }
                                                }
                                                
                                                , alignment: .topTrailing
                                                
                                            )
                                            .padding(.trailing, 24)
                                    }.frame(width: 160, height: 240)
                                })
                                
                            }
                            Spacer().frame(width: 16)
                        }
                    }
                }
                else{
                    CategoryPlaceHolder()
                }
                
                
            }.frame(height : 240)
                .onAppear(perform: {
                    if wallpaperCatelogVM.shufflePackNew.isEmpty{
                        wallpaperCatelogVM.getshufflePackNew()
                    }
                })

        
            
        }
       
    }
    
    func PopularView() -> some View{
        VStack(spacing : 0){
            HStack(spacing : 0){
                Text("Popular".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                   
                Spacer()
               
                
                NavigationLink(destination: {
               
                    
                  ConditionShufflePackView(urlString:"&order_by=daily_rating+desc,id+desc")
                        .environmentObject(store)
                        .environmentObject(rewardAd)
                        .environmentObject(interAd)
                }, label: {
                    HStack(spacing : 0){
                        Text("See more".toLocalize())
                            .mfont(11, .regular)
                            .foregroundColor(.white)
                        Image("arrow.right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18, height: 18, alignment: .center)
                    }
                })
                
                
                
            }.frame(height: 36)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            
            
            
            ZStack{
                if !wallpaperCatelogVM.shufflePackPopular.isEmpty{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 8){
                            Spacer().frame(width: 8)
                            ForEach(wallpaperCatelogVM.shufflePackPopular, id: \.id){
                                wallpaper in
                                let img1 = wallpaper.path[0].path.small
                                let img2 = wallpaper.path[1].path.extraSmall
                                let img3 = wallpaper.path[2].path.extraSmall
                                NavigationLink(destination: {
                                    ShuffleDetailView(wallpaper: wallpaper)
                                          .environmentObject(store)
                                          .environmentObject(interAd)
                                          .environmentObject(rewardAd)
                                }, label: {
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
                                            .overlay(
                                                
                                                ZStack{
                                                    if !store.isPro(){
                                                        Image("crown")
                                                            .resizable()
                                                            .frame(width: 16, height: 16, alignment: .center)
                                                            .padding(8)
                                                    }
                                                }
                                                
                                                , alignment: .topTrailing
                                                
                                            )
                                            .padding(.trailing, 24)
                                    }.frame(width: 160, height: 240)
                                })
                                
                            }
                            Spacer().frame(width: 16)
                        }
                    }
                }
                else{
                    CategoryPlaceHolder()
                }
                
                
            }.frame(height : 240)
                .onAppear(perform: {
                    if wallpaperCatelogVM.shufflePackPopular.isEmpty{
                        wallpaperCatelogVM.getshufflePackPopular()
                    }
                })

        
            
        }
       
    }
}


#Preview {
    NavigationView{
        EztMainView()
    }
   
}

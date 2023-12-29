//
//  EztShufflePackView.swift
//  WallpaperIOS
//
//  Created by Duc on 16/10/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct EztShufflePackView: View {
    @StateObject var newestVM : ShufflePackViewModel = .init(sort : .NEW, sortByTop: .TOP_MONTH)
    @StateObject var popularVM : ShufflePackViewModel = .init(sort : .POPULAR, sortByTop: .TOP_MONTH)
    
    @EnvironmentObject var wallpaperCatelogVM : WallpaperCatalogViewModel
    @EnvironmentObject var rewardAd : RewardAd
    @EnvironmentObject var interAd : InterstitialAdLoader
    @EnvironmentObject var store : MyStore
  
    var body: some View {
        
        
        ScrollView(.vertical, showsIndicators: false){
            
            
            LazyVStack(spacing: 0, content: {
                
                
                NavigationLink(destination: {
                    EztShufflePackListCateView()
                        .environmentObject(wallpaperCatelogVM)
                        .environmentObject(rewardAd)
                        .environmentObject(interAd)
                        .environmentObject(store)
                }, label: {
                    
                    HStack(spacing : 0){
                        Text("Shuffle Packs Category")
                          .font(
                            Font.custom("SVN-Avo", size: 20)
                              .weight(.bold)
                          )
                          .foregroundColor(.white)
                          .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 1)
                          .padding(.leading, 16)
                        
                        Spacer()
                        
                        Image("a.r")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .scaledToFit()
                        .frame(width: 20, height: 20)
                        .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 1)
                        .padding(.trailing, 16)
                        
                    }.frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            Image("shufflepack_category")
                                .resizable()
                        )
                    
                })
                .cornerRadius(16)
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
              
                
                
                
                NewestView()
                    .padding(.bottom, 16)
                
                PopularView().padding(.bottom, 16)
                

                
                Spacer()
                    .frame(height: 152)
                
            })
            
           
            
            
       
            
            
        }
        .refreshable {
        
         
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
                    ShufflePackView()
                        .environmentObject(newestVM)
                        .environmentObject(store)
                        .environmentObject(rewardAd)
                        .environmentObject(interAd)
                }, label: {
                    HStack(spacing : 0){
                        Text("See All".toLocalize())
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
                if !newestVM.wallpapers.isEmpty{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 8){
                            Spacer().frame(width: 8)
                            ForEach(newestVM.wallpapers, id: \.id){
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
             

        
            
        }
       
    }
    
    func PopularView() -> some View{
        VStack(spacing : 0){
            HStack(spacing : 0){
                
                Image("sparkle")
                    .resizable()
                    .frame(width: 20, height: 20)
                
                Text("Popular".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 8)
                   
                Spacer()
               

            }.frame(height: 36)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            
            LazyVGrid(columns: [GridItem.init(spacing: 0), GridItem.init(spacing : 0)], spacing: 16 ){
                
              
                ForEach(0..<popularVM.wallpapers.count, id: \.self){
                        i in
                        let shuffle = popularVM.wallpapers[i]
                        NavigationLink(destination: {
                          ShuffleDetailView(wallpaper: shuffle)
                                .environmentObject(store)
                                .environmentObject(interAd)
                                .environmentObject(rewardAd)
                        }, label: {
                            ItemShuffleWL2(wallpaper: shuffle, isPro: store.isPro())
                        })
                        .onAppear(perform: {
                            if i == ( popularVM.wallpapers.count - 6 ){
                                popularVM.getWallpapers()
                                
                            }
                        })
                        
                    }
               
            }
            .padding(.horizontal, 16)
        }
       
    }
}


#Preview {
    NavigationView{
        EztMainView()
    }
   
}

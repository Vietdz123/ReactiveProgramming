//
//  EztDepthEffectView.swift
//  WallpaperIOS
//
//  Created by Duc on 16/10/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct EztDepthEffectView: View {
    @StateObject var newestVM : DepthEffectViewModel = .init(sort : .NEW, sortByTop: .TOP_MONTH)
    @StateObject var popularVM : DepthEffectViewModel = .init(sort : .POPULAR, sortByTop: .TOP_MONTH)
    
    @EnvironmentObject var wallpaperCatelogVM : WallpaperCatalogViewModel
    @EnvironmentObject var rewardAd : RewardAd
    @EnvironmentObject var interAd : InterstitialAdLoader
    @EnvironmentObject var store : MyStore
    var body: some View {
        
        
        ScrollView(.vertical, showsIndicators: false){
         
            LazyVStack(spacing : 0){
                
                NavigationLink(destination: {
                    EztDepthEffectCateView()
                        .environmentObject(wallpaperCatelogVM)
                        .environmentObject(rewardAd)
                        .environmentObject(interAd)
                        .environmentObject(store)
                }, label: {
                    
                    HStack(spacing : 0){
                        Text("Depth Effect Category")
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
                            .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 1)
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 16)
                        
                    }.frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            Image("deptheffect_category")
                                .resizable()
                        )
                    
                })
                .cornerRadius(16)
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
                
                
                Newset().padding(.bottom, 16)
                
                Popular().padding(.bottom, 16)
                
            
                Spacer()
                    .frame(height: 152)
            }
            
         
            
        }
        .refreshable {
           
           
        }
        

    }
}

extension EztDepthEffectView {
    func Newset() -> some View{
        VStack(spacing : 0){
            HStack(spacing : 0){
                Text("Newest".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    

                Spacer()
               NavigationLink(destination: {
                   DepthEffectView()
                       .environmentObject(newestVM)
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
                if !newestVM.wallpapers.isEmpty{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 8){
                            NavigationLink(destination: {
                                SpWLDetailView(index: 0)
                                    .environmentObject(newestVM as SpViewModel)
                                    .environmentObject(store)
                                    .environmentObject(rewardAd)
                                    .environmentObject(interAd)
                            }, label: {
                                
                                WebImage(url: URL(string: newestVM.wallpapers.first?.thumbnail?.path.preview ?? ""))
                                    .resizable()
                                    .placeholder {
                                        placeHolderImage()
                                    }
                                    .scaledToFill()
                                    .frame(width: 160, height: 320)
                                    .clipped()
                                    .cornerRadius(8)
                            })
                            
                            
                            LazyHGrid(rows: [GridItem.init(spacing : 8), GridItem.init()], spacing: 8, content: {
                                ForEach(1..<15, content: {
                                    i in
                                    let wallpaper = newestVM.wallpapers[i]
                                    NavigationLink(destination: {
                                        SpWLDetailView(index: i)
                                            .environmentObject(newestVM as SpViewModel)
                                            .environmentObject(store)
                                            .environmentObject(rewardAd)
                                            .environmentObject(interAd)
                                    }, label: {
                                        WebImage(url: URL(string: wallpaper.thumbnail?.path.preview ?? ""))
                                            .resizable()
                                            .placeholder {
                                                placeHolderImage()
                                            }
                                            .scaledToFill()
                                            .frame(width: 78, height: 156)
                                            .clipped()
                                            .cornerRadius(8)
                                    })
                                    
                                    
                                    
                                    
                                    
                                    
                                })
                            })
                        }
                        
                        
                    }
                    .frame(height: 320)
                    .padding(.horizontal, 16)
                }
                else{
                    PlaceHolderListLoad()
                }


            }.frame(height : 320)
           
              
            
            
        }
       
    }
    
    
    func Popular() -> some View{
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
            
            
            
            LazyVGrid(columns: [GridItem.init(spacing: 8), GridItem.init()], spacing: 8 ){
                
                if !popularVM.wallpapers.isEmpty {
                    ForEach(0..<popularVM.wallpapers.count, id: \.self){
                        i in
                        let  wallpaper = popularVM.wallpapers[i]
                        let string : String = wallpaper.thumbnail?.path.small ?? ""
                        
                        NavigationLink(destination: {
                            SpWLDetailView(index: i)
                                .environmentObject(popularVM as SpViewModel)
                                .environmentObject(store)
                                .environmentObject(interAd)
                                .environmentObject(rewardAd)
                        }, label: {
                            WebImage(url: URL(string: string))
                                .resizable()
                                .placeholder {
                                    placeHolderImage()
                                        .frame(width: AppConfig.width_1, height: AppConfig.height_1)
                                }
                              
                                .scaledToFill()
                                .frame(width: AppConfig.width_1, height: AppConfig.height_1)
                                .cornerRadius(8)

                        })
                        .onAppear(perform: {
                            if i == ( popularVM.wallpapers.count - 6 ){
                                popularVM.getWallpapers()
                            }
                        })
                    }
                }
            }
            .padding(.horizontal, 16)
              
            
            
        }
       
    }
    
}

extension View{
    
  
    
    func CategoryPlaceHolder() -> some View{
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing : 8){
                Spacer().frame(width: 8)
                ForEach(0..<5, id: \.self){
                    id  in
                  

                   
                            placeHolderImage()
                         
                            .frame(width: 108, height: 216)
                            .cornerRadius(8)
                    


                    
                }
                Spacer().frame(width: 16)
            }
        }.disabled(true)
    }
}

#Preview {
    EztMainView()
}

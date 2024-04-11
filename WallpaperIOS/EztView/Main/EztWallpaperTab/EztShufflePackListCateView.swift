//
//  EztShufflePackListCateView.swift
//  WallpaperIOS
//
//  Created by Duc on 05/12/2023.
//

import SwiftUI
import SDWebImageSwiftUI


struct EztShufflePackListCateView: View {
    
    
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var wallpaperCatelogVM : WallpaperCatalogViewModel
    @EnvironmentObject var rewardAd : RewardAd
    @EnvironmentObject var store : MyStore
    @EnvironmentObject var interAd : InterstitialAdLoader
    
    var body: some View {
        VStack(spacing : 0){
            HStack(spacing : 0){
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image("back")
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .containerShape(Rectangle())
                })
                Text("Shuffle Pack")
                    .foregroundColor(.white)
                    .mfont(22, .bold)
                    .frame(maxWidth: .infinity).padding(.trailing, 18)
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 44)
                .padding(.horizontal, 20)
            
            ScrollView(.vertical, showsIndicators: false){
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
                
                
                                            }
                                            .frame(height : 240)
                                                .onAppear(perform : {
                                                    if data.wallpapers.isEmpty {
                                                        wallpaperCatelogVM.loadDataDepthEffectWhenAppear(dataType: 1, index: i, tagID: data.specialTag.id)
                                                    }
                                                })
                
                
                                        }
                
                
                
                
                                    }
                                }
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
            }
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .edgesIgnoringSafeArea(.bottom)
            .addBackground()
            .onAppear{
                if !store.isPro(){
                    interAd.showAd(onCommit: {
                        
                    })
                }
            }
    }
}

#Preview {
    EztShufflePackListCateView()
}

//
//  LiveWallpaperView.swift
//  WallpaperIOS
//
//  Created by Mac on 05/07/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct LiveWallpaperView: View {
    
    @EnvironmentObject var viewModel : LiveWallpaperViewModel
    @EnvironmentObject var reward : RewardAd
    @EnvironmentObject var store : MyStore
    @EnvironmentObject var favViewModel : FavoriteViewModel
    @EnvironmentObject var interAd : InterstitialAdLoader
    
    var body: some View {
        VStack(spacing : 0){
            Spacer().frame(height: 44)
            ScrollView(.vertical, showsIndicators: false){
                LazyVGrid(columns: [GridItem.init(spacing: 8),GridItem.init()], spacing: 8 ){
                    
                    if !viewModel.liveWallpapers.isEmpty {
                        ForEach(0..<viewModel.liveWallpapers.count, id: \.self){
                            i in
                            let  wallpaper = viewModel.liveWallpapers[i]
                            let string : String = wallpaper.image_variations.preview_small.url.replacingOccurrences(of: "\"", with: "")
                            
                            NavigationLink(destination: {
                                LiveWLView(currentIndex : i)
                                    .navigationBarTitle("", displayMode: .inline)
                                    .navigationBarHidden(true)
                                    .environmentObject(viewModel)
                                    .environmentObject(store)
                                    .environmentObject(favViewModel)
                                    .environmentObject(reward)
                                    .environmentObject(interAd)
                            }, label: {

                                WebImage(url: URL(string: string))
                                
                                   .onSuccess { image, data, cacheType in
                                       // Success
                                       // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                                   }
                                   .resizable()
                                   .placeholder {
                                       placeHolderImage()
                                           .frame(width: AppConfig.width_1, height: AppConfig.height_1)
                                   }
                                   .indicator(.activity) // Activity Indicator
                                   .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                   .scaledToFill()
                                   
                                 
                                   
                                   .frame(width: AppConfig.width_1, height: AppConfig.height_1)
                                .cornerRadius(8)
                                .overlay(
                                    HStack(spacing : 0){
                                        Image("live")
                                            .resizable()
                                            .frame(width: 16, height: 16 )
                                            .padding(8)
                                        Spacer()
                                        if !store.isPro(){
                                            Image("coin")
                                                .resizable()
                                                .frame(width: 13, height: 13, alignment: .center)
                           
                                                .frame(width: 16, height: 16, alignment: .center)
                                                .background(
                                                    Capsule().fill(Color.black.opacity(0.7))
                                                )
                                                .padding(8)
                                        }
                                    }
                                    , alignment: .top
                                )
                            })
                            
                            
                            .onAppear(perform: {
                                if i == ( viewModel.liveWallpapers.count - 6 ){
                                    viewModel.getDataByPage()
                                }
                            })
                            
                        }
                    }
                }
                .padding(16)
            }
            .refreshable {
                viewModel.liveWallpapers.removeAll()
                viewModel.getDataByPage()
            }
        }
    }
}

struct LiveWallpaperView_Previews: PreviewProvider {
    static var previews: some View {
        LiveWallpaperView()
    }
}

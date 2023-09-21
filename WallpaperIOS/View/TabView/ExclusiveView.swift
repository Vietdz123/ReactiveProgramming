//
//  ExclusiveView.swift
//  WallpaperIOS
//
//  Created by Mac on 05/05/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct ExclusiveView: View {
    @EnvironmentObject var viewModel : ExclusiveViewModel
    @EnvironmentObject var reward : RewardAd
    @EnvironmentObject var store : MyStore
    @EnvironmentObject var favViewModel : FavoriteViewModel
    @EnvironmentObject var interAd : InterstitialAdLoader
    
    
    var body: some View {
        VStack(spacing : 0){

            Spacer()
                .frame(height: 44)
            
           
            
            
            ScrollView(.vertical, showsIndicators: false){
                LazyVGrid(columns: [GridItem.init(spacing: 8), GridItem.init(spacing: 0)], spacing: 8 ){
                    
                    ForEach(0..<viewModel.wallpapers.count, id: \.self){
                        i in
                        
                        
                        let  wallpaper = viewModel.wallpapers[i]
                        let string : String = wallpaper.variations.preview_small.url.replacingOccurrences(of: "\"", with: "")
                        
                        NavigationLink(destination: {
                            WLView(index: i)
                                .environmentObject(viewModel as CommandViewModel)
                                .environmentObject(reward)
                                .environmentObject(store)
                                .environmentObject(favViewModel)
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
                            .clipped()
                            .overlay(
                                ZStack{
                                    if !store.isPro() && wallpaper.content_type == "private"{
                                        
                                  
                                            Image("coin")
                                                .resizable()
                                                .frame(width: 13.33, height: 13.33, alignment: .center)
                                          
                                             
                                        .frame(width: 16, height: 16, alignment: .center)
                                            .background(
                                                Capsule()
                                                    .fill(Color.black.opacity(0.7))
                                            )
                                            .padding(8)
                                    }
                                }
                                
                                , alignment: .topTrailing
                            )
                        })
                        .cornerRadius(2)
                        .onAppear(perform: {
                            if viewModel.shouldLoadData(id: i){
                                viewModel.getWallpapers()
                            }
                        })
                        
                    }
                    
                }
                .padding(16)
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .refreshable {
                viewModel.wallpapers.removeAll()
                viewModel.getWallpapers()
            }
        }
    }
}


//struct Y_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView(currentTab: .Exclusive)
//        
//    }
//}

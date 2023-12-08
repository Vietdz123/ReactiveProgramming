//
//  EztLiveWallpaperView.swift
//  WallpaperIOS
//
//  Created by Duc on 17/10/2023.
//

import SwiftUI

import SwiftUI
import SDWebImageSwiftUI

struct EztLiveWallpaperView: View {
    
    @EnvironmentObject var viewModel : LiveWallpaperViewModel
    
        @EnvironmentObject var reward : RewardAd
        @EnvironmentObject var store : MyStore
        
        @EnvironmentObject var interAd : InterstitialAdLoader
    
    var body: some View {
        VStack(spacing : 0){
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
                                                                   
                                                                    .environmentObject(reward)
                                                                    .environmentObject(interAd)
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
                                    .overlay(alignment : .top){
                                        if !store.isPro(){
                                            
                                            HStack{
                                                Image("live")
                                                    .resizable()
                                                    .frame(width: 16, height: 16 )
                                                    .padding(8)
                                                Spacer()
                                                Image("crown")
                                                    .resizable()
                                                    .frame(width: 16, height: 16, alignment: .center)
                                                    .padding(8)
                                            }
                                            
                                           
                                        }
                                    }
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


#Preview {
    EztLiveWallpaperView()
}

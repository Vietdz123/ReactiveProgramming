//
//  DeathEffectView.swift
//  WallpaperIOS
//
//  Created by Mac on 01/08/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct DepthEffectView: View {
    
    @EnvironmentObject var viewModel : DepthEffectViewModel
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var reward : RewardAd
    @EnvironmentObject var store : MyStore
 
    @EnvironmentObject var interAd : InterstitialAdLoader
    
    @State var adStatus : AdStatus = .loading
    
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
                Text("Depth Effect")
                    .foregroundColor(.white)
                    .mfont(22, .bold)
                    .frame(maxWidth: .infinity).padding(.trailing, 18)
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 44)
                .padding(.horizontal, 20)
            
            ScrollView(.vertical, showsIndicators: false){
                LazyVGrid(columns: [GridItem.init(spacing: 8), GridItem.init()], spacing: 8 ){
                    
                    if !viewModel.wallpapers.isEmpty {
                        ForEach(0..<viewModel.wallpapers.count, id: \.self){
                            i in
                            let  wallpaper = viewModel.wallpapers[i]
                            let string : String = wallpaper.thumbnail?.path.small ?? ""
                            
                            NavigationLink(destination: {
                                SpWLDetailView(index: i)
                                    .environmentObject(viewModel as SpViewModel)
                                    .environmentObject(store)
                                    .environmentObject(interAd)
                                    .environmentObject(reward)
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
//                                    .overlay(
//                                        
//                                        ZStack{
//                                            if !store.isPro(){
//                                                Image("crown")
//                                                    .resizable()
//                                                    .frame(width: 16, height: 16, alignment: .center)
//                                                    .padding(8)
//                                            }
//                                        }
//                                        
//                                     
//                                               
//                                        
//                                        , alignment: .topTrailing
//                                    )
                            })
                            .onAppear(perform: {
                                if i == ( viewModel.wallpapers.count - 6 ){
                                    viewModel.getWallpapers()
                                }
                            })
                        }
                    }
                }
                .padding(16)
            }
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .overlay(
                ZStack{
                    if store.allowShowBanner(){
                        BannerAdView(adFormat: .adaptiveBanner, adStatus: $adStatus)
                            
                    }
                }
                
                , alignment: .bottom
            )
            .edgesIgnoringSafeArea(.bottom)
            .addBackground()
    }
}


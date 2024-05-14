//
//  LiveWallpaperView.swift
//  WallpaperIOS
//
//  Created by Duc on 17/10/2023.
//

import SwiftUI

import SwiftUI
import SDWebImageSwiftUI

struct LiveWallpaperView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel : LiveWallpaperViewModel
    
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
                Text("Live Wallpaper")
                    .foregroundColor(.white)
                    .mfont(22, .bold)
                    .frame(maxWidth: .infinity).padding(.trailing, 18)
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 44)
                .padding(.horizontal, 20)
            
            ScrollView(.vertical, showsIndicators: false){
                LazyVGrid(columns: [GridItem.init(spacing: 8),GridItem.init()], spacing: 8 ){
                    
                    if !viewModel.wallpapers.isEmpty {
                        ForEach(0..<viewModel.wallpapers.count, id: \.self){
                            i in
                            let  wallpaper = viewModel.wallpapers[i]
                            let string : String = wallpaper.thumbnail.first?.path.preview ?? ""
                            
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
                                            HStack{
                                                Image("live")
                                                    .resizable()
                                                    .frame(width: 16, height: 16 )
                                                    .padding(8)
                                                Spacer()
                                               
                                            }
                                    }
                                    .showCrownIfNeeded(!store.isPro() && wallpaper.contentType == 1)
                            })
                            
                            
                            .onAppear(perform: {
                                if viewModel.shouldLoadData(id: i){
                                    viewModel.getWallpapers()
                                }
                            })
                            
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
                .padding(16)
            }
            
        }
        .frame(maxWidth : .infinity, maxHeight: .infinity, alignment: .top)
        .edgesIgnoringSafeArea(.bottom)
            .addBackground()
            .overlay(
                ZStack{
                    if store.allowShowBanner(){
                        BannerAdViewMain( adStatus: $adStatus)
                            
                    }
                }
                
                , alignment: .bottom
            )
            .onAppear{
                if !store.isPro(){
                    interAd.showAd(onCommit: {})
                }
            }
    }
}


#Preview {
    LiveWallpaperView()
}

//
//  ShufflePackView.swift
//  WallpaperIOS
//
//  Created by Mac on 01/08/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct ShufflePackView: View {
    @EnvironmentObject var viewModel : ShufflePackViewModel
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
                Text("Shuffle Pack")
                    .foregroundColor(.white)
                    .mfont(22, .bold)
                    .frame(maxWidth: .infinity).padding(.trailing, 18)
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 44)
                .padding(.horizontal, 20)
            
            ScrollView(.vertical, showsIndicators: false){
                LazyVGrid(columns: [GridItem.init(spacing: 8), GridItem.init()], spacing: 16 ){
                    
                    if !viewModel.wallpapers.isEmpty {
                        ForEach(0..<viewModel.wallpapers.count, id: \.self){
                            i in
                            
                            
                            let shuffle = viewModel.wallpapers[i]
                            let img1 = shuffle.path[0].path.small
                            let img2 = shuffle.path[1].path.extraSmall
                            let img3 = shuffle.path[2].path.extraSmall
                            
                            NavigationLink(destination: {
                              ShuffleDetailView(wallpaper: shuffle)
                                    .environmentObject(store)
                                    .environmentObject(interAd)
                                    .environmentObject(reward)
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
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
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

struct ShufflePackView_Previews: PreviewProvider {
    static var previews: some View {
        ShufflePackView()
    }
}

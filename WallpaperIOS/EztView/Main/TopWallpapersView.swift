//
//  TopWallpapersView.swift
//  WallpaperIOS
//
//  Created by Duc on 25/10/2023.
//

import SwiftUI
import SDWebImageSwiftUI
struct TopWallpapersView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel : ExclusiveViewModel
    @EnvironmentObject var reward : RewardAd
    @EnvironmentObject var store : MyStore
    
    @EnvironmentObject var interAd : InterstitialAdLoader
    
    @State var adStatus : AdStatus = .loading
    var body: some View {
        VStack(spacing : 0){
            
            HStack(spacing : 0){
                Button(action: {
                   presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image("back")
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .containerShape(Rectangle())
                })
                Text("Top Wallpapers")
                    .foregroundColor(.white)
                    .mfont(22, .bold)
                    .frame(maxWidth: .infinity).padding(.trailing, 18)
                 
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 44)
                .padding(.horizontal, 20)
            
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
                            .clipped()
                        })
                        .cornerRadius(2)
                        .onAppear(perform: {
                            if viewModel.shouldLoadData(id: i){
                                viewModel.getWallpapers()
                            }
                        })
                        
                    }
                    
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
                .padding(16)
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .refreshable {
                viewModel.wallpapers.removeAll()
                viewModel.getWallpapers()
            }
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .addBackground()
            .edgesIgnoringSafeArea(.bottom)
            .overlay(
                ZStack{
                    if store.allowShowBanner() {
                        BannerAdViewMain(adStatus: $adStatus)
                    }
                }, alignment: .bottom
            )
            .onAppear{
                if !store.isPro(){
                    interAd.showAd(onCommit: {})
                }
            }
    }
}

#Preview {
    TopWallpapersView()
}

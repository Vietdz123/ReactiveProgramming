//
//  TagView.swift
//  WallpaperIOS
//
//  Created by Mac on 04/05/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct TagView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel : TagViewModel
    @EnvironmentObject var reward : RewardAd
    @EnvironmentObject var store : MyStore
   
    @EnvironmentObject var interAd : InterstitialAdLoader
    
    @State var currentTagName : String = ""
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
                Text(viewModel.tag.toLocalize())
                    .foregroundColor(.white)
                    .mfont(22, .bold)
                    .frame(maxWidth: .infinity).padding(.trailing, 18)
                    .onAppear(perform: {
                        currentTagName = viewModel.tag
                    })
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 44)
                .padding(.horizontal, 20)
                .padding(.bottom, 16)

            ScrollView(.vertical, showsIndicators: false){
                LazyVGrid(columns: [GridItem.init(spacing: 8), GridItem.init()], spacing: 8  ){
                    
                    
                    ForEach(0..<viewModel.wallpapers.count, id: \.self){
                        i in
                        let  wallpaper = viewModel.wallpapers[i]
                        let string : String = wallpaper.variations.preview_small.url.replacingOccurrences(of: "\"", with: "")
                        NavigationLink(destination: {
                            WallpaperNormalDetailView( index: i)
                                .environmentObject(viewModel  as CommandViewModel)
                                .environmentObject(reward)
                                .environmentObject(store)
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
                                .scaledToFill()
                                .frame(width: AppConfig.width_1, height: AppConfig.height_1)
                                .cornerRadius(8)
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
                                .onAppear(perform: {
                                    if viewModel.shouldLoadData(id: i){
                                        viewModel.getWallpapers()
                                    }
                                })
                        })
                        
                        
                        
                        
                    }
                    
                }.padding( 16)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
                
            }.refreshable {
                viewModel.randomOffset = Int.random(in: 0...viewModel.maxCount)
                viewModel.currentOffset = viewModel.randomOffset
                viewModel.wallpapers.removeAll()
                viewModel.getWallpapers()
            }
            
            
            
            
            
            
            
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .addBackground()
            .edgesIgnoringSafeArea(.bottom)
            .overlay(
                ZStack{
                    if store.allowShowBanner() {
                        BannerAdViewMain(adStatus: $adStatus)
                    }
                }, alignment: .bottom
            )
            
           
            .onAppear(perform: {
                if currentTagName != viewModel.tag{
                    viewModel.sortedBy = .Newest
                    viewModel.wallpapers = []
                    viewModel.currentOffset = 0
                    viewModel.getWallpapers()
                }
                
                if !store.isPro(){
                    interAd.showAd(onCommit: {})
                }
                
            })
        
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView()
    }
}

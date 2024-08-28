//
//  DynamicView.swift
//  WallpaperIOS
//
//  Created by Mac on 01/08/2023.
//

import SwiftUI
import SDWebImageSwiftUI


struct NewestDynamicView: View {
    
    @State var viewModel : DynamicIslandViewModel 
    @Environment(\.presentationMode) var presentationMode
    @StateObject var store : MyStore = .shared
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
                Text("Dynamic Island")
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
                            let string : String = wallpaper.path.first?.path.small ?? ""
                            
                            Button(action: {
                                EztMainViewModel.shared.paths.append(Router.gotoSpecialWalliveDetailView(currentIndex: i,
                                                                                                    wallpapers: viewModel.wallpapers))
                            }, label: {
                                WebImage(url: URL(string: string))
                                    .onSuccess { image, data, cacheType in
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
                                        Image("dynamic")
                                            .resizable()
                                            .cornerRadius(8)
                                    )
                                    .showCrownIfNeeded(!store.isPro() && wallpaper.contentType == 1)
                            })
                            .onAppear(perform: {
                                if i == ( viewModel.wallpapers.count - 6 ){
                                    viewModel.getWallpapers()
                                }
                            })
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
                .padding(16)
            }
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
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
            
    }
}

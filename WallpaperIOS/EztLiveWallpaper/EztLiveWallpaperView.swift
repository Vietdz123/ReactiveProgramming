//
//  EztLiveWallpaperView.swift
//  WallpaperIOS
//
//  Created by Duc on 08/05/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct EztLiveWallpaperView: View {
    
    @StateObject var newestVM : LiveWallpaperViewModel = .init(sort : .NEW, sortByTop: .TOP_MONTH)
    @StateObject var popularVM : LiveWallpaperViewModel = .init(sort : .POPULAR, sortByTop: .TOP_MONTH)
    @StateObject var store : MyStore = .shared
    @State var adStatus : AdStatus = .loading
    
    @Environment(\.presentationMode) var presentationMode
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
                
                LazyVStack(spacing : 0){
                    
                    
                    
                    
                    Newset().padding(.bottom, 16)
                    
                    Popular().padding(.bottom, 16)
                    
                    
                    Spacer()
                        .frame(height: 152)
                }
                
                
                
            }
            .refreshable {
                
                
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
                InterstitialAdLoader.shared.showAd(onCommit: {})
            }
        }
        
        
        
        
        
    }
}

extension EztLiveWallpaperView {
    func Newset() -> some View{
        VStack(spacing : 0){
            HStack(spacing : 0){
                Text("Newest".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                Spacer()
                
                NavigationLink(destination: {
                    LiveWallpaperView()
                        .environmentObject(newestVM)
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
                if !newestVM.wallpapers.isEmpty{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 8){
                            //MARK: - Viet
                            Button(action: {
                                EztMainViewModel.shared.paths.append(Router.gotoLiveWallpaperDetail(currentIndex: 0,
                                                                                                wallpapers: newestVM.wallpapers))
                            }, label: {
                                WebImage(url: URL(string:  newestVM.wallpapers.first?.thumbnail.first?.path.preview ?? ""))
                                    .resizable()
                                    .placeholder {
                                        placeHolderImage()
                                    }
                                    .scaledToFill()
                                    .frame(width: 160, height: 320)
                                    .clipped()
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
                                    .showCrownIfNeeded(!store.isPro() && newestVM.wallpapers.first?.contentType == 1)
                            })

                            
                            let minItem = min(newestVM.wallpapers.count, 15)
                            
                            LazyHGrid(rows: [GridItem.init(spacing : 8), GridItem.init()], spacing: 8, content: {
                                ForEach(1..<minItem, id: \.self ,content: {
                                    i in
                                    let wallpaper = newestVM.wallpapers[i]
                                    //MARK: - Viet
                                    Button(action: {
                                        EztMainViewModel.shared.paths.append(Router.gotoLiveWallpaperDetail(currentIndex: i,
                                                                                                        wallpapers: newestVM.wallpapers))
                                    }, label: {
                                        WebImage(url: URL(string:  wallpaper.thumbnail.first?.path.preview ?? ""))
                                            .resizable()
                                            .placeholder {
                                                placeHolderImage()
                                            }
                                            .scaledToFill()
                                            .frame(width: 78, height: 156)
                                            .clipped()
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
                                    
                                })
                            })
                        }
                        
                        
                    }
                    .frame(height: 320)
                    .padding(.horizontal, 16)
                }
                else{
                    PlaceHolderListLoad()
                }
                
                
            }.frame(height : 320)
            
            
            
            
        }
        
    }
    
    
    func Popular() -> some View{
        VStack(spacing : 0){
            HStack(spacing : 0){
                Image("sparkle")
                    .resizable()
                    .frame(width: 20, height: 20)
                
                Text("Popular".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 8)
                
                Spacer()
            }.frame(height: 36)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            
            
            
            LazyVGrid(columns: [GridItem.init(spacing: 8), GridItem.init()], spacing: 8 ){
                
                if !popularVM.wallpapers.isEmpty {
                    ForEach(0..<popularVM.wallpapers.count, id: \.self){
                        i in
                        let  wallpaper = popularVM.wallpapers[i]
                        let string : String = wallpaper.thumbnail.first?.path.preview ?? ""
                        
                        Button(action: {
                            EztMainViewModel.shared.paths.append(Router.gotoLiveWallpaperDetail(currentIndex: i,
                                                                                            wallpapers: popularVM.wallpapers))
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
                                .onAppear(perform: {
                                    if i == (popularVM.wallpapers.count - 6) {
                                        popularVM.getWallpapers()
                                    }
                                })
                        })

                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
            .padding(.horizontal, 16)
            
            
            
        }
        
    }
    
}

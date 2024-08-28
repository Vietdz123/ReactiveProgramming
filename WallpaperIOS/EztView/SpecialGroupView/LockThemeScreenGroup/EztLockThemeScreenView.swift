//
//  EztLockThemeScreenView.swift
//  WallpaperIOS
//
//  Created by Duc on 07/05/2024.
//

import SwiftUI
import SDWebImageSwiftUI
import Lottie

struct EztLockThemeScreenView: View {
    @StateObject var newestVM : LockThemeViewModel = .init(sort : .NEW, sortByTop: .TOP_MONTH)
    @StateObject var popularVM : LockThemeViewModel = .init(sort : .POPULAR, sortByTop: .TOP_MONTH)
    @StateObject var store : MyStore = .shared
    @State var adStatus : AdStatus = .loading
    
    var body: some View {
        
        VStack(spacing : 0){
            
            ScrollView(.vertical, showsIndicators: false){
                
                LazyVStack(spacing : 0){

                    Newset()
                        .padding(.bottom, 16)
                    
                    Popular()
                        .padding(.bottom, 16)

                    Spacer()
                        .frame(height: 152)
                }
                
            }
        }
        .frame(maxWidth : .infinity, maxHeight: .infinity, alignment: .top)
        .edgesIgnoringSafeArea(.bottom)
        .addBackground()
        
    }
}

extension EztLockThemeScreenView {
    func Newset() -> some View {
        VStack(spacing : 0){
            HStack(spacing : 0) {
                Text("Newest".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                Spacer()
                //MARK: - Viet
                
                Button(action: {
                    EztMainViewModel.shared.paths.append(Router.gotoLockThemeListView(wallpapers: newestVM.wallpapers))
                    
                }, label: {
                    SeeAllView()
                })
            }
            .frame(height: 36)
            .padding(.horizontal, 16)
            .padding(.bottom, 8)

            ZStack {
                if !newestVM.wallpapers.isEmpty{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 8){
                            Button(action: {
                                EztMainViewModel.shared.paths.append(Router.gotoLockThemeDetailView(wallpapers: newestVM.wallpapers, currentIndex: 0))
                                
                            }, label: {
                                let wallpaper = newestVM.wallpapers.first
                                
                                ZStack {
                                    if (wallpaper?.thumbnail.first?.url.full ?? "" ).contains(".json"){
                                        if let url = URL(string: wallpaper?.thumbnail.first?.url.full ?? ""){
                                            LottieView {
                                                await LottieAnimation.loadedFrom(url:  url )
                                            } .looping()
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 160, height: 160 * 2.2)
                                            
                                        }
                                        
                                    } else {
                                        WebImage(url: URL(string:  wallpaper?.thumbnail.first?.url.preview ?? ""))
                                            .resizable()
                                            .placeholder {
                                                placeHolderImage()
                                            }
                                            .scaledToFill()
                                            .frame(width: 160, height: 160 * 2.2)
                                            .clipped()
                                    }
                                }
                                .frame(width: 160, height: 160 * 2.2)
                                .cornerRadius(8)
                                .showCrownIfNeeded(!store.isPro() && wallpaper?.private == 1)
                            })
                            
                            let minItem = min(newestVM.wallpapers.count, 15)
                            
                            LazyHGrid(rows: [GridItem.init(spacing : 8), GridItem.init()], spacing: 8, content: {
                                ForEach(1 ..< minItem, id: \.self ,content: { i in
                                    let wallpaper = newestVM.wallpapers[i]
                                    
                                    //MARK: - Viet
                                    Button(action: {
                                        EztMainViewModel.shared.paths.append(Router.gotoLockThemeDetailView(wallpapers: newestVM.wallpapers,
                                                                                                            currentIndex: i))
                                        
                                    }, label: {
                                        ZStack{
                                            if (wallpaper.thumbnail.first?.url.full ?? "" ).contains(".json"){
                                                if let url = URL(string: wallpaper.thumbnail.first?.url.full ?? ""){
                                                    LottieView {
                                                        await LottieAnimation.loadedFrom(url:  url )
                                                    } 
                                                    .looping()
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 78, height: 78 * 2.2)
                                                }
                                                
                                            } else {
                                                WebImage(url: URL(string:  wallpaper.thumbnail.first?.url.preview ?? ""))
                                                    .resizable()
                                                    .placeholder {
                                                        placeHolderImage()
                                                    }
                                                    .scaledToFill()
                                                    .frame(width: 78, height: 78 * 2.2)
                                                    .clipped()
                                            }
                                        }
                                        .frame(width: 78, height: 78 * 2.2)
                                        .cornerRadius(8)
                                        .showCrownIfNeeded(!store.isPro() && wallpaper.private == 1)
                                    })
                                    
                                })
                            })
                        }
                        
                    }
                    .frame(height: 320)
                    .padding(.horizontal, 16)
                    
                } else {
                    PlaceHolderListLoadForTheme()
                }

            }
            .frame(height : 160 * 2.2)
        }
    }
    
    
    func Popular() -> some View {
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
            }
            .frame(height: 36)
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
            
            LazyVGrid(columns: [GridItem.init(spacing: 8), GridItem.init()], spacing: 8 ){
                
                if !popularVM.wallpapers.isEmpty {
                    ForEach(0..<popularVM.wallpapers.count, id: \.self){
                        i in
                        let  wallpaper = popularVM.wallpapers[i]
                        let string : String = wallpaper.thumbnail.first?.url.full ?? ""
                        
                        //MARK: - Viet
                        Button(action: {
                            EztMainViewModel.shared.paths.append(Router.gotoLockThemeDetailView(wallpapers: popularVM.wallpapers, currentIndex: i))
                            
                        }, label: {
                            ZStack{
                                if string.contains(".json"){
                                    if let url = URL(string: string){
                                        LottieView {
                                            await LottieAnimation.loadedFrom(url:  url )
                                        } .looping()
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: AppConfig.width_1, height: AppConfig.width_1 * 2.2)
                                            .onAppear(perform: {
                                                print("Lockthemes Lottie File: \(string)")
                                            })
                                    }
                                    
                                }else{
                                    WebImage(url: URL(string: wallpaper.thumbnail.first?.url.preview ?? ""))
                                        .resizable()
                                        .placeholder {
                                            placeHolderImage()
                                                .frame(width: AppConfig.width_1, height: AppConfig.width_1 * 2.2)
                                        }
                                    
                                        .scaledToFill()
                                }
                                
                            }
                            .frame(width: AppConfig.width_1, height: AppConfig.width_1 * 2.2)
                            .cornerRadius(8)
                            .showCrownIfNeeded(!store.isPro() && wallpaper.private == 1)
                            .onAppear(perform: {
                                if i == ( popularVM.wallpapers.count - 6 ){
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

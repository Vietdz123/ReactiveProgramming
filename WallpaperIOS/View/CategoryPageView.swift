//
//  CategoryPageView.swift
//  WallpaperIOS
//
//  Created by Mac on 04/05/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct CategoryPageView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel : CategoryPageViewModel
    @EnvironmentObject var reward : RewardAd
    @EnvironmentObject var store : MyStore
    @EnvironmentObject var favViewModel : FavoriteViewModel
    @EnvironmentObject var interAd : InterstitialAdLoader
    
    @Namespace var anim
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
                Text(viewModel.category?.title ?? "")
                    .foregroundColor(.white)
                    .mfont(22, .bold)
                    .frame(maxWidth: .infinity).padding(.trailing, 18)
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 44)
                .padding(.horizontal, 20)
            ScrollView(.vertical, showsIndicators: false){
                LazyVGrid(columns: [GridItem.init(spacing: 8),  GridItem.init()], spacing: 8 ){
                    if !viewModel.wallpapers.isEmpty {
                        ForEach(0..<viewModel.wallpapers.count, id: \.self){
                            i in
                            let  wallpaper = viewModel.wallpapers[i]
                            let string : String = wallpaper.variations.preview_small.url.replacingOccurrences(of: "\"", with: "")
                            
                            NavigationLink(destination: {
                                WLView(index: i)
                                    .environmentObject(viewModel  as CommandViewModel)
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
                            
                            
                            .onAppear(perform: {
                                if i == ( viewModel.wallpapers.count - 6 ){
                                    viewModel.getWallpapers()
                                    
                                }
                            })
                            
                        }
                    }
                }
                .padding(16)
            }.refreshable {
                viewModel.randomOffset = Int.random(in: 0...viewModel.maxCount)
                viewModel.currentOffset = viewModel.randomOffset
                viewModel.wallpapers.removeAll()
                viewModel.getWallpapers()
            }
            .onAppear(perform: {
                viewModel.wallpapers = []
                viewModel.currentOffset = 0
                viewModel.getWallpapers()
                
            })
            
        }
        .addBackground()
    }
}



















//    TabView(selection: $viewModel.sortedBy){
//          ScrollView(.vertical, showsIndicators: false){
//                    LazyVGrid(columns: [GridItem.init(spacing: 3), GridItem.init(spacing: 3)], spacing: 8 ){
//
//                        if !viewModel.wallpaperPopular.isEmpty {
//                            ForEach(0..<viewModel.wallpaperPopular.count, id: \.self){
//                                i in
//
//
//                                let  wallpaper = viewModel.wallpaperPopular[i]
//                                let string : String = wallpaper.variations.preview_small.url.replacingOccurrences(of: "\"", with: "")
//
//                                NavigationLink(destination: {
//                                    WallpaperDetails(wallpaper: wallpaper)
//                                }, label: {
//                                    AsyncImage(url: URL(string: string)){
//                                        phase in
//                                        if let image = phase.image {
//                                            image
//                                                .resizable()
//                                                .scaledToFill()
//                                                .frame(width: AppConfig.imgWidth, height: AppConfig.imgHeight)
//                                                .clipped()
//                                        } else if phase.error != nil {
//                                            Color.red
//                                        } else {
//                                            Color.blue
//                                        }
//
//
//                                    }
//                                    .frame(width: imgWidth, height: imgHeight)
//                                })
//
//
//                                .onAppear(perform: {
//                                    if i == ( viewModel.wallpaperPopular.count - 6 ){
//                                        viewModel.getDataPopularByPage()
//
//                                    }
//                                })
//
//                            }
//                        }
//                    }
//                    .padding(16)
//                }.tag(Sorted.Popular)
//
//                ScrollView(.vertical, showsIndicators: false){
//                    LazyVGrid(columns: [GridItem.init(spacing: 3), GridItem.init(spacing: 3), GridItem.init(spacing: 0)], spacing: 3 ){
//                        if !viewModel.wallpaperDownloaded.isEmpty {
//                            ForEach(0..<viewModel.wallpaperDownloaded.count, id: \.self){
//                                i in
//
//
//                                let  wallpaper = viewModel.wallpaperDownloaded[i]
//                                let string : String = wallpaper.variations.preview_small.url.replacingOccurrences(of: "\"", with: "")
//
//                                NavigationLink(destination: {
//                                    WallpaperDetails(wallpaper: wallpaper)
//                                }, label: {
//                                    AsyncImage(url: URL(string: string)){
//                                        phase in
//                                        if let image = phase.image {
//                                            image
//                                                .resizable()
//                                                .scaledToFill()
//                                                .frame(width: AppConfig.imgWidth, height: AppConfig.imgHeight)
//                                                .clipped()
//                                        } else if phase.error != nil {
//                                            Color.red
//                                        } else {
//                                            Color.blue
//                                        }
//
//
//                                    }
//                                    .frame(width: imgWidth, height: imgHeight)
//                                })
//
//
//                                .onAppear(perform: {
//                                    if i == ( viewModel.wallpaperDownloaded.count - 6 ){
//                                        viewModel.getDataDownloadedByPage()
//
//                                    }
//                                })
//
//                            }
//                        }
//
//
//
//
//                    }
//                }.tag(Sorted.Downloaded)


//ScrollView(.vertical, showsIndicators: false){
//                    LazyVGrid(columns: [GridItem.init(spacing: 3), GridItem.init(spacing: 3), GridItem.init(spacing: 0)], spacing: 3 ){
//                        if !viewModel.wallpaperNewest.isEmpty{
//                            ForEach(0..<viewModel.wallpaperNewest.count, id: \.self){
//                                i in
//
//
//                                let  wallpaper = viewModel.wallpaperNewest[i]
//                                let string : String = wallpaper.variations.preview_small.url.replacingOccurrences(of: "\"", with: "")
//
//                                NavigationLink(destination: {
//                                   // WallpaperDetails(wallpaper: wallpaper)
//                                }, label: {
//                                    AsyncImage(url: URL(string: string)){
//                                        phase in
//                                        if let image = phase.image {
//                                            image
//                                                .resizable()
//                                                .scaledToFill()
//                                                .frame(width: AppConfig.imgWidth, height: AppConfig.imgHeight)
//                                                .clipped()
//                                        } else if phase.error != nil {
//                                            Color.red
//                                        } else {
//                                            Color.blue
//                                        }
//
//
//                                    }
//                                    .frame(width: imgWidth, height: imgHeight)
//                                })
//
//
//                                .onAppear(perform: {
//                                    if i == ( viewModel.wallpaperNewest.count - 6 ){
//                                        viewModel.getDataNewsetByPage()
//
//                                    }
//                                })
//
//                            }
//                        }
//
//
//
//                    }
//               }
//.tag(Sorted.Newest)

//  }.tabViewStyle(.page(indexDisplayMode: .never))

//    }
//                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
//                .edgesIgnoringSafeArea(.bottom)
//                .addBackground()
//                .onAppear(perform: {
//                    viewModel.wallpaperPopular = []
//                    viewModel.popularOffset = 0
//                    viewModel.getDataPopularByPage()
//
//
//                    viewModel.wallpaperDownloaded = []
//                    viewModel.popularOffset = 0
//                    viewModel.getDataDownloadedByPage()
//
//
//                    viewModel.wallpaperNewest = []
//                    viewModel.newestOffset = 0
//                    viewModel.getDataNewsetByPage()
//                })

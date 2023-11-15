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
    @State var currentCategoryName : String = ""
    @State var adStatus : AdStatus = .loading
    
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
                    .onAppear(perform: {
                        currentCategoryName = viewModel.category?.title ?? ""
                    })
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 44)
                .padding(.horizontal, 20)
            
            if currentCategoryName != "New Trending"{
                
         
            
            HStack{
                
                
                
                          Text("Newest")
                              .mfont(13, .bold)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .frame(width : 80, height: 28)
                            .background(
                              ZStack{
                                  Capsule()
                                      .fill(Color.white.opacity(0.1))
                                  
                                  if viewModel.categorySort == .NEW {
                                      Capsule()
                                          .fill(
                                              LinearGradient(
                                              stops: [
                                              Gradient.Stop(color: Color(red: 0.15, green: 0.7, blue: 1), location: 0.00),
                                              Gradient.Stop(color: Color(red: 0.46, green: 0.37, blue: 1), location: 0.52),
                                              Gradient.Stop(color: Color(red: 0.9, green: 0.2, blue: 0.87), location: 1.00),
                                              ],
                                              startPoint: UnitPoint(x: 0, y: 1.38),
                                              endPoint: UnitPoint(x: 1, y: -0.22)
                                              )
                                          
                                          )
                                          .matchedGeometryEffect(id: "SORT", in: anim)
                                  }
                                  
                              }
                              
                            )
                            .contentShape(Rectangle())
                            .onTapGesture(perform: {
                                viewModel.categorySort = .NEW
                                viewModel.currentOffset = 0
                                viewModel.wallpapers.removeAll()
                                viewModel.getWallpapers()
                            })
                
                
                Text("Popular")
                    .mfont(13, .bold)
                  .multilineTextAlignment(.center)
                  .foregroundColor(.white)
                  .frame(width : 80, height: 28)
                  .background(
                    ZStack{
                        Capsule()
                            .fill(Color.white.opacity(0.1))
                        
                        if viewModel.categorySort == .TOP {
                            Capsule()
                                .fill(
                                    LinearGradient(
                                    stops: [
                                    Gradient.Stop(color: Color(red: 0.15, green: 0.7, blue: 1), location: 0.00),
                                    Gradient.Stop(color: Color(red: 0.46, green: 0.37, blue: 1), location: 0.52),
                                    Gradient.Stop(color: Color(red: 0.9, green: 0.2, blue: 0.87), location: 1.00),
                                    ],
                                    startPoint: UnitPoint(x: 0, y: 1.38),
                                    endPoint: UnitPoint(x: 1, y: -0.22)
                                    )
                                
                                )
                                .matchedGeometryEffect(id: "SORT", in: anim)
                        }
                        
                    }
                    
                  )
                  .contentShape(Rectangle())
                  .onTapGesture(perform: {
                      viewModel.categorySort = .TOP
                      viewModel.currentOffset = 0
                      viewModel.wallpapers.removeAll()
                      viewModel.getWallpapers()
                  })
                
                Spacer()
                
                
           
                
            } .padding(16)
            
            }
            
            
            
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
                                    .overlay(alignment : .topTrailing){
                                        if !store.isPro() && wallpaper.content_type == "private" {
                                            Image("crown")
                                                .resizable()
                                                .frame(width: 16, height: 16, alignment: .center)
                                                .padding(8)
                                        }
                                    }
                            })
                            
                            
                            .onAppear(perform: {
                                if i == ( viewModel.wallpapers.count - 6 ){
                                    viewModel.getWallpapers()
                                    
                                }
                                
                                
                                
                                
                            })
                            
                        }
                    }
                }
                .padding(.horizontal, 16)
            }.refreshable {
                
                viewModel.currentOffset = 0
                viewModel.wallpapers.removeAll()
                viewModel.getWallpapers()
            }
            .onAppear(perform: {
                if ( viewModel.category?.title ?? "" ) != currentCategoryName {
                    viewModel.categorySort = .NEW
                    viewModel.wallpapers = []
                    viewModel.currentOffset = 0
                    viewModel.getWallpapers()
                }
                
                
            })
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
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



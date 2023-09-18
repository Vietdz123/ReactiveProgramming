//
//  CategoryView.swift
//  WallpaperIOS
//
//  Created by Mac on 28/04/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct CategoryView: View {
    
    @EnvironmentObject var viewModel : CategoryViewModel
    @EnvironmentObject var liveViewModel : LiveWallpaperViewModel
    
    @StateObject var categoryPageViewModel : CategoryPageViewModel = .init()
    @EnvironmentObject var reward : RewardAd
    @EnvironmentObject var store : MyStore
    @EnvironmentObject var favViewModel : FavoriteViewModel
    @EnvironmentObject var interAd : InterstitialAdLoader
    var body: some View {
        VStack(spacing : 0){
            Spacer()
                .frame(height: 44 )
            ScrollView(.vertical, showsIndicators: false){
                NavigationLink(isActive: $viewModel.navigate, destination: {
                    CategoryPageView()
                        .environmentObject(categoryPageViewModel)
                        .environmentObject(reward)
                        .environmentObject(store)
                        .environmentObject(favViewModel)
                        .environmentObject(interAd)
                    
                }, label: {
                    EmptyView()
                })
                
                Spacer()
                    .frame(height : 16)
                
                
                LazyVStack(spacing : 0){
                    ForEach(0..<viewModel.categorieWithData.count, id: \.self){
                        index in
                        let categoryData  = viewModel.categorieWithData[index]
                        VStack(spacing : 0){
                            HStack(spacing : 0){
                                Text("\(categoryData.category.title)")
                                    .mfont(17, .bold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, 12)
                                    .onAppear(perform: {
                                        if viewModel.checkIfLoadData(i: index){
                                            viewModel.getCategoryWithData()
                                        }
                                    })
                                Spacer()
                                Button(action: {
                                    categoryPageViewModel.category = categoryData.category
                                    viewModel.navigate.toggle()
                                }, label: {
                                    HStack(spacing : 0){
                                        Text("See more")
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
                                if !categoryData.wallpapers.isEmpty{
                                    ScrollView(.horizontal, showsIndicators: false){
                                        HStack(spacing : 8){
                                            Spacer().frame(width: 8)
                                            ForEach(categoryData.wallpapers, id: \.id){
                                                wallpaper in
                                                let string : String = wallpaper.variations.preview_small.url.replacingOccurrences(of: "\"", with: "")
                                                NavigationLink(destination: {
                                                    
                                                    WallpaperOnePageDetails(wallpaper: wallpaper)
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
                                                                .frame(width: 108, height: 216)
                                                        }
                                                        .indicator(.activity) // Activity Indicator
                                                        .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                                        .scaledToFill()
                                                        .frame(width: 108, height: 216)
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
                                                
                                            }
                                            Spacer().frame(width: 16)
                                        }
                                    }
                                }
                                else{
                                    ProgressView()
                                }
                                
                             
                            }.frame(height : 216)
                                .onAppear(perform : {
                                    if categoryData.wallpapers.isEmpty {
                                        viewModel.loadDataWhenAppear(index: index)
                                    }
                                })
                           
                            
                        }
                        .padding(.bottom, 16)
                        
                    }
                }
                
                Spacer()
                    .frame(height : 112)
                
                
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .refreshable {
                viewModel.categorieWithData.removeAll()
                viewModel.getAllCategory()
           //     viewModel.getCategoryWithData()
            }
        }.addBackground()
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
        
            .environmentObject(CategoryViewModel())
    }
}


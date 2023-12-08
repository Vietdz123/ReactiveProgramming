//
//  EztDynamicIslslandCateView.swift
//  WallpaperIOS
//
//  Created by Duc on 05/12/2023.
//

import SwiftUI
import SDWebImageSwiftUI
struct EztDynamicIslslandCateView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var wallpaperCatelogVM : WallpaperCatalogViewModel
    @EnvironmentObject var rewardAd : RewardAd
    @EnvironmentObject var store : MyStore
    @EnvironmentObject var interAd : InterstitialAdLoader
    
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
                LazyVStack(spacing : 16){
                    ForEach(0..<wallpaperCatelogVM.dynamicTags.count, id: \.self){
                        i in
                        let data = wallpaperCatelogVM.dynamicTags[i]
                        
                        
                        VStack(spacing : 0){
                            HStack(spacing : 0){
                                Text("\(data.specialTag.title)")
                                    .mfont(20, .bold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                  

                                Spacer()
                                NavigationLink(destination: {
                                    EztSpecialPageView(currentTag: data.specialTag.title, type: 3, tagID: data.specialTag.id)
                                        .environmentObject(rewardAd)
                                        .environmentObject(interAd)
                                        .environmentObject(store)
                                 }, label: {
                                    HStack(spacing : 0){
                                        Text("See more".toLocalize())
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
                                if !data.wallpapers.isEmpty{
                                    ScrollView(.horizontal, showsIndicators: false){
                                        HStack(spacing : 8){
                                            Spacer().frame(width: 8)
                                            ForEach(data.wallpapers, id: \.id){
                                                wallpaper in
                                                let string : String = wallpaper.thumbnail?.path.preview ?? wallpaper.path.first?.path.small ?? ""
                                                NavigationLink(destination: {
                                                    SPWLOnePageDetailView(wallpaper: wallpaper)
                                                        .environmentObject(store)
                                                        .environmentObject(interAd)
                                                        .environmentObject(rewardAd)
                                                }, label: {

                                                    WebImage(url: URL(string: string))
                                                        .resizable()
                                                        .placeholder {
                                                            placeHolderImage()
                                                                .frame(width: 108, height: 216)

                                                        }
                                                        .scaledToFill()
                                                        .frame(width: 108, height: 216)
                                                        .cornerRadius(8)
                                                        .clipped()
                                                        .overlay(
                                                            Image("dynamic")
                                                                .resizable()
                                                                .frame(width: 108, height: 216)
                                                                .cornerRadius(8)
                                                        )
//                                                        .overlay(alignment : .topTrailing){
//                                                            if !store.isPro(){
//                                                                Image("crown")
//                                                                    .resizable()
//                                                                    .frame(width: 16, height: 16, alignment: .center)
//                                                                    .padding(8)
//                                                            }
//                                                        }
                                                })

                                            }
                                            Spacer().frame(width: 16)
                                        }
                                    }
                                }
                                else{
                                    CategoryPlaceHolder()
                                }


                            }.frame(height : 216)
                                .onAppear(perform : {
                                    if data.wallpapers.isEmpty {
                                        wallpaperCatelogVM.loadDataDepthEffectWhenAppear(dataType: 3,index: i, tagID: data.specialTag.id)
                                    }
                                })
                            
                            
                        }
                        .padding(.bottom, 16)
                        
                        
                        
                    }
                }
            }
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .edgesIgnoringSafeArea(.bottom)
            .addBackground()
    }
}

#Preview {
    EztDynamicIslslandCateView()
}

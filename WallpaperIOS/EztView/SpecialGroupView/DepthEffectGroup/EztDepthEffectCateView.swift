//
//  EztDepthEffectCateView.swift
//  WallpaperIOS
//
//  Created by Duc on 05/12/2023.
//

import SwiftUI
import SDWebImageSwiftUI
struct EztDepthEffectCateView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var wallpaperCatelogVM : WallpaperCatalogViewModel = .shared
    @StateObject var store : MyStore = .shared
    
    var body: some View {
        VStack(spacing : 0){
            HStack(spacing : 0){
                Button(action: {
                    dismiss()
                    
                }, label: {
                    Image("back")
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .containerShape(Rectangle())
                })
                Text("Depth Effect")
                    .foregroundColor(.white)
                    .mfont(22, .bold)
                    .frame(maxWidth: .infinity).padding(.trailing, 18)
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 44)
                .padding(.horizontal, 20)
            
            ScrollView(.vertical, showsIndicators: false){
                LazyVStack(spacing : 16){
                    ForEach(0..<wallpaperCatelogVM.depthEffectTags.count, id: \.self){
                        i in
                        let data = wallpaperCatelogVM.depthEffectTags[i]
                        
                        
                        VStack(spacing : 0){
                            HStack(spacing : 0){
                                Text("\(data.specialTag.title)")
                                    .mfont(20, .bold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                   

                                Spacer()
                                
                                Button(action: {
                                    EztMainViewModel.shared.paths.append(Router.gotoSpeicalPageView(title: data.specialTag.title,
                                                                                                    type: 2,
                                                                                                    tadId: data.specialTag.id))
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
            
                            }
                            .frame(height: 36)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 8)
                            
                            
                            
                            ZStack{
                                if !data.wallpapers.isEmpty{
                                    ScrollView(.horizontal, showsIndicators: false){
                                        HStack(spacing : 8){
                                            Spacer().frame(width: 8)
                                            ForEach(0..<data.wallpapers.count, id: \.self){
                                                stt in
                                                let wallpaper = data.wallpapers[stt]
                                                let string : String = wallpaper.thumbnail?.path.preview ?? ""
                                                
                                                Button(action: {
                                                    EztMainViewModel.shared.paths.append(Router.gotoSpecialOnePageDetailView(wallpapers: data.wallpapers,
                                                                                                                             index: stt))
                                                }, label: {
                                                    WebImage(url: URL(string: string))
                                                        .onSuccess { image, data, cacheType in

                                                        }
                                                        .resizable()
                                                        .placeholder {
                                                            placeHolderImage()
                                                                .frame(width: 108, height: 216)

                                                        }
                                                        .scaledToFill()
                                                        .frame(width: 108, height: 216)
                                                        .cornerRadius(8)
                                                        .clipped()
                                                        .showCrownIfNeeded(!store.isPro() && wallpaper.contentType == 1)
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
                                        wallpaperCatelogVM.loadDataDepthEffectWhenAppear(dataType: 2,index: i, tagID: data.specialTag.id)
                                    }
                                })
                            
                            
                        }
                      
                        
                        
                        
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
    EztDepthEffectCateView()
}

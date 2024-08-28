//
//  EztDepthEffectView.swift
//  WallpaperIOS
//
//  Created by Duc on 16/10/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct EztDepthEffectView: View {
    @StateObject var newestVM : DepthEffectViewModel = .init(sort : .NEW, sortByTop: .TOP_MONTH)
    @StateObject var popularVM : DepthEffectViewModel = .init(sort : .POPULAR, sortByTop: .TOP_MONTH)
    @StateObject var wallpaperCatelogVM : WallpaperCatalogViewModel = .shared
    @StateObject var store : MyStore = .shared
    
    @Environment(\.dismiss) var dismiss
    
    @State var adStatus : AdStatus = .loading
    
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
             
                LazyVStack(spacing : 0){
                    
                    NavigationLink(destination: {
                        EztDepthEffectCateView()
                        
                    }, label: {
                        
                        HStack(spacing : 0){
                            Text("Depth Effect Category")
                                .mfont(20, .bold)
                              .foregroundColor(.white)
                              .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 1)
                              .padding(.leading, 16)
                            
                            Spacer()
                            
                            Image("a.r")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .scaledToFit()
                                .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 1)
                            .frame(width: 20, height: 20)
                            .padding(.trailing, 16)
                            
                        }.frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                Image("deptheffect_category")
                                    .resizable()
                            )
                        
                    })
                    .cornerRadius(16)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                    .padding(.top, 8)
                    
                    
                    Newset().padding(.bottom, 16)
                    
                    Popular().padding(.bottom, 16)
                    
                
                    Spacer()
                        .frame(height: 152)
                }
                
             
                
            }
            .refreshable {
               
               
            }
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .addBackground()
            .edgesIgnoringSafeArea(.bottom)
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

extension EztDepthEffectView {
    func Newset() -> some View{
        VStack(spacing : 0){
            HStack(spacing : 0){
                Text("Newest".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    

                Spacer()
                
                Button(action: {
                    EztMainViewModel.shared.paths.append(Router.gotoListDepthEffectView(wallpapers: newestVM.wallpapers))
                }, label: {
                    SeeAllView()
                })
                                
            }
            .frame(height: 36)
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
            
            
            
            ZStack{
                if !newestVM.wallpapers.isEmpty{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 8){
                            Button(action: {
                                EztMainViewModel.shared.paths.append(Router.gotoSpecialWalliveDetailView(currentIndex: 0,
                                                                                                    wallpapers: newestVM.wallpapers))
                                
                            }, label: {
                                WebImage(url: URL(string: newestVM.wallpapers.first?.thumbnail?.path.preview ?? ""))
                                    .resizable()
                                    .placeholder {
                                        placeHolderImage()
                                    }
                                    .scaledToFill()
                                    .frame(width: 160, height: 320)
                                    .clipped()
                                    .cornerRadius(8)
                                    .showCrownIfNeeded(!store.isPro() && newestVM.wallpapers.first?.contentType == 1)
                            })
                            
                            LazyHGrid(rows: [GridItem.init(spacing : 8), GridItem.init()], spacing: 8, content: {
                                ForEach(1..<15, content: {
                                    i in
                              
                                    Button(action: {
                                        EztMainViewModel.shared.paths.append(Router.gotoSpecialWalliveDetailView(currentIndex: i,
                                                                                                            wallpapers: newestVM.wallpapers))
                                        
                                    }, label: {
                                        WebImage(url: URL(string: newestVM.wallpapers[i].thumbnail?.path.preview ?? ""))
                                            .resizable()
                                            .placeholder {
                                                placeHolderImage()
                                            }
                                            .scaledToFill()
                                            .frame(width: 78, height: 156)
                                            .clipped()
                                            .cornerRadius(8)
                                            .showCrownIfNeeded(!store.isPro() && newestVM.wallpapers.first?.contentType == 1)
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
                    ForEach(0..<popularVM.wallpapers.count, id: \.self) { i in
                        let  wallpaper = popularVM.wallpapers[i]
                        let string : String = wallpaper.thumbnail?.path.small ?? ""
                        
                        Button(action: {
                            EztMainViewModel.shared.paths.append(Router.gotoSpecialWalliveDetailView(currentIndex: i,
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
                                .showCrownIfNeeded(!store.isPro() && wallpaper.contentType == 1)
                        })
                        .onAppear(perform: {
                            if i == ( popularVM.wallpapers.count - 6 ){
                                popularVM.getWallpapers()
                            }
                        })
                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
            .padding(.horizontal, 16)
              
            
            
        }
       
    }
    
}

extension View{
    func CategoryPlaceHolder() -> some View{
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing : 8){
                Spacer().frame(width: 8)
                ForEach(0..<5, id: \.self){
                    id  in
                    placeHolderImage()
                    .frame(width: 108, height: 216)
                    .cornerRadius(8)
                }
                Spacer().frame(width: 16)
            }
        }.disabled(true)
    }
}

#Preview {
    EztMainView()
}

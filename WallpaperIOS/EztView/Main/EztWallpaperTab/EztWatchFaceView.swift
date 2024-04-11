//
//  EztWatchFaceView.swift
//  WallpaperIOS
//
//  Created by Duc on 24/11/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct EztWatchFaceView: View {
    
    @StateObject var newestVM : EztWatchFaceViewModel = .init(sort :.NEW)
    @StateObject var popularVM : EztWatchFaceViewModel = .init(sort : .POPULAR, sortByTop: .TOP_MONTH )
    @EnvironmentObject var store : MyStore
    @EnvironmentObject  var reward : RewardAd
    @EnvironmentObject var interAd : InterstitialAdLoader
    
    @Environment(\.presentationMode) var presentationMode
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
                Text("Watch Faces")
                    .foregroundColor(.white)
                    .mfont(22, .bold)
                    .frame(maxWidth: .infinity).padding(.trailing, 18)
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 44)
                .padding(.horizontal, 20)
            
            ScrollView(.vertical, showsIndicators: false){
                LazyVStack(spacing : 0){
                    NewestWatchFace()
                    PopularWatchFace().padding(.top, 24)
                }
                
            }
            .refreshable {
                
            }
            .frame(maxWidth : .infinity, maxHeight : .infinity)
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
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
                        interAd.showAd(onCommit: {})
                    }
                }
            
        
        
      
        
    }
}

extension EztWatchFaceView{
    
    @ViewBuilder
    func NewestWatchFace() -> some View {
        VStack(spacing : 0){
            HStack(spacing : 0){
                Text("Newest".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                
                NavigationLink(destination: {
                    WatchFaceView()
                        .environmentObject(newestVM)
                        .environmentObject(store)
                        .environmentObject(reward)
                        .environmentObject(interAd)
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
                            Spacer().frame(width: 8)
                            ForEach(newestVM.wallpapers.indices, id: \.self){
                                index in
                                
                                let wallpaper = newestVM.wallpapers[index]
                                let string : String = wallpaper.path.first?.path.preview ?? ""
                                NavigationLink(destination: {
                                    WatchFaceDetailView(wallpaper: wallpaper)
                                        .environmentObject(store)
                                        .environmentObject(interAd)
                                        .environmentObject(reward)
                                }, label: {
                                    ZStack{
                                        Color.black
                                        WebImage(url: URL(string: string))
                                            .resizable()
                                            .cornerRadius(24)
                                            .padding(9)
                                    }
                                    .frame(width: 139 , height: 176)
                                    .clipShape(RoundedRectangle(cornerRadius: 30))
                                    .cornerRadius(30)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 30)
                                            .inset(by: 1.5)
                                            .stroke(.white.opacity(0.3), lineWidth: 3)
                                        
                                    )
                                    .overlay(alignment: .topTrailing, content: {
                                        VStack(alignment: .trailing, spacing : 0){
                                            Text("TUE 16")
                                                .mfont(11, .bold, line: 1)
                                                .multilineTextAlignment(.trailing)
                                                .foregroundColor(.white)
                                                .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 1)
                                            
                                            Text("10:09")
                                                .mfont(32, .regular, line: 1)
                                                .multilineTextAlignment(.trailing)
                                                .foregroundColor(.white)
                                                .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 1)
                                                .offset(y : -8)
                                            
                                            
                                        }.padding(.top, 20)
                                            .padding(.trailing , 20)
                                    })
                                })
                                
                            }
                            Spacer().frame(width: 16)
                        }
                    }
                }
                else{
                    
                }
                
                
            } .frame(height: 176)
            
            
            
            
        }
    }
    
    @ViewBuilder
    func PopularWatchFace() -> some View {
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
                        let string : String = wallpaper.path.first?.path.small ?? ""
                        
                        NavigationLink(destination: {
                            WatchFaceDetailView( wallpaper: wallpaper)
                                .environmentObject(store)
                                .environmentObject(interAd)
                                .environmentObject(reward)
                        }, label: {
                            ZStack{
                                Color.black
                                WebImage(url: URL(string: string))
                                    .resizable()
                                    .placeholder {
                                        placeHolderImage()
                                            .frame(width: AppConfig.width_1, height: AppConfig.height_1)
                                    }
                                //  .scaledToFill()
                                    .cornerRadius(30)
                                    .padding(11)
                                
                            }

                            .frame(width: ( getRect().width - 60 ) / 2 , height:( getRect().width - 60 )  * 196  / 2 / 157)
                            .clipShape(RoundedRectangle(cornerRadius: 36))
                            .cornerRadius(36)
                            .overlay(
                                RoundedRectangle(cornerRadius: 36)
                                    .inset(by: 1.5)
                                    .stroke(.white.opacity(0.3), lineWidth: 3)
                                
                            )
                            .overlay(alignment: .topTrailing, content: {
                                VStack(alignment: .trailing, spacing : 0){
                                    Text("TUE 16")
                                        .mfont(11, .bold, line: 1)
                                        .multilineTextAlignment(.trailing)
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 1)
                                    
                                    Text("10:09")
                                        .mfont(32, .regular, line: 1)
                                        .multilineTextAlignment(.trailing)
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 1)
                                        .offset(y : -8)
                                    
                                    
                                }.padding(.top, 28)
                                    .padding(.trailing , 24)
                            })
                            
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


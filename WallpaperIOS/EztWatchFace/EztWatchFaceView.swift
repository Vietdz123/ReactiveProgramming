//
//  EztWatchFaceView.swift
//  WallpaperIOS
//
//  Created by Duc on 24/11/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct EztWatchFaceView: View {
    
    @StateObject var viewModel : EztWatchFaceViewModel = .init()
    @EnvironmentObject var store : MyStore
    @EnvironmentObject  var reward : RewardAd
    @EnvironmentObject var interAd : InterstitialAdLoader
    var body: some View {

        
     
            
       
        ScrollView(.vertical, showsIndicators: false){
         
            LazyVGrid(columns: [GridItem.init(spacing: 20), GridItem.init()], spacing: 20 ){
                
                if !viewModel.wallpapers.isEmpty {
                    ForEach(0..<viewModel.wallpapers.count, id: \.self){
                        i in
                        let  wallpaper = viewModel.wallpapers[i]
                        let string : String = wallpaper.path.first?.path.preview ?? ""
                        
                        NavigationLink(destination: {
                            WatchFaceDetailView(wallpaper: wallpaper)
                                .environmentObject(store)
                                .environmentObject(reward)
                                .environmentObject(interAd)
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
                            if i == ( viewModel.wallpapers.count - 6 ){
                                viewModel.getWallpapers()
                            }
                        })
                    }
                }
            }
            .padding(20)
            
         
            
        }
        .refreshable {
            
        }
      
        .frame(maxWidth : .infinity, maxHeight : .infinity)
        .addBackground()
    }
}


//
//  WatchFaceView.swift
//  WallpaperIOS
//
//  Created by Duc on 27/12/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct WatchFaceView: View {
    @EnvironmentObject var viewModel : EztWatchFaceViewModel
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var reward : RewardAd
    @EnvironmentObject var store : MyStore
 
    @EnvironmentObject var interAd : InterstitialAdLoader
    
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
                Text("Watch Face")
                    .foregroundColor(.white)
                    .mfont(22, .bold)
                    .frame(maxWidth: .infinity).padding(.trailing, 18)
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 44)
                .padding(.horizontal, 20)
            
            ScrollView(.vertical, showsIndicators: false){
                LazyVGrid(columns: [GridItem.init(spacing: 8), GridItem.init()], spacing: 8 ){
                    
                    if !viewModel.wallpapers.isEmpty {
                        ForEach(0..<viewModel.wallpapers.count, id: \.self){
                            i in
                            let  wallpaper = viewModel.wallpapers[i]
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
                                if i == ( viewModel.wallpapers.count - 6 ){
                                    viewModel.getWallpapers()
                                }
                            })
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
                .padding(16)
            }
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
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
                    interAd.showAd(onCommit: {
                        
                    })
                }
            }
           
    }
}

#Preview {
    WatchFaceView()
}

//
//  DownloadSuccessView.swift
//  WallpaperIOS
//
//  Created by Duc on 11/07/2024.
//

import SwiftUI
import SDWebImageSwiftUI
import Lottie
import AVKit


struct DownloadSuccessView: View {
    
    let type : String
    let url : URL?
    var wallpaper : SpWallpaper?
    let onClickBackToHome : () -> ()
    @State var avPlayer : AVPlayer?
    @State var hasAppear : Bool = false
    @State var showRateView : Bool = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var storeVM : MyStore
    @State var currentIndex : Int  = 0
    
    var body: some View {
        VStack(spacing: 0){
            HStack(spacing: 0, content: {
                Button(action: {
                    dismiss.callAsFunction()
                }, label: {
                    Image("back")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                })
                Spacer()
                
                Button(action: {
                    shareLinkApp()
                }, label: {
                    Image("share2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                })
                .padding(.trailing, 24)
                
                Button(action: {
                    onClickBackToHome()
                
                }, label: {
                    Image("hut 1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                })
                
            }).frame(maxWidth: .infinity)
                .frame(height: 44)
                .padding(.horizontal, 16)
            
            
            ScrollView(.vertical, showsIndicators: false ){
                VStack(spacing : 0){
                    Text("Download successful!")
                        .mfont(20, .bold)
                      .multilineTextAlignment(.center)
                      .foregroundStyle(LinearGradient(
                        stops: [
                        Gradient.Stop(color: Color(red: 0.15, green: 0.7, blue: 1), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.46, green: 0.37, blue: 1), location: 0.52),
                        Gradient.Stop(color: Color(red: 0.9, green: 0.2, blue: 0.87), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0, y: 1.38),
                        endPoint: UnitPoint(x: 1, y: -0.22)
                        ) )
                      .padding(.top, 8)
                    
                    ZStack{
                        if type == "Wallpaper" {
                            WebImage(url: url)
                                .resizable()
                                .scaledToFill()
                            .frame(width: 240, height: 480)
                            .clipped()
                            .cornerRadius(16)
                            .padding(.top, 24)
                            .padding(.bottom, 16)
                        }else if type == "WatchFace" {
                            ZStack{
                                Color.black
                                WebImage(url: url)
                                    .resizable()
                                    .cornerRadius(30)
                                    .padding(11)
                                
                            }
                            .frame(width: ( getRect().width - 60 ) / 2 , height:( getRect().width - 60 )  * 196  / 2 / 157)
                            .cornerRadius(36)
                            .overlay(
                                RoundedRectangle(cornerRadius: 36)
                                    .inset(by: 1.5)
                                    .stroke(.white.opacity(0.3), lineWidth: 3)
                                
                            )
                            .overlay(alignment: .bottomTrailing, content: {
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
                                    
                                    
                                }.padding(.bottom, 12)
                                    .padding(.trailing , 22)
                            })
                            .padding(.top, 24)
                            .padding(.bottom, 16)
                        }else if type == "Widget"{
                            ZStack{
                                if let url {
                                    LottieView {
                                        await LottieAnimation.loadedFrom(url: url )
                                    }
                                        .looping()
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: getRect().width - 32, height: ( getRect().width - 32 ) / 2.2 )
                                        .overlay{
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.white.opacity(0.4), lineWidth : 1)
                                        }
                                     
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 16)
                                        )
                                }else{
                                  
                                }
                            }.frame(width: getRect().width - 32, height: ( getRect().width - 32 ) / 2.2 )
                                .padding(.top, 24)
                                .padding(.bottom, 16)
                        }else if type == "LiveWallpaper" {
                            ZStack{
                                if let avPlayer {
                                    MyVideoPlayer(player: avPlayer)
                                }
                            }.frame(width: 240, height: 480, alignment: .center)
                                .cornerRadius(16)
                                .padding(.top, 24)
                                .padding(.bottom, 16)
                                .onAppear(perform: {
                                    if self.avPlayer == nil {
                                        if let url{
                                            self.avPlayer = AVPlayer(url: url)
                                            self.avPlayer?.play()
                                        }
                                        
                                    }
                                })
                                .onDisappear(perform: {
                                    self.avPlayer?.pause()
                                    self.avPlayer = nil
                                })
                                
                        }else if type == "LockScreenTheme" {
                            if let url {
                                if  url.absoluteString.contains(".json"){
                                   
                                      
                                            LottieView {
                                                await LottieAnimation.loadedFrom(url:  url )
                                            } .looping()
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 240, height: 240 * 2.2)
                                                .cornerRadius(16)
                                                .padding(.top, 24)
                                                .padding(.bottom, 16)
                                            
                                       
                                    
                                    
                                }else{
                                    AsyncImage(url: url){
                                        phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 240, height: 240 * 2.2)
                                                .clipped()
                                                .cornerRadius(16)
                                            
                                            
                                        } else if phase.error != nil {
                                            AsyncImage(url: url){
                                                phase in
                                                if let image = phase.image {
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 240, height: 240 * 2.2)
                                                        .clipped()
                                                        .cornerRadius(16)
                                                }
                                            }
                                            
                                        } else {
                                            ResizableLottieView(filename: "placeholder_anim")
                                                .frame(width: 200, height: 200)
                                        }
                                        
                                        
                                    } .padding(.top, 24)
                                        .padding(.bottom, 16)
                                    
                                }
                            }
                        
                        }else if type == "ShufflePack"{
                            if let wallpaper {
                                
                            
                            TabView(selection: $currentIndex){
                                ForEach(0..<wallpaper.path.count, id: \.self) {
                                    i in
                                    let imgStr = wallpaper.path[i].path.preview
                                    
                                    AsyncImage(url: URL(string: imgStr)){
                                        phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 240, height: 480)
                                                .clipped()

                                        } else if phase.error != nil {
                                            AsyncImage(url: URL(string: imgStr)){
                                                phase in
                                                if let image = phase.image {
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 240, height: 480)
                                                        .clipped()
                                                }
                                            }

                                        } else {
                                            ResizableLottieView(filename: "placeholder_anim")
                                                .frame(width: 200, height: 200)
                                        }


                                    }
                                    .frame(width: 240, height: 480)
                                     
                                      
                                    
                                }
                            }
                            .tabViewStyle(.page(indexDisplayMode: .never))
                            .frame(width: 240, height: 480, alignment: .center)
                            .overlay(alignment: .bottom, content: {
                                ZStack{
                                    HStack(spacing : 6){
                                        ForEach(0..<wallpaper.path.count, id: \.self, content: {
                                            i in
                                            Circle()
                                                .foregroundColor(.gray)
                                                .frame(width: 6, height: 6)
                                                .overlay(
                                                    ZStack{
                                                        if i == currentIndex {
                                                            Circle()
                                                                .foregroundColor(.white)
                                                                .frame(width: 6, height: 6)
                                                        }
                                                    }
                                                )
                                        })
                                    }
                                }.frame(height: 36)
                                    .padding(.bottom, 8)
                            })
                            .cornerRadius(16)
                            .padding(.top, 24)
                            .padding(.bottom, 16)
                            }
                            
                        }
                    }
                    if !storeVM.isPro(){
                        NativeAdsCoordinator(width: getRect().width )
                            .frame(width: getRect().width, height: 132)
                    }
                   
                }
            }
            
            
            
                               
          
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .addBackground()
            .overlay{
                if showRateView {
                    EztRateView(onClickSubmit5star: {
                        showRateView = false
                        rateApp()
                    }, onClickNoThanksOrlessthan5: {
                        showRateView = false
                    })
                }
            }
            .onAppear(perform: {
                if hasAppear {
                    return
                }
                
                hasAppear = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    showActionAfterDownload(isUserPro: storeVM.isPro(), onShowRate: {
                        showRateView = true
                    }, onShowGifView: {
                       
                    })
                })
            })
    }
    
    func shareLinkApp(){
        guard let url = URL(string: "https://apps.apple.com/vn/app/wallive-live-wallpaper-maker/id6449699978") else{
            return
        }
        shareLink(url: url)
        
        
    }
    
    func shareLink(url: URL) {
          let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
          getRootViewController().present(activityViewController, animated: true, completion: nil)
       }
    
}

#Preview {
    DownloadSuccessView(type: "Wallpaper", url: URL(string: ""), onClickBackToHome: {
        
    })
    .environmentObject(MyStore())
}

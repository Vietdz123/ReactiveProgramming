//
//  WatchFaceDetailView.swift
//  WallpaperIOS
//
//  Created by Duc on 24/11/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct WatchFaceDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var store : MyStore = .shared
    
  //  @ObservedObject private var nativeAdViewModel = NativeAdViewModel.shared
    
    
    let wallpaper : SpWallpaper
  //  @State var showBuySubAtScreen : Bool = false
    @State var showSub : Bool = false
    @StateObject var ctrlViewModel : ControllViewModel = .init()
    @State var showTuto : Bool = false
    @State var showDialogReward : Bool = false
    
    @State var adStatus : AdStatus = .loading
    
    
    @State var type : String = "WatchFace"
    @State var urlForDownloadSuccess :  URL?
    @State var navigateToDownloadSuccessView : Bool = false
    
    
    var body: some View {
        
        
        ZStack(alignment: .bottom){
            
            
            
                 NavigationLink(isActive: $navigateToDownloadSuccessView, destination: {
                     DownloadSuccessView(type: type, url: urlForDownloadSuccess, onClickBackToHome: {
                         navigateToDownloadSuccessView = false
                         DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                             presentationMode.wrappedValue.dismiss()
                         })
                        
                     }).environmentObject(store)
                 }, label: {
                     EmptyView()
                 })
             
            
            VStack(spacing : 0){
                HStack(spacing : 0){
                    Image("menu")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24, alignment: .center)
                        .frame(width: 48, height: 48, alignment: .center)
                        .containerShape(Rectangle())
                    Spacer()
                    Text("Watch Face".toLocalize())
                        .mfont(20, .bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.main)
                    Spacer()
                    Image("search")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24, alignment: .center)
                        .frame(width: 48, height: 48, alignment: .center)
                }.frame(maxWidth: .infinity)
                    .frame(height: 48)
                Spacer()
                
            }
            
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .ignoresSafeArea()
                .opacity(0.9)
            
            VStack(spacing : 0){
             
                HStack{
                    Button(action: {
                        shareLinkApp()
                    }, label: {
                        Image("share2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                    })
                    if !store.isPro()  && wallpaper.contentType == 1  {
                        Image("crown")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .center)
                            .frame(width: 56, height: 24)
                    }
                    
                    Spacer()
             
                 
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image("close.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                    })
                }.padding(.horizontal, 16)
                    .overlay(
                        Text("Preview".toLocalize())
                            .mfont(17, .bold)
                          .multilineTextAlignment(.center)
                          .foregroundColor(.white)
                    )
                
                
                GeometryReader{
                    proxy in
                    
                    ZStack{
                        WebImage(url: URL(string:  wallpaper.path.first?.path.full ?? ""))
                            .resizable()
                            .placeholder {
                                placeHolderImage()
                            }
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight : .infinity)
                            .overlay(alignment: .trailing){
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
                                    
                                    
                                }.padding(.trailing, 8)
                                    .padding(.top, 76)
                            }
                            .padding(.leading, 14)
                            .padding(.trailing, 21)
                        Image("watchface_mockup")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight : .infinity)
                    }
                    
                   
                }.frame(width: 163, height: 276)
                    .padding(.vertical, 24)

               
            
                
                Button(action: {
                    if store.isPro(){
                        downloadImageToGallery(title: "Watch_\(wallpaper.id)", urlStr: wallpaper.path.first?.path.full ?? "")
                        ServerHelper.sendImageSpecialDataToServer(type: "download", id: wallpaper.id)
                    }else{
                        DispatchQueue.main.async {
                            withAnimation(.easeInOut){
                                if wallpaper.contentType == 1 {
                                  // showBuySubAtScreen.toggle()
                                    showSub.toggle()
                            }else{
                                    showDialogReward.toggle()
                               }
                            }
                        }
                        
                     
                    }
                  
                    
                    
                   
                }, label: {
                    Text("Save".toLocalize())
                        .mfont(16, .bold)
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                      .frame(width: 240, height: 48)
                      .background(
                        Capsule()
                            .fill(Color.main)
                      )
                })
                .padding(.bottom, store.allowShowBanner() ? 24 : 40)
                
                if store.allowShowBanner(){
                    BannerAdViewMain(adStatus: $adStatus)
                        .padding(.bottom, getSafeArea().bottom)
                }
                
                
            }.padding(EdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 0))
                .background(
                    Image( (!store.isPro() && UserDefaults.standard.bool(forKey: "allow_show_native_ads")) ? "bg_watchface2" : "bg_watchface")
                        .resizable()
                        .scaledToFill()
                        .scaleEffect(1.1)
                        .clipped()
                )
                .cornerRadius(16)
            

            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .addBackground()
        .overlay{
            if showDialogReward{
                DialogWatchRewardForWatchFace(urlStr: wallpaper.path.first?.path.full ?? "", show: $showDialogReward, onRewarded: {
                    b in
                    showDialogReward = false
                    if b {
                        downloadImageToGallery(title: "Watch_\(wallpaper.id)", urlStr: wallpaper.path.first?.path.full ?? "")
                        ServerHelper.sendImageSpecialDataToServer(type: "download", id: wallpaper.id)
                    }else{
                        showToastWithContent(image: "xmark", color: .red, mess: "Ads not alaivable!")
                    }
                }, clickBuyPro: {
                    showDialogReward = false
                    showSub.toggle()
                })
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear(perform: {
            if !store.isPro(){
                InterstitialAdLoader.shared.showAd {
                    
                }
            }
        })
        .overlay{
                   if ctrlViewModel.showRateView {
                       EztRateView(onClickSubmit5star: {
                           ctrlViewModel.showRateView = false
                           rateApp()
                       }, onClickNoThanksOrlessthan5: {
                           ctrlViewModel.showRateView = false
                       })
                   }
               }
        .fullScreenCover(isPresented: $showSub, content: {
            EztSubcriptionView()
        })
        .fullScreenCover(isPresented: $showTuto, content: {
            WatchFaceTutorialView()
        })
        
     
       
    }
    
    func downloadImageToGallery(title : String, urlStr : String){
        ctrlViewModel.isDownloading = true
        
        DownloadFileHelper.downloadFromUrlToSanbox(fileName: title, urlImage: URL(string: urlStr), onCompleted: {
            url in
            if let url {
                DownloadFileHelper.saveImageToLibFromURLSanbox(url: url, onComplete: {
                    success in
                    if success{
                        ctrlViewModel.isDownloading = false
                        showToastWithContent(image: "checkmark", color: .green, mess: "Saved to gallery!")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            let urlPreview = urlStr
                            self.urlForDownloadSuccess = URL(string: urlPreview)
                            self.navigateToDownloadSuccessView = true
                        })
                        
                     
                    }else{
                        ctrlViewModel.isDownloading = false
                        showToastWithContent(image: "xmark", color: .red, mess: "Download Failure!")
                    }
                })
            }
            else{
                ctrlViewModel.isDownloading = false
                showToastWithContent(image: "xmark", color: .red, mess: "Download Failure!")
            }
        })
        
     
        
    }
}


struct DialogWatchRewardForWatchFace : View {
    @State var isAnimating : Bool = false
    let urlStr : String
    @Binding var show : Bool
    let width : CGFloat = UIScreen.main.bounds.width - 56
   
    @EnvironmentObject var reward : RewardAd
    @EnvironmentObject var store : MyStore
    var onRewarded :  (Bool) -> ()
    var clickBuyPro : () -> ()
    
    var body: some View {
        ZStack{
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                   
                    withAnimation{
                       
                        show.toggle()
                    }
                }
            VStack(spacing : 0){
                HStack{
                    Spacer()
                    Button(action: {
                        
                        withAnimation{
                            show.toggle()
                        }
                        
                    }, label: {
                        Image("close.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                    })
                    .padding(.all, 8)
                }
               
                GeometryReader{
                    proxy in
                    
                    ZStack{
                        WebImage(url: URL(string:  urlStr))
                            .resizable()
                            .placeholder {
                                placeHolderImage()
                            }
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight : .infinity)
                            .overlay(alignment: .trailing){
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
                                    
                                    
                                }.padding(.trailing, 8)
                                    .padding(.bottom, 72)
                            }
                            .padding(.leading, 14)
                            .padding(.trailing, 21)
                        Image("watchface_mockup")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight : .infinity)
                    }
                    
                   
                }.frame(width: 163, height: 276)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
                
               
                
                Button(action: {
                    
                    reward.presentRewardedVideo(onCommit: onRewarded)
                   
                }, label: {
                    HStack{
                        VStack(spacing : 0){
                            Image("play")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 26.67, height: 26.67)
                        }
                       
                        
                        VStack{
                            Text("Watch a short video")
                                .mfont(17, .bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                          
                            Text("to save this widget")
                                .mfont(13, .regular)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }.frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 14.67)
                          
                      
                       
                    }.frame(maxWidth: .infinity)
                        .padding(EdgeInsets(top: 0, leading: 26.67, bottom: 0, trailing: 0))
                        .frame(height: 56)
                        .background(
                            ZStack{
                                VisualEffectView(effect: UIBlurEffect(style: .dark))
                                    .clipShape(Capsule())
//                                    Capsule()
//                                        .fill(Color.black.opacity(0.4))
                                Capsule()
                                 .stroke(Color.white, lineWidth: 1)
                            }
                          
                        )
                        .padding(.horizontal, 20)
                })
                .padding(.top, 16)
                
                
                Button(action: {
                    
                    clickBuyPro()
                }, label: {
                    HStack{
                        
                        ResizableLottieView(filename: "star")
                            .frame(width: 32, height: 32)
                        
                        Text("Unlock all Features")
                            .mfont(16, .bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 14.67)
                        
                        
                        
                    }.frame(maxWidth: .infinity)
                        .padding(EdgeInsets(top: 0, leading: 26.67, bottom: 0, trailing: 0))
                        .frame(height: 56)
                        .background(
                            ZStack{
                               
                                LinearGradient(gradient: Gradient(colors:[  Color.colorOrange , Color.main]),
                                               startPoint: isAnimating ? .trailing : .leading,
                                               endPoint: .leading)
                                .frame(height: 56)
                            
                                .onAppear() {
                                    DispatchQueue.main.async{
                                        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)){
                                            isAnimating.toggle()
                                        }
                                    }
                                }
                            }.frame(height: 56)
                                .clipShape(Capsule())
                        )
                        .padding(.horizontal, 20)
                })   .padding(.top, 16)
                    .padding(.bottom, 32)
                
            }
            .frame(width: width)
            .background(
                ZStack{
                    
                        Color(red: 0.13, green: 0.14, blue: 0.13).opacity(0.7)
                   
                        Image("bg_watchface")
                            .resizable()
                            .scaledToFill()
                            .scaleEffect(1.3)
                            .offset(y : -56)
                      
                   
                       
                            
                            
                    
                }
               
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))

            
            
            
            
        }
    }
}

#Preview(body: {
    ZStack{
        ZStack{
            Color.blue.ignoresSafeArea()
            DialogWatchRewardForWatchFace(urlStr: "", show: .constant(true), onRewarded: {_ in
                
            }, clickBuyPro: {
                
            })
            
        }
    }
})


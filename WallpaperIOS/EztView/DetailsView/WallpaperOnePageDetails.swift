//
//  WallpaperDetails.swift
//  WallpaperIOS
//
//  Created by Mac on 04/05/2023.
//

import SwiftUI
import PhotosUI
import SDWebImageSwiftUI

struct WallpaperOnePageDetails: View {
    @StateObject var ctrlViewModel : ControllViewModel = .init()
    @EnvironmentObject  var reward : RewardAd
    @EnvironmentObject var inter : InterstitialAdLoader
    @EnvironmentObject var store : MyStore

    @AppStorage("current_coin", store: .standard) var currentCoin : Int = 0
    @AppStorage("exclusive_cost", store: .standard) var exclusiveCost : Int = 4
    @Environment(\.dismiss) var dismiss
    let wallpapers : [Wallpaper]
    
    
    @State var index : Int
    
    
    var body: some View {
        ZStack(alignment: .top){
            
            NavigationLink(destination:
                            EztSubcriptionView().environmentObject(store)
                           , isActive: $ctrlViewModel.navigateView, label: {
                EmptyView()
            })
            
            TabView(selection: $index, content: {
                ForEach(0..<wallpapers.count, id: \.self){ i in
                    let wallpaper = wallpapers[i]
                    AsyncImage(url: URL(string: (wallpaper.variations.adapted.url).replacingOccurrences(of: "\"", with: ""))){
                        phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: getRect().width, height: getRect().height)
                                .clipped()
                            
                        } else if phase.error != nil {
                            AsyncImage(url: URL(string: (wallpaper.variations.adapted.url).replacingOccurrences(of: "\"", with: ""))){
                                phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: getRect().width, height: getRect().height)
                                        .clipped()
                                }
                            }
                            
                        } else {
                            ResizableLottieView(filename: "placeholder_anim")
                                .frame(width: 200, height: 200)
                        }
                        
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    
                    .onAppear(perform: {
                      
                        if !store.isPro(){
                            inter.showAd(onCommit: {})
                        }
                        
                    })
                }
            })
            .background(
                Image("BGIMG")
                    .resizable()
                    .ignoresSafeArea()
            )
            .tabViewStyle(.page(indexDisplayMode: .never))
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                withAnimation{
                    ctrlViewModel.showControll.toggle()
                }
            }
            
            

            if ctrlViewModel.showControll{
                ControllView()
            }
            
            if ctrlViewModel.showPreview {
                Preview()
            }
            
            if ctrlViewModel.showDialogRV{
           
                   DialogGetWL(urlStr: wallpapers[index].variations.preview_small.url.replacingOccurrences(of: "\"", with: ""))

                
            }
            
            if ctrlViewModel.showDialogBuyCoin{

                SpecialSubView(onClickClose: {
                    ctrlViewModel.showDialogBuyCoin = false
                })
               
            }
           
            
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .addBackground()
        .overlay{
            if ctrlViewModel.showGifView{
                GiftView()
            }
        }
        .overlay(
            ZStack{
                if ctrlViewModel.showContentPremium {
                    let url  = (wallpapers[index].variations.adapted.url).replacingOccurrences(of: "\"", with: "")
                        SpecialContentPremiumDialog(show: $ctrlViewModel.showContentPremium, urlStr: url, onClickBuyPro: {
                            ctrlViewModel.showContentPremium = false
                            ctrlViewModel.showDialogBuyCoin = true
                        })
                }
            }

        )

    }
    
    
    @ViewBuilder
    func GiftView(giftSubType : Int = UserDefaults.standard.integer(forKey: "gift_sub_type")  ) -> some View{
        if giftSubType == 0 {
           GiftSub_1_View(show: $ctrlViewModel.showGifView)
        }else if giftSubType == 1{
            GiftSub_2_View(show: $ctrlViewModel.showGifView)
        }else{
            GifSub_3_View(show: $ctrlViewModel.showGifView)
        }
    }
    
    @ViewBuilder
    func ControllView() -> some View{
        VStack(spacing : 0){
            HStack(spacing : 0){
                Button(action: {
                    dismiss.callAsFunction()
                }, label: {
                    Image("back")
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .frame(width: 64, height: 44)
                        .contentShape(Rectangle())
                })
               
                
                Spacer()

               
                    HStack(spacing : 0){
                        ZStack{
                            if !store.isPro() && wallpapers[index].content_type == "private" {
                                Button(action: {
                                    ctrlViewModel.showContentPremium = true
                                }, label: {
                                    Image("crown")
                                        .resizable()
                                        .frame(width: 18, height: 18, alignment: .center)
                                        .frame(width: 50, height: 44)
                                })
                               

                            }
                            
                        }
                        
                        Button(action: {
                            ctrlViewModel.showPreview.toggle()
                            ctrlViewModel.showControll.toggle()
                        }, label: {
                            Image("preview")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                                .padding(.trailing, 16)
                                .padding(.leading, 8)
                        })
                        
                    }
                

//              
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44 )
           
         
           
            

            
            Spacer()
            
           
        
                  
                
                
                Button(action: {
                    getPhotoPermission(status: {
                        b in
                        if b{
                            if store.isPro()   {
                                downloadImageToGallery(title: "image\(wallpapers[index].id)", urlStr: (wallpapers[index].variations.adapted.url).replacingOccurrences(of: "\"", with: ""))
                                ServerHelper.sendImageDataToServer(type: "set", id: wallpapers[index].id)
                                
                            }else{
                           
                                if wallpapers[index].content_type == "free" {
                                    
                                    if  UserDefaults.standard.bool(forKey: "allow_download_free") == true {
                                        downloadImageToGallery(title: "image\(wallpapers[index].id)", urlStr: (wallpapers[index].variations.adapted.url).replacingOccurrences(of: "\"", with: ""))
                                        ServerHelper.sendImageDataToServer(type: "set", id: wallpapers[index].id)
                                    }else{
                                        
                                        DispatchQueue.main.async {
                                            withAnimation{
                                                ctrlViewModel.showDialogRV.toggle()
                                            }
                                        }
                                    }
                                   
                                }else{
                                    DispatchQueue.main.async {
                                        withAnimation{
                                            ctrlViewModel.showDialogBuyCoin.toggle()
                                        }
                                    }
                                    
                                }
                            }
                        }
                    })
                    
                 
                 
                    
                   
                
                    
                 
                }, label: {
                    HStack{
                   
                        
                        Text("Save")
                            .mfont(16, .bold)
                            .foregroundColor(.mblack_fg)
                            .overlay(
                                ZStack{
                                    if ctrlViewModel.isDownloading{
                                        EZProgressView()
                                    }
                                }.offset(x : -36)
                                , alignment: .leading
                            )
                    }.frame(width : 240, height: 48)
                    
                        .contentShape(Rectangle())
                        .background(
                            Capsule().fill(Color.main)
                        )
                })
                .disabled(ctrlViewModel.isDownloading)
                .padding(.bottom, 48)
                
                
             
        
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
       
    }
    
    @ViewBuilder
    func Preview() -> some View{
        TabView(selection: $ctrlViewModel.isHome){

            Image("preview_lock")
                .resizable()
                .scaledToFill()
               
                .onTapGesture {
                    withAnimation{
                        ctrlViewModel.showPreview = false
                        
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        withAnimation{
                            ctrlViewModel.showControll = true
                        }
                    })
                }.tag(true)
            
            
            Image("preview_home")
                .resizable()
                .scaledToFill()
                .onTapGesture {
                    withAnimation{
                        ctrlViewModel.showPreview = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        withAnimation{
                            ctrlViewModel.showControll = true
                        }
                    })
                }.tag(false)
            
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .clipped()
        
       
    }
    
    @ViewBuilder
    func DialogGetWL(urlStr : String) -> some View{
        WatchRVtoGetWLDialog( urlStr: urlStr, show: $ctrlViewModel.showDialogRV, onRewarded: {
            rewardSuccess in
            ctrlViewModel.showDialogRV = false
            if rewardSuccess {
                DispatchQueue.main.async{
                    downloadImageToGallery(title: "image\(wallpapers[index].id)", urlStr: (wallpapers[index].variations.adapted.url).replacingOccurrences(of: "\"", with: ""))
                    ServerHelper.sendImageDataToServer(type: "set", id: wallpapers[index].id)
                }
                
            }else{
                DispatchQueue.main.async{
                    showToastWithContent(image: "xmark", color: .red, mess: "Ads is not ready!")
                }
            }
        }, clickBuyPro: {
            ctrlViewModel.showDialogRV.toggle()
            ctrlViewModel.navigateView.toggle()
        }).environmentObject(reward)
            .environmentObject(store)
    }
    
//    @ViewBuilder
//    func DialogGetWLByCoin(urlStr : String) -> some View{
//        BuyWithCoinDialog(urlStr: urlStr, coin: exclusiveCost,show: $ctrlViewModel.showDialogBuyCoin, onBuyWithCoin: {
//            ctrlViewModel.showDialogBuyCoin.toggle()
//            if currentCoin >= exclusiveCost{
//                currentCoin = currentCoin - exclusiveCost
//                DispatchQueue.main.async{
//                    downloadImageToGallery(title: "image\(wallpaper.id)", urlStr: (wallpaper.variations.adapted.url).replacingOccurrences(of: "\"", with: ""))
//                 
//                    ServerHelper.sendImageDataToServer(type: "set", id: wallpaper.id)
//                }
//            }else{
//                showToastWithContent(image: "xmark", color: .red, mess: "Not enough coins!")
//            }
//        }, onBuyPro: {
//            ctrlViewModel.showDialogBuyCoin.toggle()
//            ctrlViewModel.navigateView.toggle()
//        }).environmentObject(store)
//            .environmentObject(reward)
//    }
    
    
    func downloadImageToGallery(title : String, urlStr : String){
        DispatchQueue.main.async {
            ctrlViewModel.isDownloading = true
        }
        
        
        DownloadFileHelper.downloadFromUrlToSanbox(fileName: title, urlImage: URL(string: urlStr), onCompleted: {
            url in
            if let url{
                DownloadFileHelper.saveImageToLibFromURLSanbox(url: url, onComplete: {
                    success in
                    if success{
                        ctrlViewModel.isDownloading = false
                        showToastWithContent(image: "checkmark", color: .green, mess: "Saved to gallery!")
                        
//                        if UserDefaults.standard.bool(forKey: "firsttime_showtuto") == false {
//                            UserDefaults.standard.set(true, forKey: "firsttime_showtuto")
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//                                ctrlViewModel.showTutorial = true
//                            })
//                        }
                        
                        let downloadCount = UserDefaults.standard.integer(forKey: "user_download_count")
                        UserDefaults.standard.set(downloadCount + 1, forKey: "user_download_count")
                        
                        if downloadCount == 1 {
                            showRateView()
                        }else{
                            if !store.isPro()  {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                                    ctrlViewModel.showGifView.toggle()
                                    ctrlViewModel.changeSubType()
                                })
                             }
                        }
                        
                    }else{
                        ctrlViewModel.isDownloading = false
                        showToastWithContent(image: "xmark", color: .red, mess: "Download Failure")
                    }
                })
                
            }else{
                ctrlViewModel.isDownloading = false
                showToastWithContent(image: "xmark", color: .red, mess: "Download Failure")
            }
        })
      
        

    }
  
   
}


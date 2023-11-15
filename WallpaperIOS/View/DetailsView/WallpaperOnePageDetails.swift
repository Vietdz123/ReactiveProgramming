//
//  WallpaperDetails.swift
//  WallpaperIOS
//
//  Created by Mac on 04/05/2023.
//

import SwiftUI
import PhotosUI

struct WallpaperOnePageDetails: View {
    @StateObject var ctrlViewModel : ControllViewModel = .init()
    @EnvironmentObject  var reward : RewardAd
    @EnvironmentObject var inter : InterstitialAdLoader
    @EnvironmentObject var store : MyStore
    @EnvironmentObject var favViewModel : FavoriteViewModel
    @AppStorage("current_coin", store: .standard) var currentCoin : Int = 0
    @AppStorage("exclusive_cost", store: .standard) var exclusiveCost : Int = 4
    @Environment(\.dismiss) var dismiss
    let wallpaper : Wallpaper
    var body: some View {
        ZStack(alignment: .top){
            
            NavigationLink(destination:
                            EztSubcriptionView().environmentObject(store)
                           , isActive: $ctrlViewModel.navigateView, label: {
                EmptyView()
            })
            
            AsyncImage(url: URL(string: (wallpaper.variations.adapted.url).replacingOccurrences(of: "\"", with: ""))){
                phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight : .infinity)
                       // .frame(width: getRect().width, height: getRect().height)
                        .clipped()

                } else if phase.error != nil {
                    AsyncImage(url: URL(string: (wallpaper.variations.adapted.url).replacingOccurrences(of: "\"", with: ""))){
                        phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight : .infinity)
                                //.frame(width: getRect().width, height: getRect().height)
                                .clipped()
                        }
                    }
                    
                } else {
                    ResizableLottieView(filename: "placeholder_anim")
                        .frame(width: 80, height: 80)
                }


            }
           // .frame(width: getRect().width, height: getRect().height)
            .frame(maxWidth: .infinity, maxHeight : .infinity)
            .ignoresSafeArea()
            .onTapGesture {
                ctrlViewModel.showControll.toggle()
            }
            
            if ctrlViewModel.showControll{
                ControllView()
            }
            
            if ctrlViewModel.showPreview {
                Preview()
            }
            
            if ctrlViewModel.showDialogRV{
              //  if let urlStr = wallpaper.variations.preview_small.url.replacingOccurrences(of: "\"", with: ""){
                   DialogGetWL(urlStr: wallpaper.variations.preview_small.url.replacingOccurrences(of: "\"", with: ""))
             //   }
                
            }
            
            if ctrlViewModel.showDialogBuyCoin{
                //if let urlStr = wallpaper.variations.preview_small.url.replacingOccurrences(of: "\"", with: ""){
                 // DialogGetWLByCoin(urlStr: wallpaper.variations.preview_small.url.replacingOccurrences(of: "\"", with: ""))
                //}
                SpecialSubView(onClickClose: {
                    ctrlViewModel.showDialogBuyCoin = false
                })
               
            }
           
            
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .addBackground()
        .overlay(
            ZStack(alignment: .bottom){
                if ctrlViewModel.showInfo {
               
                        Color.black.opacity(0.5).ignoresSafeArea()
                            .onTapGesture {
                                ctrlViewModel.showInfo = false
                            }
                        
                        VStack(spacing : 8){
                            Text("Tag: \(getTag(wl:wallpaper))")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("Author: \(wallpaper.author ?? "Unknow")")
                                .foregroundColor(.white)
                                .mfont(16, .regular)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Liscense: \(wallpaper.license ?? "Unknow")")
                                .foregroundColor(.white)
                                .mfont(16, .regular)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }.padding(EdgeInsets(top: 24, leading: 16, bottom: 24, trailing: 16))
                            .overlay(
                                Button(action: {
                                    ctrlViewModel.showInfo = false
                                    
                                }, label: {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width : 14, height: 14)
                                        .padding(12)
                                    
                                }), alignment: .topTrailing
                            )
                            .background(
                                Color.mblack_bg
                                    .opacity(0.9)
                            )
                            .cornerRadius(16)
                            .padding()
                    }
                
            }
        
        )
        .overlay(
            ZStack{
                if ctrlViewModel.showContentPremium {
                    let url  = (wallpaper.variations.adapted.url).replacingOccurrences(of: "\"", with: "")
                        SpecialContentPremiumDialog(show: $ctrlViewModel.showContentPremium, urlStr: url, onClickBuyPro: {
                            ctrlViewModel.showContentPremium = false
                            ctrlViewModel.showDialogBuyCoin = true
                        })
                }
            }

        )
         .sheet(isPresented: $ctrlViewModel.showTutorial, content: {
             TutorialContentView()
         })
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

                ZStack{
                    if !store.isPro() && wallpaper.content_type == "private" {
                       
                        Button(action: {
                            ctrlViewModel.showContentPremium = true
                        }, label: {
                            Image("crown")
                                .resizable()
                                .frame(width: 18, height: 18, alignment: .center)
                                .frame(width: 34, height: 40)
                        })

                    }
                    
                    
                  
                }
                
                
                Button(action: {
                    ctrlViewModel.showInfo.toggle()
                }, label: {
                    Image( "info")
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .frame(width: 40, height: 40)
                        .contentShape(Rectangle())
                }).padding(.leading, 8)
                
                Button(action: {
                    ctrlViewModel.showTutorial.toggle()
                }, label: {
                    Image( "help")
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .frame(width: 40, height: 40)
                        .contentShape(Rectangle())
                }).padding(.trailing, 12)
              
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44 )
           
         
           
            

            
            Spacer()
            
            HStack{
                Button(action: {
                   
                    if !favViewModel.isFavorite(id: wallpaper.id) {
                      
                        favViewModel.addFavoriteWLToCoreData(id: wallpaper.id ,
                                                             preview_url: wallpaper.variations.preview_small.url.replacingOccurrences(of: "\"", with: ""),
                                                             url: wallpaper.variations.adapted.url.replacingOccurrences(of: "\"", with: ""),
                                                             type:  "image",
                                                             contentType: wallpaper.content_type,
                                                             cost: wallpaper.cost ?? 0)
                        ServerHelper.sendImageDataToServer(type: "favorite", id: wallpaper.id)
                    }else{
                        favViewModel.deleteFavWL(id: wallpaper.id)
                    }
                    
                    
                }, label: {
                    Image( favViewModel.isFavorite(id: wallpaper.id) ? "heart.fill" : "heart")
                        .resizable()
                        .foregroundColor(.white)
                        .aspectRatio( contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .frame(width: 48, height: 48)
                        .background(
                            Circle()
                                .fill(Color.mblack_bg.opacity(0.7))
                                .frame(width: 48, height: 48)
                        )
                        .containerShape(Circle())
                }) .frame(width: 48, height: 48)
                  
                
                
                Button(action: {
                    getPhotoPermission(status: {
                        b in
                        if b{
                            if store.isPro(){
                                downloadImageToGallery(title: "image\(wallpaper.id)", urlStr: (wallpaper.variations.adapted.url).replacingOccurrences(of: "\"", with: ""))
                                ServerHelper.sendImageDataToServer(type: "set", id: wallpaper.id)
                                
                            }else{
                           
                                if wallpaper.content_type == "free" {
                                    DispatchQueue.main.async {
                                        withAnimation{
                                            ctrlViewModel.showDialogRV.toggle()
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
                    }
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                    
                        .contentShape(Rectangle())
                        .background(
                            Capsule().fill(Color.main)
                        )
                }).padding(.horizontal, 16)
                
                
                Button(action: {
                    withAnimation{
                        ctrlViewModel.showControll = false
                        ctrlViewModel.showPreview = true
                    }
                }, label: {
                    Image("preview")
                        .resizable()
                        .foregroundColor(.white)
                        .aspectRatio( contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .frame(width: 48, height: 48)
                        .background(
                            Circle()
                                .fill(Color.mblack_bg.opacity(0.7))
                                .frame(width: 48, height: 48)
                        )
                }) .frame(width: 48, height: 48)
                    .containerShape(Circle())
            }
            .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .padding(.bottom, 40)
        }
        
       
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
        .background{
            Color.clear
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func DialogGetWL(urlStr : String) -> some View{
        WatchRVtoGetWLDialog( urlStr: urlStr, show: $ctrlViewModel.showDialogRV, onRewarded: {
            rewardSuccess in
            ctrlViewModel.showDialogRV = false
            if rewardSuccess {
                DispatchQueue.main.async{
                    downloadImageToGallery(title: "image\(wallpaper.id)", urlStr: (wallpaper.variations.adapted.url).replacingOccurrences(of: "\"", with: ""))
                    ServerHelper.sendImageDataToServer(type: "set", id: wallpaper.id)
                }
                
            }else{
                showToastWithContent(image: "xmark", color: .red, mess: "Ads is not ready!")
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
                        
                        if UserDefaults.standard.bool(forKey: "firsttime_showtuto") == false {
                            UserDefaults.standard.set(true, forKey: "firsttime_showtuto")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                ctrlViewModel.showTutorial = true
                            })
                        }
                        
                        let downloadCount = UserDefaults.standard.integer(forKey: "user_download_count")
                        UserDefaults.standard.set(downloadCount + 1, forKey: "user_download_count")
                        if !store.isPro() && downloadCount == 1 {
                            ctrlViewModel.navigateView.toggle()
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


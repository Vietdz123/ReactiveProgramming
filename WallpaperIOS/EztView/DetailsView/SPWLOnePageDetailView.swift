//
//  SPWLOnePageDetailView.swift
//  WallpaperIOS
//
//  Created by Duc on 02/11/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct SPWLOnePageDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    let wallpaper : SpWallpaper
    
    @StateObject var ctrlViewModel : ControllViewModel = .init()
    
    @EnvironmentObject  var reward : RewardAd
    @EnvironmentObject var store : MyStore

    @EnvironmentObject var interAd : InterstitialAdLoader
    @AppStorage("current_coin", store: .standard) var currentCoin : Int = 0
    @AppStorage("exclusive_cost", store: .standard) var exclusiveCost : Int = 4
    
    
    @State var showBuySubAtScreen : Bool = false
    @State var isBuySubWeek : Bool = true
    @State var showMore : Bool = false
    @State var showContentPremium : Bool = false
    @State var showSub : Bool = false
    @State var showDialogRv : Bool = false
    
    var body: some View {
        
        
        ZStack(alignment: .top){
            
            
            NavigationLink(isActive: $ctrlViewModel.navigateView, destination: {
                EztSubcriptionView()
                    .environmentObject(store)
                    .navigationBarTitle("", displayMode: .inline)
                    .navigationBarHidden(true)
            }, label: {
                EmptyView()
            })
            
            
            //            AsyncImage(url: URL(string: wallpaper.thumbnail?.path.preview ?? ( wallpaper.path.first?.path.preview ?? ""  ))){
            //                phase in
            //                if let image = phase.image {
            //                    image
            //                        .resizable()
            //
            //                        .scaledToFill()
            //                        .frame(maxWidth : .infinity, maxHeight : .infinity)
            //                        .clipped()
            //
            //
            //                } else if phase.error != nil {
            //                    AsyncImage(url: URL(string: wallpaper.path.first?.path.full ?? "")){
            //                        phase in
            //                        if let image = phase.image {
            //                            image
            //                                .resizable()
            //                                .scaledToFill()
            //                                .frame(maxWidth : .infinity, maxHeight : .infinity)
            //                                .clipped()
            //
            //                        }
            //                    }
            //
            //                } else {
            //                    ResizableLottieView(filename: "placeholder_anim")
            //                        .frame(width: 200, height: 200)
            //                }
            //
            //
            //            }.frame(maxWidth : .infinity, maxHeight : .infinity)
            //                .ignoresSafeArea()
            //            .overlay(
            //                ZStack{
            //                    if wallpaper.specialContentV2ID == 3{
            //                        Image("dynamic")
            //                            .resizable()
            //
            //                    }
            //
            //
            //
            //                }
            //            )
            
            
            
            
            
            
            
            
            if ctrlViewModel.showControll{
                ControllView()
                
            }
            
            
            if showBuySubAtScreen {
                SpecialSubView( onClickClose: {
                    showBuySubAtScreen = false
                })
                .environmentObject(store)
                
            }
            
            
            if showDialogRv {
                let url  = wallpaper.path.first?.path.small ?? wallpaper.path.first?.path.preview ?? ""
                    WatchRVtoGetWLDialog( urlStr: url, show: $showDialogRv ,onRewarded: {
                        b in
                        showDialogRv = false
                        if b {
                            
                            downloadImageToGallery(title: "image\(wallpaper.id)", urlStr: (wallpaper.path.first?.path.full ?? ""))
                            ServerHelper.sendImageSpecialDataToServer(type: "download", id: wallpaper.id)
                        }else{
                            showToastWithContent(image: "xmark", color: .red, mess: "Ads not alaivable!")
                        }
                        
                    }, clickBuyPro: {
                        showDialogRv = false
                        showSub.toggle()
                    })
                
            }
            
        }
        .background(
            
            
            WebImage(url: URL(string: wallpaper.thumbnail?.path.preview ?? ( wallpaper.path.first?.path.preview ?? ""  )))
            
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .clipped()
            
            
                .overlay(
                    ZStack{
                        if wallpaper.specialContentV2ID == 3{
                            Image("dynamic")
                                .resizable()
                            
                        }
                        
                        
                        
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            
            
            
        )
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)

        .overlay(
            ZStack{
                if showContentPremium {
                    let url  = wallpaper.path.first?.path.small ?? wallpaper.path.first?.path.preview ?? ""
                    SpecialContentPremiumDialog(show: $showContentPremium, urlStr: url, onClickBuyPro: {
                        showContentPremium = false
                        showSub.toggle()
                    })
                }
            }
            
        )
        .fullScreenCover(isPresented: $showSub, content: {
            EztSubcriptionView()
                .environmentObject(store)
        })
//        .sheet(isPresented: $ctrlViewModel.showTutorial, content: {
//            TutorialContentView()
//        })
        
        
    }
}

extension SPWLOnePageDetailView{
    
    
    
    
    
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
                
                
                if !store.isPro(){
                    Button(action: {
                        showContentPremium.toggle()
                    }, label: {
                        Image("crown")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .center)
                            .frame(width: 60, height: 44)
                    })
                    
                }
                
                
 
                
                
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44  )
            
            
            Spacer()
            
            
            
            
            Button(action: {
                
                getPhotoPermission(status: {
                    b in
                    if b {
                        if store.isPro(){
                            downloadImageToGallery(title: "image\(wallpaper.id)", urlStr: (wallpaper.path.first?.path.full ?? ""))
                            ServerHelper.sendImageSpecialDataToServer(type: "download", id: wallpaper.id)
                        }else{
                            
                            DispatchQueue.main.async {
                                withAnimation(.easeInOut){
                                    if wallpaper.contentType == 1 {
                                        showBuySubAtScreen.toggle()
                                    }else{
                                        showDialogRv.toggle()
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
                .frame(width: 240, height: 48)
                .contentShape(Rectangle())
                .background(
                    Capsule().fill(Color.main)
                )
            }).padding(.horizontal, 16)
            
            
            
            
                .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .padding(.bottom, 48)
        }
        
    }
    
    
    
    @ViewBuilder
    func DialogGetWL(urlStr : String) -> some View{
        WatchRVtoGetWLDialog( urlStr: urlStr, show: $ctrlViewModel.showDialogRV, onRewarded: {
            rewardSuccess in
            ctrlViewModel.showDialogRV = false
            if rewardSuccess {
                DispatchQueue.main.async{
                    downloadImageToGallery(title: "image\(wallpaper.id)", urlStr: (wallpaper.path.first?.path.full ?? ""))
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
    
  
    
    
    func downloadImageToGallery(title : String, urlStr : String){
        DispatchQueue.main.async {
            ctrlViewModel.isDownloading = true
        }
        
        DownloadFileHelper.downloadFromUrlToSanbox(fileName: title, urlImage: URL(string: urlStr), onCompleted: {
            url in
            if let url {
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
                        if !store.isPro() && downloadCount == 1 {
                            ctrlViewModel.navigateView.toggle()
                        }else{
                            showRateView()
                        }
                    }else{
                        ctrlViewModel.isDownloading = false
                        showToastWithContent(image: "xmark", color: .red, mess: "Download Failure!")
                    }
                })
            }else{
                ctrlViewModel.isDownloading = false
                showToastWithContent(image: "xmark", color: .red, mess: "Download Failure!")
            }
        })
        
        
        
    }
}

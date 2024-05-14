//
//  WallpaperDetails.swift
//  WallpaperIOS
//
//  Created by Mac on 04/05/2023.
//

import SwiftUI
import PhotosUI
import SDWebImageSwiftUI
import GoogleMobileAds

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
            
          
                Preview()
           
            

            if ctrlViewModel.showControll{
                ControllView()
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
                        
                   
                        
               
         
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44 )
           
         
           
            

            
            Spacer()
            
            HStack(alignment: .bottom, spacing:  0, content: {
                
                VStack(spacing : 6){
                    ForEach(DetailWallpaperAction.allCases, id : \.rawValue){
                        action in
                        Image(action.rawValue)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .frame(width: 32, height: 44)
                            .opacity(ctrlViewModel.actionSelected == action ? 1.0 : 0.4)
                            .contentShape(Rectangle())
                            .onTapGesture(perform: {
                                ctrlViewModel.actionSelected = action
                            })
                    }
                    
                }
                .background(Color.black.opacity(0.4))
                .clipShape(Capsule())
                .padding(.leading, 16)
                
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
                    Image("detail_download")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .frame(width: 56, height: 56)
                        .background(Circle().fill(Color.main))

                }).disabled(ctrlViewModel.isDownloading)
                    .padding(.trailing, 16)
            }).padding(.bottom, 24)
            
            ZStack{
                if store.allowShowBanner(){
                    BannerAdViewInDetail(adStatus: $ctrlViewModel.adStatus)
                }
            }.frame(height: GADAdSizeBanner.size.height)
            
        
                  
                
                
            
                
             
        
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
       
    }
    
    @ViewBuilder
    func Preview() -> some View{
    
        ZStack(alignment: .top){
            if ctrlViewModel.actionSelected == .HOME {
                VStack{
                    Image("home_sc")
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 44)
                    
                    Spacer()
                }
                
                

            }else if ctrlViewModel.actionSelected == .LOCK{
                VStack{
                 
                    Image("lock_sc")
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 28)
                    Spacer()
                }
                
                
             
                  
            }
        }
        
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                            showActionAfterDownload(isUserPro: store.isPro(), onShowRate: {
                                ctrlViewModel.showRateView = true
                            }, onShowGifView: {
                                ctrlViewModel.showGifView.toggle()
                                ctrlViewModel.changeSubType()
                            })
                        })

              
                        
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


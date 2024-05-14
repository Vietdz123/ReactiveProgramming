//
//  SPWLOnePageDetailView.swift
//  WallpaperIOS
//
//  Created by Duc on 02/11/2023.
//

import SwiftUI
import SDWebImageSwiftUI
import GoogleMobileAds

struct SPWLOnePageDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    let wallpapers : [SpWallpaper]
    @State var index : Int
    
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
            

            
            TabView(selection: $index, content: {
                ForEach(0..<wallpapers.count, id: \.self){ i in
                    let wallpaper = wallpapers[i]
                    let urlStr = wallpaper.specialContentV2ID == 6 ? wallpaper.thumbnail?.path.full : wallpaper.path.first?.path.preview
                    AsyncImage(url: URL(string: urlStr ?? ""  )){
                        phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: getRect().width, height: getRect().height)
                                .opacity( (wallpaper.specialContentV2ID == 2 && ctrlViewModel.actionSelected == .LOCK) ? 0.0 : 1.0)
                                .clipped()
                                .overlay{
                                    if ctrlViewModel.actionSelected == .LOCK && wallpapers[index].specialContentV2ID == 2 {

                                        AsyncImage(url: URL(string:  wallpapers[index].thumbnail?.path.preview ?? ""  )){
                                            phase in
                                            if let image = phase.image {
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: getRect().width, height: getRect().height)
                                                    .clipped()
                                                    
                                                
                                            } else if phase.error != nil {
                                                AsyncImage(url: URL(string: wallpapers[index].thumbnail?.path.preview ?? "")){
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
                                     
                                     
                                        
                                    }
                                }
                            
                        } else if phase.error != nil {
                            AsyncImage(url: URL(string: wallpaper.path.first?.path.full ?? "")){
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
              

                }
            })
            .background(
                placeHolderImage()
                    .ignoresSafeArea()
            )
            .tabViewStyle(.page(indexDisplayMode: .never))
            .edgesIgnoringSafeArea(.all)
            
            
            Preview()
            
            
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
                let url  = wallpapers[index].path.first?.path.small ?? wallpapers[index].path.first?.path.preview ?? ""
                    WatchRVtoGetWLDialog( urlStr: url, show: $showDialogRv ,onRewarded: {
                        b in
                        showDialogRv = false
                        if b {
                            
                            downloadImageToGallery(title: "image\(wallpapers[index].id)", urlStr: (wallpapers[index].path.first?.path.full ?? ""))
                            ServerHelper.sendImageSpecialDataToServer(type: "download", id: wallpapers[index].id)
                        }else{
                            showToastWithContent(image: "xmark", color: .red, mess: "Ads not alaivable!")
                        }
                        
                    }, clickBuyPro: {
                        showDialogRv = false
                        showSub.toggle()
                    })
                
            }
            
        }

        .addBackground()

        .overlay(
            ZStack{
                if showContentPremium {
                    let url  = wallpapers[index].path.first?.path.small ?? wallpapers[index].path.first?.path.preview ?? ""
                    SpecialContentPremiumDialog(show: $showContentPremium, urlStr: url, onClickBuyPro: {
                        showContentPremium = false
                        showSub.toggle()
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
        .fullScreenCover(isPresented: $showSub, content: {
            EztSubcriptionView()
                .environmentObject(store)
        })

        
        
    }
}

extension SPWLOnePageDetailView{
    
    
    
    @ViewBuilder
    func Preview() -> some View{
    
        ZStack(alignment: .top){
            if ctrlViewModel.actionSelected == .HOME {
                VStack(spacing : 0){
                    Image("home_sc")
                        .resizable()
                        .scaledToFit()
                        .opacity( wallpapers[index].specialContentV2ID == 6 ? 0 : 1.0)
                        .padding(.top, 44)
                    Spacer()
                }
                

            }else if ctrlViewModel.actionSelected == .LOCK{
                VStack(spacing : 0){
                    Image("lock_sc")
                        .resizable()
                        .scaledToFit()
                        .opacity(wallpapers[index].specialContentV2ID == 2 || wallpapers[index].specialContentV2ID == 6 ? 0 : 1.0)
                        .padding(.top, 28)
                    Spacer()
                }

                  
            }
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
                
                
                if !store.isPro() && wallpapers[index].contentType == 1 {
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
                        if b {
                            if store.isPro(){
                                downloadImageToGallery(title: "image\(wallpapers[index].id)", urlStr: (wallpapers[index].path.first?.path.full ?? ""))
                                ServerHelper.sendImageSpecialDataToServer(type: "download", id: wallpapers[index].id)
                            }else{
                                
                                DispatchQueue.main.async {
                                    withAnimation(.easeInOut){
                                        if wallpapers[index].contentType == 1 {
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
        
    }
    
    
    
    @ViewBuilder
    func DialogGetWL(urlStr : String) -> some View{
        WatchRVtoGetWLDialog( urlStr: urlStr, show: $ctrlViewModel.showDialogRV, onRewarded: {
            rewardSuccess in
            ctrlViewModel.showDialogRV = false
            if rewardSuccess {
                DispatchQueue.main.async{
                    downloadImageToGallery(title: "image\(wallpapers[index].id)", urlStr: (wallpapers[index].path.first?.path.full ?? ""))
                    ServerHelper.sendImageDataToServer(type: "set", id: wallpapers[index].id)
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

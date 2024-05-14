//
//  LiveWLView.swift
//  WallpaperIOS
//
//  Created by Mac on 07/06/2023.
//

import SwiftUI
import Photos
import PhotosUI
import AVKit
import GoogleMobileAds

struct LiveWLView: View {
    let generator = UINotificationFeedbackGenerator()
    @EnvironmentObject var viewModel  : LiveWallpaperViewModel
    @EnvironmentObject var store : MyStore
    @EnvironmentObject var reward : RewardAd
    @EnvironmentObject var inter : InterstitialAdLoader
    
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("current_coin", store: .standard) var currentCoin = 0

    
    @State var currentIndex : Int = 0
    @State var adStatus : AdStatus = .loading
    @StateObject var ctrlViewModel : VideoControllViewModel = .init()
    
    @AppStorage("remoteCf_live_using_coin", store: .standard) var remoteCf_live_using_coin : Bool = false
    
    
    
    var body: some View {
        GeometryReader{
            proxy in
            let size = proxy.size
            
            ZStack{
                NavigationLink(isActive: $ctrlViewModel.navigateView, destination: {
                    EztSubcriptionView()
                        .environmentObject(store)
                        .navigationBarTitle("", displayMode: .inline)
                        .navigationBarHidden(true)
                }, label: {
                    EmptyView()
                })
                
                if !viewModel.wallpapers.isEmpty{
                    TabView(selection: $currentIndex){
                        ForEach(0..<viewModel.wallpapers.count, id: \.self){
                            i in
                            let livewallpaper = viewModel.wallpapers[i]
                            ReelsPlayerHorizontal( i: i, liveWL: livewallpaper, currentIndex: $currentIndex)
                                .frame(width: size.width)
                            //    .rotationEffect(.init(degrees: -90))
                                .ignoresSafeArea(.all)
                                .tag(i)
                                .onAppear(perform: {
                                 
                                    
                                    generator.notificationOccurred(.success)
                                    
                                    if viewModel.shouldLoadData(id: i){
                                        viewModel.getWallpapers()
                                    }
                                    
                                    if !store.isPro(){
                                        inter.showAd(onCommit: {})
                                    }
                                })
                            
                            
                        }
                        
                    }
                   // .rotationEffect(.init(degrees: 90))
                    .frame(width: size.height)
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(width: size.width)
                    .background(Color.black)
                    .onTapGesture {
                        ctrlViewModel.showControll.toggle()
                    }
                    
                    
                    Preview()
                    
                    if ctrlViewModel.showControll{
                        ControllView()
                        
                        
                    }
                    

                    
                }
            }
       
            
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
        
        .sheet(isPresented: $ctrlViewModel.showTuto, content: {
            TutorialContentView()
            
        })
        .overlay(
            ZStack{
                if ctrlViewModel.showContentPremium {
                    let url  = viewModel.wallpapers[currentIndex].thumbnail.first?.path.preview ?? ""
                        SpecialContentPremiumDialog(show: $ctrlViewModel.showContentPremium, urlStr: url, onClickBuyPro: {
                            ctrlViewModel.showContentPremium = false
                            ctrlViewModel.showSpeciaSub = true
                        })
                }
            }
            
        )
        .overlay{
            if ctrlViewModel.showDialogDownload{
                Dialog(liveWL: viewModel.wallpapers[currentIndex])
                
            }
            
        }
        .overlay{
            if ctrlViewModel.showGifView{
                GiftView()
            }
        }
        .overlay{
            if ctrlViewModel.showSpeciaSub {
                SpecialSubView(onClickClose: {
                    ctrlViewModel.showSpeciaSub = false
                })
            }
        }
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
    func ControllView() -> some View{
        VStack(spacing : 0){
            HStack(spacing : 0){
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
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
                    if !store.isPro() && viewModel.wallpapers[currentIndex].contentType == 1 {
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
            .frame(height: 44  )
            
            
            Spacer()
            
            HStack(alignment: .bottom, spacing:  0, content: {
                
                VStack(spacing : 6){
                    ForEach([DetailWallpaperAction.NONE, DetailWallpaperAction.LOCK], id : \.rawValue){
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
                            if store.isPro()  {
                                downloadVideoToGallery( title : "video\(  viewModel.wallpapers[currentIndex].id)" ,
                                                        urlVideoStr:  viewModel.wallpapers[currentIndex].path.first?.url.full ?? ""
                                                    )
                                ServerHelper.sendVideoSpecialDataToServer(id: viewModel.wallpapers[currentIndex].id)
                                
                                
                            }else{
                                
                                if  UserDefaults.standard.bool(forKey: "allow_download_free") == true {
                                    downloadVideoToGallery( title : "video\(  viewModel.wallpapers[currentIndex].id)" ,urlVideoStr:  viewModel.wallpapers[currentIndex].path.first?.url.full ?? "")
                                    ServerHelper.sendVideoSpecialDataToServer( id: viewModel.wallpapers[currentIndex].id)
                                }else{
                                    if viewModel.wallpapers[currentIndex].contentType == 1 {
                                        DispatchQueue.main.async {
                                            ctrlViewModel.showSpeciaSub = true
                                        }
                                    }else{
                                        DispatchQueue.main.async {
                                            withAnimation{
                                                ctrlViewModel.showDialogDownload.toggle()
                                            }
                                        }
                                    }
                                    
                                   
                                }
                                
                            }
                            
                        }
                    })
                    
                    
                    
                }, label: {
                    ZStack{
                        Circle().fill(Color.main)
                        if ctrlViewModel.isDownloading{
                        ProgressView()
                            .frame(width: 32, height: 32, alignment: .center)
                            .colorScheme(.light)
                        }else{
                            Image("detail_download")
                                .resizable()
                                .frame(width: 32, height: 32)
                        }
                    }.frame(width: 56, height: 56)
                       
                    
                }).disabled(ctrlViewModel.isDownloading)
                    .padding(.trailing, 16)
            }).padding(.bottom, 24)
            
                        ZStack{
                            if store.allowShowBanner(){
                                BannerAdViewInDetail(adStatus: $adStatus)
                            }
                        }.frame(height: GADAdSizeBanner.size.height)
            
            
            
            
            
            
        }
        .padding(.top, getSafeArea().top)
        .padding(.bottom, getSafeArea().bottom)
        
    }
    
    @ViewBuilder
    func Preview() -> some View{
        
        ZStack(alignment: .top){
            if ctrlViewModel.actionSelected == .HOME {
                
                VStack{
                    Image("home_sc")
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 44 + getSafeArea().top)
                    
                    
                    Spacer()
                }
                
                
            }else if ctrlViewModel.actionSelected == .LOCK{
                VStack{
                    Image("lock_sc")
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 28 + getSafeArea().top )
                    Spacer()
                }
                
                
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
    func Dialog(liveWL : SpLiveWallpaper) -> some View{
        
        if remoteCf_live_using_coin {
            
            SpecialSubView(onClickClose: {
                ctrlViewModel.showDialogDownload = false
            })
            
        }else{
            WatchRVtoGetWLDialog(urlStr: liveWL.thumbnail.first?.path.preview ?? "", show:  $ctrlViewModel.showDialogDownload, onRewarded: { b in
                if b{
                    ctrlViewModel.showDialogDownload.toggle()
                    downloadVideoToGallery( title : "video\(  viewModel.wallpapers[currentIndex].id)" ,
                                            urlVideoStr:  viewModel.wallpapers[currentIndex].path.first?.url.full ?? "")
                    ServerHelper.sendVideoSpecialDataToServer(id:  viewModel.wallpapers[currentIndex].id)
                }else{
                    DispatchQueue.main.async {
                        showToastWithContent(image: "xmark", color: .red, mess: "Ads is not ready!")
                    }
                }
                
            }, clickBuyPro: {
                ctrlViewModel.showDialogDownload.toggle()
                ctrlViewModel.navigateView.toggle()
            }).environmentObject(store)
                .environmentObject(reward)
        }
        
        
        
        
    }
    
    
    func downloadVideoToGallery(title : String, urlVideoStr : String){
        ctrlViewModel.isDownloading = true
        DownloadFileHelper.saveVideoLiveToLibSanbox(fileName: title, videoURL: URL(string: urlVideoStr), onCompleted: {
            urlVideo in
            if let urlVideo{
                print("LivePhoto path \(urlVideo.path)")
                LivePhotoUtil.convertVideo(urlVideo.path, complete: {
                    success, msg in
                    DispatchQueue.main.async {
                        ctrlViewModel.isDownloading = false
                        if success{
                            showToastWithContent(image: "checkmark", color: .green, mess: "Successful")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                                       showActionAfterDownload(isUserPro: store.isPro(), onShowRate: {
                                                           ctrlViewModel.showRateView = true
                                                       }, onShowGifView: {
                                                           ctrlViewModel.showGifView.toggle()
                                                           ctrlViewModel.changeSubType()
                                                       })
                                                   })
                            print("LivePhoto convert success")
                        }else{
                            showToastWithContent(image: "xmark", color: .green, mess: "Failure")
                            print("LivePhoto convert success")
                        }
                    }
                    
                    
                })
            }
            
            
            
        })
    }
    
    
}
